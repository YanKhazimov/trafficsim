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

void RoadLanesModel::Serialize(QTextStream &stream) const
{
  stream << rowCount() << Qt::endl;
  for (int i = 0; i < rowCount(); ++i)
    data(index(i, 0), DataRoles::RoadLaneData).value<RoadLane*>()->Serialize(stream);
}

bool RoadLanesModel::Deserialize(QTextStream &stream, RegularCrossroad* crossroad, MapGraph *graph)
{
  // parse file and ensure validity
  bool result = true;

  int lanesCount = stream.readLine().toInt(&result);
  if (!result)
  {
    qWarning() << "Can't deserialize road lanes number";
    return false;
  }

  QList<QList<std::tuple<int, QString, int, int, qreal, qreal, int, int>>> lanes;

  for (int i = 0; i < lanesCount; ++i)
  {
    int pointsCount = stream.readLine().toInt(&result);
    if (!result)
    {
      qWarning() << "Can't deserialize road lane points count";
      return false;
    }

    lanes.append(QList<std::tuple<int, QString, int, int, qreal, qreal, int, int>>());

    for (int j = 0; j < pointsCount; ++j)
    {
      QStringList pointParameters = stream.readLine().split(' ', Qt::KeepEmptyParts);
      if (pointParameters.count() != 8)
      {
        qWarning() << "Can't deserialize road lane point with" << pointParameters.count() << "parameters";
        return false;
      }

      int type = pointParameters[0].toInt(&result); // add validation
      QString crossroad = pointParameters[1];
      int side = pointParameters[2].toInt(&result);
      int lane = pointParameters[3].toInt(&result);
      qreal distanceTo = pointParameters[4].toDouble(&result);
      qreal angle = pointParameters[5].toDouble(&result);
      int x = pointParameters[6].toInt(&result);
      int y = pointParameters[7].toInt(&result);

      lanes[i].append({ type, crossroad, side, lane, distanceTo, angle, x, y });
    }
  }

  // remove current roadlanes
  beginResetModel();
  roadLanes.clear();
  endResetModel();

  // add new roadlanes
  for (int i = 0; i < lanesCount; ++i)
  {
    QList<std::shared_ptr<CurvePoint>> trajectory;
    for (int j = 0; j < lanes[i].count(); ++j)
    {
      Node::NodeType type = (Node::NodeType)std::get<0>(lanes[i][j]);
      if (type == Node::CrossroadIn || type == Node::CrossroadOut)
      {
        if (crossroad->GetId() != std::get<1>(lanes[i][j]))
          return false;

        trajectory.append(std::make_shared<RoadPoint>(type, std::get<5>(lanes[i][j]), crossroad,
                                                      std::get<2>(lanes[i][j]), std::get<3>(lanes[i][j]), std::get<4>(lanes[i][j])));

      }
      else if (type == Node::RoadJoint)
      {
        trajectory.append(std::make_shared<RoadPoint>(Node::RoadJoint, std::get<6>(lanes[i][j]), std::get<7>(lanes[i][j]),
                                                      std::get<4>(lanes[i][j]), std::get<5>(lanes[i][j])));
      }
      else
      {
        qWarning() << "Can't add road lane with type" << type;
        return false;
      }
    }
    std::shared_ptr<RoadLane> newLane = std::make_shared<RoadLane>(trajectory);
    AddRoadLane(newLane.get());

    // register in graph
    graph->RegisterRoadlane(index(rowCount() - 1, 0).data(DataRoles::RoadLaneData).value<RoadLane*>());
  }

  return result;
}

void RoadLanesModel::AddRoadLane(RoadLane* roadLane)
{
  beginInsertRows(QModelIndex(), roadLanes.count(), roadLanes.count());
  const auto& trajectory = roadLane->GetPoints();
  roadLanes.insert(roadLanes.count(), std::make_shared<RoadLane>(trajectory));
  endInsertRows();
}
