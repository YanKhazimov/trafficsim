#include "Curve.h"
#include "DataRoles.h"
#include <QDebug>
#include <QLineF>

CurvePoint::CurvePoint(int x, int y, qreal distance, qreal _angle, QObject *parent)
  : QObject(parent), pos(x, y), angle(_angle), distanceTo(distance)
{
}

QPoint CurvePoint::GetPosition() const
{
  return pos;
}

qreal CurvePoint::GetAngle() const
{
  return angle;
}

void CurvePoint::SetAngle(qreal counterClockwiseValue)
{
  angle = counterClockwiseValue;
}

qreal CurvePoint::GetDistanceTo() const
{
  return distanceTo;
}

void CurvePoint::Serialize(QTextStream &stream) const
{
  stream << pos.x() << " " << pos.y() << " " << angle << Qt::endl;
}

Curve::Curve(QObject *parent)
  : QAbstractListModel(parent)
{
}

Curve::Curve(const QList<std::shared_ptr<CurvePoint>>& _points, QObject *parent)
  : QAbstractListModel(parent), points(_points)
{
}

int Curve::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return points.size();
}

QVariant Curve::data(const QModelIndex &index, int role) const
{
  int row = index.row();
  if (row < 0 || row >= rowCount()) {
    qWarning() << "requesting data by role" << role << "for curve point" << row;
    return QVariant();
  }

  if (role == DataRoles::NodePosition)
  {
    return QVariant::fromValue(points[row]->GetPosition());
  }
  else if (role == DataRoles::RoadPointData)
  {
    return QVariant::fromValue(points[row].get());
  }
  else if (role == DataRoles::DistanceAlongCurve)
  {
    return points[row]->GetDistanceTo();
  }

  return QVariant();
}

QHash<int, QByteArray> Curve::roleNames() const
{
  return {
    { DataRoles::NodePosition, "RoleNodePosition" }
  };
}

const QList<std::shared_ptr<CurvePoint>>& Curve::GetPoints()
{
  return points;
}

void Curve::Clear()
{
  if (!points.empty())
  {
    beginResetModel();
    points.clear();
    endResetModel();
    emit trajectoryReset();
  }
}

void Curve::AddPoint(std::shared_ptr<CurvePoint> point)
{
  beginInsertRows(QModelIndex(), rowCount(), rowCount());
  points.append(point);
  endInsertRows();

  emit pointAppended();
}

bool Curve::RemoveLastPoint()
{
  int count = rowCount();

  if (count == 0)
    return false;

  beginRemoveRows(QModelIndex(), count - 1, count - 1);
  points.removeLast();
  endRemoveRows();

  emit trajectoryReset();
  return true;
}

void Curve::SetAngle(int row, qreal angle)
{
  if (row < 0 || row >= rowCount()) {
    qWarning() << "setting angle for curve point" << row;
    return;
  }

  // angle is clockwise; transforming to counter-clockwise
  points[row]->SetAngle((-(int)angle + 360) % 360);
  emit dataChanged(index(row, 0), index(row, 0), { DataRoles::RoadPointAngle });
}

QPoint Curve::GetPoint(int row) const
{
  return data(index(row, 0), DataRoles::NodePosition).value<QPoint>();
}

qreal Curve::GetDistanceTo(int row) const
{
  return data(index(row, 0), DataRoles::DistanceAlongCurve).value<qreal>();
}

qreal Curve::CalculateDistanceTo(int x, int y)
{
    qreal distance = 0.0;
    int count = rowCount();
    if (count > 0)
    {
      distance = index(count - 1, 0).data(DataRoles::DistanceAlongCurve).toDouble() +
          QLineF(QPoint(x, y), index(count - 1, 0).data(DataRoles::NodePosition).toPointF()).length();
    }
    return distance;
}
