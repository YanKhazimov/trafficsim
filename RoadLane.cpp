#include "RoadLane.h"
#include "DataRoles.h"
#include <QDebug>
#include <QLineF>

int RoadLane::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return trajectory.count();
}

QVariant RoadLane::data(const QModelIndex &index, int role) const
{
  int row = index.row();
  if (row < 0 || row >= rowCount()) {
    qWarning() << "requesting data for road point" << row;
    return QVariant();
  }

  if (role == DataRoles::NodePosition)
  {
    return QVariant::fromValue(trajectory[row]->GetPosition());
  }
  else if (role == DataRoles::RoadPointData)
  {
    return QVariant::fromValue(trajectory[row].get());
  }
  else if (role == DataRoles::DistanceAlongRoad)
  {
    return trajectory[row]->distanceTo;
  }

  return QVariant();
}

QHash<int, QByteArray> RoadLane::roleNames() const
{
  return {
    { DataRoles::NodePosition, "RoleNodePosition" }
  };
}

RoadLane::RoadLane(QObject *parent) : QAbstractListModel(parent)
{
}

RoadLane::RoadLane(const QList<std::shared_ptr<RoadPoint>>& _trajectory, QObject *parent) : QAbstractListModel(parent)
{
  for (const std::shared_ptr<RoadPoint>& point : _trajectory)
    trajectory.append(point);
}

void RoadLane::AppendNewPoint(QPoint point, Node::NodeType type)
{
  int count = rowCount();
  beginInsertRows(QModelIndex(), count, count);
  int distanceTo = 0.0;
  if (count > 0)
  {
    distanceTo = index(count - 1, 0).data(DataRoles::DistanceAlongRoad).toDouble() +
        QLineF(point, index(count - 1, 0).data(DataRoles::NodePosition).toPointF()).length();
  }
  trajectory.append(std::make_shared<RoadPoint>(type, point.x(), point.y(), distanceTo));
  emit pointAppended();
  endInsertRows();
}

void RoadLane::AppendExistingPoint(int side, int lane, Node::NodeType type, qreal angle, RegularCrossroad *crossroad, QPoint position)
{
  int count = rowCount();
  beginInsertRows(QModelIndex(), count, count);

  int distanceTo = 0.0;
  if (count > 0)
  {
    QPoint prevPosition;
    if (type == Node::CrossroadIn)
      prevPosition = crossroad->AtStopLine(side, lane);
    else if (type == Node::CrossroadOut)
      prevPosition = crossroad->AtExit(side, lane);
    else if (type == Node::RoadJoint)
      prevPosition = position;

    distanceTo = index(count - 1, 0).data(DataRoles::DistanceAlongRoad).toDouble() +
        QLineF(prevPosition, index(count - 1, 0).data(DataRoles::NodePosition).toPointF()).length();
  }

  if (type == Node::CrossroadIn || type == Node::CrossroadOut)
  {
    trajectory.append(std::make_shared<RoadPoint>(type, angle, crossroad, side, lane, distanceTo));
    emit pointAppended();
  }
  else if (type == Node::RoadJoint)
  {
    trajectory.append(std::make_shared<RoadPoint>(type, position.x(), position.y(), distanceTo));
    emit pointAppended();
  }
  else
  {
    qWarning() << "appending point of unsupported type";
  }

  endInsertRows();
}

void RoadLane::RemoveLastPoint()
{
  if (!trajectory.empty())
  {
    int count = rowCount();
    beginRemoveRows(QModelIndex(), count - 1, count - 1);
    trajectory.pop_back();
    emit trajectoryReset();
    endRemoveRows();
  }
}

void RoadLane::Clear()
{
  beginResetModel();
  if (!trajectory.empty())
  {
    trajectory.clear();
    emit trajectoryReset();
  }
  endResetModel();
}

void RoadLane::SetAngle(int row, qreal angle)
{
  if (row < 0 || row >= rowCount()) {
    qWarning() << "setting angle for road point" << row;
    return;
  }

  // angle is clockwise; transforming to counter-clockwise

  trajectory[row]->angle = (-(int)angle + 360) % 360;
  emit dataChanged(index(row, 0), index(row, 0), { DataRoles::RoadPointAngle });
}

const QList<std::shared_ptr<RoadPoint>> &RoadLane::GetTrajectory() const
{
  return trajectory;
}

QPoint RoadLane::GetPoint(int row) const
{
  if (row < 0 || row >= rowCount()) {
    qWarning() << "getting road point " << row;
    return QPoint();
  }

  return trajectory[row]->GetPosition();
}

qreal RoadLane::GetDistanceTo(int row) const
{
  if (row < 0 || row >= rowCount()) {
    qWarning() << "getting distance to road point" << row;
    return 0.0;
  }

  return trajectory[row]->distanceTo;
}

void RoadLane::Serialize(QTextStream &stream) const
{
  stream << rowCount() << Qt::endl;
  for (int i = 0; i < rowCount(); ++i)
    data(index(i, 0), DataRoles::RoadPointData).value<RoadPoint*>()->Serialize(stream);
}

bool RoadLane::Deserialize(QTextStream &stream)
{
  return false;
}

RoadPoint::RoadPoint(QObject *parent)
  : QObject(parent)
{
}

RoadPoint::RoadPoint(Node::NodeType _type, int x, int y, qreal _distanceTo, qreal _angle, QObject* parent)
  : QObject(parent), pos(x, y), type(_type), angle(_angle), distanceTo(_distanceTo)
  // angle is set separately
{
}

RoadPoint::RoadPoint(Node::NodeType _type, qreal _angle, RegularCrossroad* _crossroad, int _side, int _lane, qreal _distanceTo, QObject* parent)
  : QObject(parent), type(_type), crossroadSide(_side), crossroadLane(_lane), angle(_angle), crossroad(_crossroad), distanceTo(_distanceTo)
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
