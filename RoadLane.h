#pragma once

#include "Node.h"
#include "RegularCrossroad.h"
#include "Curve.h"

class RoadPoint : public CurvePoint
{
  Q_OBJECT

public:
  RoadPoint(Node::NodeType type, int x, int y, qreal distanceTo, qreal angle = 0.0, QObject* parent = nullptr);
  RoadPoint(Node::NodeType type, qreal angle, RegularCrossroad* crossroad, int side, int lane, qreal distanceTo, QObject* parent = nullptr);

  Node::NodeType type = Node::None;
  int crossroadSide = -1;
  int crossroadLane = -1;
  RegularCrossroad* crossroad = nullptr;

  QPoint GetPosition() const override;
  qreal GetAngle() const override;

  void Serialize(QTextStream& stream) const override;
};

class RoadLane : public Curve
{
  Q_OBJECT
  Q_DISABLE_COPY(RoadLane)

public:
  explicit RoadLane(QObject *parent = nullptr);
  RoadLane(const QList<std::shared_ptr<CurvePoint>>& trajectory, QObject *parent = nullptr);
  Q_INVOKABLE void AppendNewPoint(QPoint point, Node::NodeType type);
  Q_INVOKABLE void AppendExistingPoint(int side, int lane, Node::NodeType type, qreal angle, RegularCrossroad* crossroad, QPoint position);

  void Serialize(QTextStream& stream) const override;
};
