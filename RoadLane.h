#pragma once

#include <QAbstractListModel>
#include <memory>
#include "Node.h"
#include "RegularCrossroad.h"

class RoadPoint : public QObject
{
  Q_OBJECT

  QPoint pos;
  qreal angle = 0.0;

public:
  explicit RoadPoint(QObject* parent = nullptr);
  RoadPoint(Node::NodeType type, int x, int y, qreal distanceTo, qreal angle = 0.0, QObject* parent = nullptr);
  RoadPoint(Node::NodeType type, qreal angle, RegularCrossroad* crossroad, int side, int lane, qreal distanceTo, QObject* parent = nullptr);

  Node::NodeType type = Node::None;
  int crossroadSide = -1;
  int crossroadLane = -1;
  RegularCrossroad* crossroad = nullptr;
  qreal distanceTo = 0.0;

  QPoint GetPosition() const;
  qreal GetAngle() const;
  void SetAngle(qreal counterClockwiseValue);

  void Serialize(QTextStream& stream) const;
};

class RoadLane : public QAbstractListModel
{
  Q_OBJECT
  Q_DISABLE_COPY(RoadLane)

  QList<std::shared_ptr<RoadPoint>> trajectory;

public:
  // QAbstractListModel
  Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
  Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  QHash<int, QByteArray> roleNames() const;

  explicit RoadLane(QObject *parent = nullptr);
  RoadLane(const QList<std::shared_ptr<RoadPoint>>& trajectory, QObject *parent = nullptr);
  Q_INVOKABLE void AppendNewPoint(QPoint point, Node::NodeType type);
  Q_INVOKABLE void AppendExistingPoint(int side, int lane, Node::NodeType type, qreal angle, RegularCrossroad* crossroad, QPoint position);
  Q_INVOKABLE void RemoveLastPoint();
  Q_INVOKABLE void Clear();
  Q_INVOKABLE void SetAngle(int row, qreal angle);
  const QList<std::shared_ptr<RoadPoint>>& GetTrajectory() const;
  Q_INVOKABLE QPoint GetPoint(int row) const;
  Q_INVOKABLE qreal GetDistanceTo(int row) const;

  void Serialize(QTextStream& stream) const;
  bool Deserialize(QTextStream& stream);

signals:
  void trajectoryReset();
  void pointAppended();
};
