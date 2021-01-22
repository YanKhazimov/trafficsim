#include "RoadLanesModel.h"
#include "DataRoles.h"
#include <QDebug>

RoadLanesModel::RoadLanesModel(QObject *parent) : QAbstractListModel(parent)
{
}

int RoadLanesModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return roadLanes.count();
}

QVariant RoadLanesModel::data(const QModelIndex &index, int role) const
{
  int row = index.row();

  if (row < 0 || row >= rowCount()) {
    qWarning() << "requested road lanes data for row" << row;
    return QVariant();
  }

  std::shared_ptr<RoadLane> roadLane = roadLanes[row];

  if (role == DataRoles::RoadLaneData)
    return QVariant::fromValue(roadLane.get());

  return QVariant();
}

QHash<int, QByteArray> RoadLanesModel::roleNames() const
{
  return {
    { DataRoles::RoadLaneData, "RoleRoadLaneData" }
  };
}

void RoadLanesModel::AddRoadLane(RoadLane* roadLane)
{
  beginInsertRows(QModelIndex(), roadLanes.count(), roadLanes.count());
  const QList<QPoint>& trajectory = roadLane->GetTrajectory();
  roadLanes.insert(roadLanes.count(), std::make_shared<RoadLane>(trajectory));
  endInsertRows();
}
