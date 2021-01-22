#include "RoadLane.h"
#include <QDebug>

RoadLane::RoadLane(QObject *parent) : QObject(parent)
{
}

RoadLane::RoadLane(const QList<QPoint>& _trajectory, QObject *parent) : QObject(parent)
{
  for (const QPoint& point : _trajectory)
    trajectory.append(point);
}

void RoadLane::AppendPoint(QPoint point, Node::NodeType type)
{
  //qWarning() << type;
  trajectory.append(point);
  emit pointAppended();
}

void RoadLane::RemoveLastPoint()
{
  if (!trajectory.empty())
  {
    trajectory.pop_back();
    emit trajectoryReset();
  }
}

void RoadLane::Clear()
{
  if (!trajectory.empty())
  {
    trajectory.clear();
    emit trajectoryReset();
  }
}

const QList<QPoint> &RoadLane::GetTrajectory() const
{
  return trajectory;
}
