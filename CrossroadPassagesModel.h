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
  QHash<int, QByteArray> roleNames() const;

  void AddPassage(Passage* newPassage);
  bool RemovePassage(int index);

public slots:
  void onSidesInserted(const QModelIndex &parent, int first, int last);
  void onSidesRemoved(const QModelIndex &parent, int first, int last);
};
