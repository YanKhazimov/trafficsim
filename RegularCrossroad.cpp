#include "RegularCrossroad.h"

RegularCrossroad::RegularCrossroad(QObject* parent)
  : QObject(parent)
{
}

bool RegularCrossroad::AddSide(CrossroadSide* side)
{
  sides.append(side);
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
