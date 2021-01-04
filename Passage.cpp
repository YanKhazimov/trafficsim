#include "Passage.h"

Passage::Passage(QObject* parent)
  : QObject(parent)
{
}

Passage::Passage(int _inSideIndex, int _inLaneIndex, int _outSideIndex, int _outLaneIndex, QObject* parent)
  : QObject(parent)
{
  inSideIndex = _inSideIndex;
  inLaneIndex = _inLaneIndex;
  outSideIndex = _outSideIndex;
  outLaneIndex = _outLaneIndex;
}

void Passage::SetInLane(int sideIndex, int laneIndex)
{
  inSideIndex = sideIndex;
  inLaneIndex = laneIndex;
  emit parametersChanged();
}

void Passage::SetOutLane(int sideIndex, int laneIndex)
{
  outSideIndex = sideIndex;
  outLaneIndex = laneIndex;
  emit parametersChanged();
}

void Passage::Reset()
{
  inSideIndex = -1;
  inLaneIndex = -1;
  outSideIndex = -1;
  outLaneIndex = -1;
  emit parametersChanged();
}
