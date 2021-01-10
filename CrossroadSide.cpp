#include "CrossroadSide.h"
#include <QtMath>
#include <QDebug>

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

QPoint CrossroadSide::AtStopLine(int laneIndex) const
{
  if (laneIndex < 0 || laneIndex >= inLanes.count()) {
      qWarning() << "Crossroad side does not have IN lane" << laneIndex;
      return QPoint(0, 0);
  }

  qreal normalAngle = getNormalInRadians();
  qreal crossroadLineAngle = normalAngle - M_PI/2;
  QPoint crossroadLineStart(-getLength()/2 * qCos(crossroadLineAngle), getLength()/2 * qSin(crossroadLineAngle));

  QPoint stopLineStart(crossroadLineStart.x() + inOffset * qCos(crossroadLineAngle)
                    + 15 * qCos(normalAngle),
                crossroadLineStart.y() - inOffset * qSin(crossroadLineAngle)
                    - 15 * qSin(normalAngle));

  return QPoint(stopLineStart.x() + (0.5 + laneIndex) * laneWidth * qCos(crossroadLineAngle),
                stopLineStart.y() - (0.5 + laneIndex) * laneWidth * qSin(crossroadLineAngle));
}

QPoint CrossroadSide::AtExit(int laneIndex) const
{
  if (laneIndex < 0 || laneIndex >= inLanes.count()) {
      qWarning() << "Crossroad side does not have OUT lane" << laneIndex;
      return QPoint(0, 0);
  }

  qreal normalAngle = getNormalInRadians();
  qreal crossroadLineAngle = normalAngle - M_PI/2;
  QPoint crossroadLineStart(-getLength()/2 * qCos(crossroadLineAngle), getLength()/2 * qSin(crossroadLineAngle));

  return QPoint(crossroadLineStart.x() +
                (inOffset + laneWidth * GetInLanesCount() + midOffset + laneWidth * (0.5 + GetOutLanesCount() - 1 - laneIndex)) * qCos(crossroadLineAngle),
                crossroadLineStart.y() -
                (inOffset + laneWidth * GetInLanesCount() + midOffset + laneWidth * (0.5 + GetOutLanesCount() - 1 - laneIndex)) * qSin(crossroadLineAngle));
}

QList<Lane*> CrossroadSide::getInLanes() const
{
  return inLanes.toList();
}

QList<Lane*> CrossroadSide::getOutLanes() const
{
  return outLanes.toList();
}

int CrossroadSide::GetInLanesCount() const
{
  return inLanes.size();
}

int CrossroadSide::GetOutLanesCount() const
{
  return outLanes.size();
}

int CrossroadSide::GetX() const
{
  return startX;
}

int CrossroadSide::GetY() const
{
  return startY;
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
