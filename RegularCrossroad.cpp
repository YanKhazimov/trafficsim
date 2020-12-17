#include "RegularCrossroad.h"

RegularCrossroad::RegularCrossroad(QObject* parent)
  : QObject(parent)
{
}

bool RegularCrossroad::AddSide(int startX, int startY, qreal normal, int inLanesCount, int outLanesCount,
                               int inOffset, int outOffset, int midOffset)
{
  bool validSideParams = true;
  sides.append(new CrossroadSide(startX, startY, normal, inLanesCount, outLanesCount, inOffset, outOffset, midOffset));
  emit sidesChanged();
  return validSideParams;
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
