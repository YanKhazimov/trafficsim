#pragma once

#include <QAbstractListModel>
#include "Passage.h"
#include <memory>

class CrossroadPassagesModel : public QAbstractListModel
{
  Q_OBJECT

  QList<std::shared_ptr<Passage>> passages;

public:
  explicit CrossroadPassagesModel(QObject *parent = nullptr);

  // QAbstractListModel
  Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
  Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  Q_INVOKABLE virtual bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);
  QHash<int, QByteArray> roleNames() const;

  void AddPassage(const QList<std::shared_ptr<CurvePoint>>& points, int inSideIndex, int inLaneIndex, int outSideIndex, int outLaneIndex);
  bool RemovePassage(int index);

public slots:
  void RecalculatePassagesOnSidesInserted(int first, int last);
  void RecalculatePassagesOnSidesRemoved(int first, int last);
};
