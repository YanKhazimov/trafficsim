#pragma once
#include <QList>
#include <QPair>
#include <QObject>
#include "RegularCrossroad.h"
#include "NodesModel.h"
#include <memory>

class MapGraph : public QObject
{
  Q_OBJECT

  Q_PROPERTY(NodesModel* Nodes READ getNodes NOTIFY nodesChanged)

  NodesModel nodes;
  QList<QPair<std::shared_ptr<Node>, std::shared_ptr<Node>>> edges;

  QList<RegularCrossroad*> crossroads;

  NodesModel* getNodes();

public:
  explicit MapGraph(QObject* parent = nullptr);
  void RegisterCrossroad(RegularCrossroad* crossroad);
  QList<Node*> AccessibleNodes(const Node* from) const;

public slots:
  void RecalculateOnSidesInserted(RegularCrossroad* crossroad, int first, int last);
  void RecalculateOnSidesRemoved(RegularCrossroad* crossroad, int first, int last);
  void RecalculateOnPassagesInserted(RegularCrossroad* crossroad, int first, int last);
  void RecalculateOnPassagesRemoved(RegularCrossroad* crossroad, int first, int last);

signals:
  void nodesChanged();
  void edgesChanged();
};
Q_DECLARE_METATYPE(MapGraph*)
