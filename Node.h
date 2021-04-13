#pragma once
#include <QObject>
#include "RegularCrossroad.h"

class Node : public QObject
{
  Q_OBJECT

public:
  enum NodeType {
    None,
    CrossroadIn,
    CrossroadOut,
    RoadJoint
  };
  Q_ENUMS(NodeType)

  explicit Node(QObject *parent = nullptr);
  explicit Node(NodeType type, RegularCrossroad *crossroad, int side, int lane, QPoint pos = QPoint(), qreal angle = 0.0, QObject *parent = nullptr);

  NodeType type = NodeType::None;
  RegularCrossroad* crossroad = nullptr;
  int side = -1;
  int lane = -1;
  QPoint pos;
  qreal angle = 0.0;

  bool operator ==(const Node& other) const;
  QPoint GetPosition() const;
  qreal GetAngle() const;

signals:
  void parametersChanged();
};
Q_DECLARE_METATYPE(Node::NodeType)
