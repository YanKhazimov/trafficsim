#include "RegularCrossroad.h"
#include <QtMath>
#include <QDebug>

RegularCrossroad::RegularCrossroad(QObject* parent)
  : QObject(parent)
{
}

bool RegularCrossroad::AddSide(int laneWidth, int startX, int startY, qreal normal, int inLanesCount, int outLanesCount,
                               int inOffset, int outOffset, int midOffset)
{
  bool validSideParams = true;
  sides.append(new CrossroadSide(laneWidth, startX, startY, static_cast<int>(qRadiansToDegrees(normal) + 360) % 360, inLanesCount, outLanesCount, inOffset, outOffset, midOffset));
  std::sort(sides.begin(), sides.end(), [](CrossroadSide* left, CrossroadSide* right) {
    return left->GetNormal() < right->GetNormal();
  });
  emit sidesChanged();
  return validSideParams;
}

bool RegularCrossroad::RemoveSide(int index)
{
  if (index < 0 || index >= sides.size())
    return false;

  delete sides[index];
  sides.removeAt(index);
  emit sidesChanged();
  return true;
}

bool RegularCrossroad::Validate() const
{
  return true;
}

int RegularCrossroad::CountSides() const
{
  return sides.count();
}

QList<CrossroadSide*> RegularCrossroad::GetSides() const
{
  return sides;
}

RegularCrossroad::~RegularCrossroad()
{
  for (auto side: sides)
    delete side;
}

void RegularCrossroad::Serialize(QTextStream &stream) const
{
  stream << CountSides() << Qt::endl;
  for (CrossroadSide* side : GetSides())
    side->Serialize(stream);
}

bool RegularCrossroad::Deserialize(QTextStream &stream)
{
  bool result = true;
  int sidesCount = stream.readLine().toInt(&result);
  if (!result)
  {
    qDebug() << "Can't deserialize crossroad";
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

  if (!result)
  {
    qDebug() << "Invalid crossroad parameters";

    for (int i = sidesCount; i >= 0; --i)
      RemoveSide(i);
  }

  emit sidesChanged();
  return result;
}
