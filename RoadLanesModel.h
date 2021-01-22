#pragma once
#include <QList>
#include <QAbstractListModel>
#include <QPoint>
#include <memory>
#include "RoadLane.h"

class RoadLanesModel : public QAbstractListModel
{
  Q_OBJECT

  QList<std::shared_ptr<RoadLane>> roadLanes;

public:
  explicit RoadLanesModel(QObject *parent = nullptr);

  // QAbstractListModel
  Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
  Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  QHash<int, QByteArray> roleNames() const;

  void AddRoadLane(RoadLane* roadLane);
};
