#include "CrossroadSide.h"

int CrossroadSide::GetLength(int laneWidth) const
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

CrossroadSide::CrossroadSide(QObject* parent)
  : QObject(parent)
{
}

CrossroadSide::CrossroadSide(int inLanesCount, int outLanesCount, int _inOffset, int _outOffset, int _midOffset, QObject* parent)
  : QObject(parent), inOffset(_inOffset), outOffset(_outOffset), midOffset(_midOffset)
{
  inLanes.resize(inLanesCount);
  outLanes.resize(outLanesCount);
}
