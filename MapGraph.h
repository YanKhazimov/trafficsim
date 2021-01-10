#pragma once
#include <QList>
#include <QPair>
#include <QObject>
#include "RegularCrossroad.h"

enum class NodeType {
  None,
  CrossroadIn,
  CrossroadOut
};

struct Node {
  NodeType type = NodeType::None;
  int crossroadId = -1;
  int side = -1;
  int lane = -1;

  bool operator ==(const Node& other) const;
};

class MapGraph : public QObject
{
  Q_OBJECT

  QList<Node> nodes;
  QList<QPair<Node, Node>> edges;

public:
  MapGraph();
  void AddEgde(const QPair<Node, Node>& edge);
  QList<Node> Next(const Node& from) const;

public slots:
  void RecalculateGraphNodesOnSidesInserted(RegularCrossroad* crossroad, int first, int last);
  void RecalculateGraphNodesOnSidesRemoved(RegularCrossroad* crossroad, int first, int last);
};
