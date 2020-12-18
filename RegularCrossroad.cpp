#include "RegularCrossroad.h"

RegularCrossroad::RegularCrossroad(QObject* parent)
  : QObject(parent)
{
}

bool RegularCrossroad::AddSide(int laneWidth, int startX, int startY, qreal normal, int inLanesCount, int outLanesCount,
                               int inOffset, int outOffset, int midOffset)
{
  bool validSideParams = true;
  sides.append(new CrossroadSide(laneWidth, startX, startY, normal, inLanesCount, outLanesCount, inOffset, outOffset, midOffset));
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
