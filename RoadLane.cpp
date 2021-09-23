#include "RoadLane.h"
#include "DataRoles.h"
#include <QDebug>
#include <QLineF>

RoadLane::RoadLane(QObject *parent) : Curve(parent)
{
}

RoadLane::RoadLane(const QList<std::shared_ptr<CurvePoint>>& _trajectory, QObject *parent)
  : Curve(_trajectory, parent)
{
}

void RoadLane::AppendNewPoint(QPoint point, Node::NodeType type)
{
  AddPoint(std::make_shared<RoadPoint>(type, point.x(), point.y(), CalculateDistanceTo(point.x(), point.y())));
}

void RoadLane::AppendExistingPoint(int side, int lane, Node::NodeType type, qreal angle, RegularCrossroad *crossroad, QPoint position)
{
  QPoint newPointPosition;
  if (type == Node::CrossroadIn)
    newPointPosition = crossroad->AtStopLine(side, lane);
  else if (type == Node::CrossroadOut)
    newPointPosition = crossroad->AtExit(side, lane);
  else if (type == Node::RoadJoint)
    newPointPosition = position;

  int distanceTo = CalculateDistanceTo(newPointPosition.x(), newPointPosition.y());
  std::shared_ptr<CurvePoint> newPoint;

  if (type == Node::CrossroadIn || type == Node::CrossroadOut)
  {
      newPoint = std::make_shared<RoadPoint>(type, angle, crossroad, side, lane, distanceTo);
  }
  else if (type == Node::RoadJoint)
  {
      newPoint = std::make_shared<RoadPoint>(type, position.x(), position.y(), distanceTo);
  }
  else
  {
    qWarning() << "appending point of unsupported type" << type;
    return;
  }

  AddPoint(newPoint);
}

void RoadLane::Serialize(QTextStream &stream) const
{
  stream << rowCount() << Qt::endl;
  for (int i = 0; i < rowCount(); ++i)
    data(index(i, 0), DataRoles::RoadPointData).value<RoadPoint*>()->Serialize(stream);
}

RoadPoint::RoadPoint(Node::NodeType _type, int x, int y, qreal _distanceTo, qreal _angle, QObject* parent)
  : CurvePoint(x, y, _distanceTo, _angle, parent),
    type(_type)
  // angle is set separately
{
}

RoadPoint::RoadPoint(Node::NodeType _type, qreal _angle, RegularCrossroad* _crossroad, int _side, int _lane, qreal _distanceTo, QObject* parent)
  : CurvePoint(0, 0, _distanceTo, _angle, parent),
    type(_type), crossroadSide(_side), crossroadLane(_lane), crossroad(_crossroad)
{
}

QPoint RoadPoint::GetPosition() const
{
  if (type == Node::CrossroadIn)
    return QPoint(crossroad->AtStopLine(crossroadSide, crossroadLane));
  else if (type == Node::CrossroadOut)
    return QPoint(crossroad->AtExit(crossroadSide, crossroadLane));
  else if (type == Node::RoadJoint)
    return pos;

  qWarning() << "position for unsupported point type";
  return QPoint();
}

qreal RoadPoint::GetAngle() const
{
  if (type == Node::CrossroadIn)
    return (crossroad->GetSide(crossroadSide)->GetNormal() + 180) % 360;
  else if (type == Node::CrossroadOut)
    return crossroad->GetSide(crossroadSide)->GetNormal();
  else if (type == Node::RoadJoint)
    return angle;

  qWarning() << "angle for unsupported point type";
  return 0.0;
}

void RoadPoint::Serialize(QTextStream &stream) const
{
  stream << (int)type
         << " " << (crossroad ? crossroad->GetId() : "") << " " << crossroadSide << " " << crossroadLane
         << " " << distanceTo
         << " " << angle << " " << pos.x() << " " << pos.y()
         << Qt::endl;
}
