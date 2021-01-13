#pragma once
#include <QList>
#include <QAbstractListModel>
#include <QPoint>
#include <memory>
#include "RegularCrossroad.h"

enum class NodeType {
  None,
  CrossroadIn,
  CrossroadOut
};

class Node : public QObject
{
  Q_OBJECT

public:
  explicit Node(QObject *parent = nullptr);
  explicit Node(NodeType type, RegularCrossroad *crossroad, int side, int lane, QObject *parent = nullptr);

  NodeType type = NodeType::None;
  RegularCrossroad* crossroad = nullptr;
  int side = -1;
  int lane = -1;

  bool operator ==(const Node& other) const;
  QPoint GetPosition() const;

signals:
  void parametersChanged();
};

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

  void AddNode(NodeType type, RegularCrossroad *crossroad, int side, int lane);
  bool RemoveNode(int index);

  Node* GetNode(int index);
};
