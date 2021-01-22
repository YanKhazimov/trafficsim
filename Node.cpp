#include "Node.h"
#include <QDebug>

Node::Node(QObject *parent) : QObject(parent)
{
}

Node::Node(NodeType _type, RegularCrossroad* _crossroad, int _side, int _lane, QObject *parent)
  : QObject(parent), type(_type), crossroad(_crossroad), side(_side), lane(_lane)
{
}

bool Node::operator ==(const Node &other) const
{
  return type == other.type &&
      crossroad->GetId() == other.crossroad->GetId() &&
      side == other.side &&
      lane == other.lane;
}

QPoint Node::GetPosition() const
{
  if (type == NodeType::CrossroadIn)
    return QPoint(crossroad->AtStopLine(side, lane));
  else if (type == NodeType::CrossroadOut)
    return QPoint(crossroad->AtExit(side, lane));

  qWarning() << "requested position of unsupported node type" << (int)type;
  return QPoint();
}
