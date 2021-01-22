#pragma once

#include <QObject>
#include "Node.h"

class RoadLane : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(RoadLane)

  Q_PROPERTY(QList<QPoint> Trajectory MEMBER trajectory NOTIFY trajectoryReset)

  QList<QPoint> trajectory;

public:
  explicit RoadLane(QObject *parent = nullptr);
  RoadLane(const QList<QPoint>& trajectory, QObject *parent = nullptr);
  Q_INVOKABLE void AppendPoint(QPoint point, Node::NodeType type);
  Q_INVOKABLE void RemoveLastPoint();
  Q_INVOKABLE void Clear();
  const QList<QPoint>& GetTrajectory() const;

signals:
  void trajectoryReset();
  void pointAppended();
};
