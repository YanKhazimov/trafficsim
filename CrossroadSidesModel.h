#pragma once

#include <QAbstractListModel>
#include "CrossroadSide.h"
#include <memory>

class CrossroadSidesModel : public QAbstractListModel
{
  Q_OBJECT

  QList<std::shared_ptr<CrossroadSide>> sides;

public:
  explicit CrossroadSidesModel(QObject *parent = nullptr);

  // QAbstractListModel
  Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
  Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  QHash<int, QByteArray> roleNames() const;

  void AddSide(int laneWidth, int startX, int startY, int normal, int inLanesCount, int outLanesCount, int inOffset = 0, int outOffset = 0, int midOffset = 0);
  bool RemoveSide(int index);

  CrossroadSide* GetSide(int index) const;
};
