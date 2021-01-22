#pragma once
#include <QList>
#include <QPair>
#include <QObject>
#include "RegularCrossroad.h"
#include "RoadLane.h"
#include "NodesModel.h"
#include <memory>

class MapGraph : public QObject
{
  Q_OBJECT

  Q_PROPERTY(NodesModel* Nodes READ getNodes NOTIFY nodesChanged)

  NodesModel nodes;
  QList<QPair<std::shared_ptr<Node>, std::shared_ptr<Node>>> edges;

  QList<RegularCrossroad*> crossroads;
  QList<RoadLane*> roadlanes;

  NodesModel* getNodes();

public:
  explicit MapGraph(QObject* parent = nullptr);
  void RegisterCrossroad(RegularCrossroad* crossroad);
  void RegisterRoadlane(RoadLane* roadlane);
  QList<Node*> AccessibleNodes(const Node* from) const;

public slots:
  void RecalculateOnSidesInserted(RegularCrossroad* crossroad, int first, int last);
  void RecalculateOnSidesRemoved(RegularCrossroad* crossroad, int first, int last);
  void RecalculateOnPassagesInserted(RegularCrossroad* crossroad, int first, int last);
  void RecalculateOnPassagesRemoved(RegularCrossroad* crossroad, int first, int last);
  void RecalculateOnCrossroadPositionChanged();

signals:
  void nodesChanged();
  void edgesChanged();
};
Q_DECLARE_METATYPE(MapGraph*)
