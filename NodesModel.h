#pragma once
#include <QList>
#include <QAbstractListModel>
#include <QPoint>
#include <memory>
#include "Node.h"

class NodesModel : public QAbstractListModel
{
  Q_OBJECT

  QList<std::shared_ptr<Node>> nodes;

public:
  explicit NodesModel(QObject *parent = nullptr);

  // QAbstractListModel
  Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
  Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  QHash<int, QByteArray> roleNames() const;

  void AddNode(Node::NodeType type, RegularCrossroad *crossroad, int side, int lane, QPoint pos = QPoint(), qreal angle = 0.0);
  bool RemoveNode(int index);

  Node* GetNode(int index);
};
