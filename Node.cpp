#include "Node.h"
#include <QDebug>

Node::Node(QObject *parent) : QObject(parent)
{
}

Node::Node(NodeType _type, RegularCrossroad* _crossroad, int _side, int _lane, QPoint _pos, qreal _angle, QObject *parent)
  : QObject(parent), type(_type), crossroad(_crossroad), side(_side), lane(_lane), pos(_pos), angle(_angle)
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
  else if (type == NodeType::RoadJoint)
    return pos;

  qWarning() << "requested position of unsupported node type" << (int)type;
  return QPoint();
}

qreal Node::GetAngle() const
{
  if (type == Node::CrossroadIn)
    return (crossroad->GetSide(side)->GetNormal() + 180) % 360;
  else if (type == Node::CrossroadOut)
    return crossroad->GetSide(side)->GetNormal();
  else if (type == Node::RoadJoint)
    return angle;

  qWarning() << "angle for unsupported point type";
  return 0.0;
}
