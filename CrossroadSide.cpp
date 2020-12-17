#include "CrossroadSide.h"
#include <QtMath>

int CrossroadSide::_GetLength(int laneWidth) const
{
  return inOffset + inLanes.size() * laneWidth +
      midOffset + outLanes.size() * laneWidth +
      outOffset;
}

int CrossroadSide::CountInLanes() const
{
  return inLanes.size();
}

int CrossroadSide::CountOutLanes() const
{
  return outLanes.size();
}

qreal CrossroadSide::GetNormal() const
{
  return normal;
}

CrossroadSide::CrossroadSide(QObject* parent)
  : QObject(parent)
{
}

CrossroadSide::CrossroadSide(int _startX, int _startY, qreal _normal, int inLanesCount, int outLanesCount,
                             int _inOffset, int _outOffset, int _midOffset, QObject* parent)
  : QObject(parent), normal(qDegreesToRadians(_normal)), inOffset(_inOffset), outOffset(_outOffset), midOffset(_midOffset), startX(_startX), startY(_startY)
{
  inLanes.resize(inLanesCount);
  outLanes.resize(outLanesCount);
}
