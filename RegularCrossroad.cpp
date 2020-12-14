#include "RegularCrossroad.h"

RegularCrossroad::RegularCrossroad(QObject* parent)
  : QObject(parent)
{
}

bool RegularCrossroad::AddSide(qreal angle, CrossroadSide* side)
{
  sides[angle] = side;
  return true;
}

int RegularCrossroad::CountSides() const
{
  return sides.count();
}

CrossroadSide *RegularCrossroad::GetSide1() const
{
  return sides.count() > 0 ? *sides.begin() : nullptr;
}

CrossroadSide *RegularCrossroad::GetSide2() const
{
  return sides.count() > 0 ? sides.value(315.0) : nullptr;
}
