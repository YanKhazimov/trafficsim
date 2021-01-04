#include "RegularCrossroad.h"
#include "DataRoles.h"
#include <memory>
#include <QtMath>
#include <QDebug>

Passage *RegularCrossroad::getPassageUnderConstruction()
{
  return &passageUnderConstruction;
}

CrossroadPassagesModel *RegularCrossroad::getPassages()
{
  return &passages;
}

bool RegularCrossroad::AddPassage(int inSideIndex, int inLaneIndex, int outSideIndex, int outLaneIndex)
{
  bool validPassageParams = true;
  std::unique_ptr<Passage> newPassage = std::make_unique<Passage>(inSideIndex, inLaneIndex, outSideIndex, outLaneIndex);
  passages.AddPassage(newPassage.get());
  return validPassageParams;
}

bool RegularCrossroad::RemovePassage(int index)
{
  return passages.RemovePassage(index);
}

RegularCrossroad::RegularCrossroad(QObject* parent)
  : QObject(parent)
{
  QObject::connect(&sides, &CrossroadSidesModel::rowsInserted, this, &RegularCrossroad::sidesChanged);
  QObject::connect(&sides, &CrossroadSidesModel::rowsRemoved, this, &RegularCrossroad::sidesChanged);
  QObject::connect(&sides, &CrossroadSidesModel::rowsInserted, &passages, &CrossroadPassagesModel::onSidesInserted);
  QObject::connect(&sides, &CrossroadSidesModel::rowsRemoved, &passages, &CrossroadPassagesModel::onSidesRemoved);

  QObject::connect(&passages, &CrossroadPassagesModel::rowsInserted, this, &RegularCrossroad::passagesChanged);
  QObject::connect(&passages, &CrossroadPassagesModel::rowsRemoved, this, &RegularCrossroad::passagesChanged);
}

bool RegularCrossroad::AddSide(int laneWidth, int startX, int startY, qreal normal, int inLanesCount, int outLanesCount,
                               int inOffset, int outOffset, int midOffset)
{
  bool validSideParams = true;

  sides.AddSide(laneWidth, startX, startY, static_cast<int>(qRadiansToDegrees(normal) + 360) % 360, inLanesCount, outLanesCount, inOffset, outOffset, midOffset);

  return validSideParams;
}

bool RegularCrossroad::RemoveSide(int index)
{
  return sides.RemoveSide(index);
}

CrossroadSide* RegularCrossroad::GetSide(int index)
{
  return sides.data(sides.index(index, 0), DataRoles::CrossroadSideData).value<CrossroadSide*>();
}

bool RegularCrossroad::Validate() const
{
  return true;
}

CrossroadSidesModel* RegularCrossroad::getSides()
{
  return &sides;
}

void RegularCrossroad::Serialize(QTextStream &stream) const
{
  stream << sides.rowCount() << Qt::endl;
  for (int i = 0; i < sides.rowCount(); ++i)
    sides.data(sides.index(i, 0), DataRoles::CrossroadSideData).value<CrossroadSide*>()->Serialize(stream);

  stream << passages.rowCount() << Qt::endl;
  for (int i = 0; i < passages.rowCount(); ++i)
    passages.data(passages.index(i, 0), DataRoles::CrossroadPassageData).value<Passage*>()->Serialize(stream);
}

bool RegularCrossroad::Deserialize(QTextStream &stream)
{
  // first removing current passages
  for (int i = passages.rowCount() - 1; i >= 0; --i)
    RemovePassage(i);

  // then removing current sides
  for (int i = sides.rowCount() - 1; i >= 0; --i)
    RemoveSide(i);

  bool result = true;

  // first adding new sides
  int sidesCount = stream.readLine().toInt(&result);
  if (!result)
  {
    qWarning() << "Can't deserialize crossroad";
    return false;
  }

  for (int i = 0; i < sidesCount; ++i)
  {
    QStringList sideParameters = stream.readLine().split(' ', Qt::SkipEmptyParts);
    if (sideParameters.count() != 9)
    {
      result = false;
      break;
    }

    int laneWidth = sideParameters[0].toInt(&result); // add validation
    int startX = sideParameters[1].toInt(&result);
    int startY = sideParameters[2].toInt(&result);
    int normal = sideParameters[3].toInt(&result);
    int inLanesCount = sideParameters[4].toInt(&result);
    int outLanesCount = sideParameters[5].toInt(&result);
    int inOffset = sideParameters[6].toInt(&result);
    int outOffset = sideParameters[7].toInt(&result);
    int midOffset = sideParameters[8].toInt(&result);
    result &= AddSide(laneWidth, startX, startY, qDegreesToRadians(double(normal)), inLanesCount, outLanesCount, inOffset, outOffset, midOffset);
  }

  // then adding new passages
  int passagesCount = stream.readLine().toInt(&result);

  for (int i = 0; i < passagesCount; ++i)
  {
    QStringList passageParameters = stream.readLine().split(' ', Qt::SkipEmptyParts);
    if (passageParameters.count() != 4)
    {
      result = false;
      break;
    }

    int inSideIndex = passageParameters[0].toInt(&result); // add validation
    int inLaneIndex = passageParameters[1].toInt(&result);
    int outSideIndex = passageParameters[2].toInt(&result);
    int outLaneIndex = passageParameters[3].toInt(&result);
    result &= AddPassage(inSideIndex, inLaneIndex, outSideIndex, outLaneIndex);
  }

  if (!result)
  {
    qWarning() << "Invalid crossroad parameters";

    for (int i = passages.rowCount() - 1; i >= 0; --i)
      RemovePassage(i);

    for (int i = sides.rowCount() - 1; i >= 0; --i)
      RemoveSide(i);
  }

  return result;
}

void RegularCrossroad::SetNewPassageInLane(int sideIndex, int laneIndex)
{
  passageUnderConstruction.SetInLane(sideIndex, laneIndex);
}

void RegularCrossroad::SetNewPassageOutLane(int sideIndex, int laneIndex)
{
  passageUnderConstruction.SetOutLane(sideIndex, laneIndex);
}

void RegularCrossroad::ConstructPassage()
{
  passages.AddPassage(&passageUnderConstruction);
  passageUnderConstruction.Reset();
}
