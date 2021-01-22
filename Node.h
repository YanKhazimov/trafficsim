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
  explicit Node(NodeType type, RegularCrossroad *crossroad, int side, int lane, QObject *parent = nullptr);

  NodeType type = NodeType::None;
  RegularCrossroad* crossroad = nullptr;
  int side = -1;
  int lane = -1;

  bool operator ==(const Node& other) const;
  QPoint GetPosition() const;

signals:
  void parametersChanged();
};
Q_DECLARE_METATYPE(Node::NodeType)
