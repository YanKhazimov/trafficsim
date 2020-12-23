#include "CrossroadSide.h"
#include <QtMath>

bool CrossroadSide::AddInLane()
{
  inLanes.push_back(nullptr);
  emit parametersChanged();
  return true;
}

bool CrossroadSide::RemoveInLane()
{
  if (inLanes.empty())
    return false;

  inLanes.pop_back();
  emit parametersChanged();
  return true;
}

bool CrossroadSide::AddOutLane()
{
  outLanes.push_back(nullptr);
  emit parametersChanged();
  return true;
}

bool CrossroadSide::RemoveOutLane()
{
  if (outLanes.empty())
    return false;

  outLanes.pop_back();
  emit parametersChanged();
  return true;
}

void CrossroadSide::Serialize(QTextStream &stream) const
{
  stream << laneWidth << " " << startX << " " << startY << " " << GetNormal()
         << " " << inLanes.count() << " " << outLanes.count()
         << " " << inOffset << " " << outOffset << " " << midOffset << Qt::endl;
}

QList<Lane*> CrossroadSide::getInLanes() const
{
  return inLanes.toList();
}

QList<Lane*> CrossroadSide::getOutLanes() const
{
  return outLanes.toList();
}

int CrossroadSide::getInLanesCount() const
{
  return inLanes.size();
}

int CrossroadSide::getOutLanesCount() const
{
  return outLanes.size();
}

int CrossroadSide::getNormal() const
{
  return normal;
}

void CrossroadSide::setNormal(int degrees)
{
  while (degrees < 0)
    degrees += 360;
  normal = degrees % 360;
  emit parametersChanged();
}

qreal CrossroadSide::getNormalInRadians() const
{
  return qDegreesToRadians(static_cast<qreal>(normal));
}

int CrossroadSide::getLength() const
{
  return inOffset + inLanes.size() * laneWidth +
      midOffset + outLanes.size() * laneWidth +
      outOffset;
}

CrossroadSide::CrossroadSide(QObject* parent)
  : QObject(parent), laneWidth(40)
{
}

CrossroadSide::CrossroadSide(int _laneWidth, int _startX, int _startY, int _normal, int inLanesCount, int outLanesCount,
                             int _inOffset, int _outOffset, int _midOffset, QObject* parent)
  : QObject(parent), laneWidth(_laneWidth), normal(_normal), inOffset(_inOffset), outOffset(_outOffset), midOffset(_midOffset), startX(_startX), startY(_startY)
{
  inLanes.resize(inLanesCount);
  outLanes.resize(outLanesCount);
}

qreal CrossroadSide::GetNormal() const
{
  return normal;
}
