#include "RegularCrossroad.h"
#include "DataRoles.h"
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

RegularCrossroad::RegularCrossroad(QObject* parent)
  : QObject(parent)
{
  QObject::connect(&sides, &CrossroadSidesModel::rowsInserted, this, &RegularCrossroad::sidesChanged);
  QObject::connect(&sides, &CrossroadSidesModel::rowsRemoved, this, &RegularCrossroad::sidesChanged);
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
}

bool RegularCrossroad::Deserialize(QTextStream &stream)
{
  bool result = true;
  int sidesCount = stream.readLine().toInt(&result);
  if (!result)
  {
    qWarning() << "Can't deserialize crossroad";
    return false;
  }

  for (int i = sides.rowCount() - 1; i >= 0; --i)
    RemoveSide(i);

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

  if (!result)
  {
    qWarning() << "Invalid crossroad parameters";

    for (int i = sidesCount - 1; i >= 0; --i)
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
