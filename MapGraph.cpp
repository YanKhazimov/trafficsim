#include "MapGraph.h"
#include "DataRoles.h"
#include <QDebug>

NodesModel *MapGraph::getNodes()
{
  return &nodes;
}

MapGraph::MapGraph(QObject *parent) : QObject(parent)
{
}

void MapGraph::RegisterCrossroad(RegularCrossroad* crossroad)
{
  crossroads.append(crossroad);

  QObject::connect(crossroad, &RegularCrossroad::sideParametersChanged, this, [this, crossroad] (int side) {
    RecalculateOnSidesRemoved(crossroad, side, side);
    RecalculateOnSidesInserted(crossroad, side, side);
  });

  QObject::connect(crossroad, &RegularCrossroad::sidesInserted, this, &MapGraph::RecalculateOnSidesInserted);
  QObject::connect(crossroad, &RegularCrossroad::sidesRemoved, this, &MapGraph::RecalculateOnSidesRemoved);
  QObject::connect(crossroad, &RegularCrossroad::passagesInserted, this, &MapGraph::RecalculateOnPassagesInserted);
  QObject::connect(crossroad, &RegularCrossroad::passagesRemoved, this, &MapGraph::RecalculateOnPassagesRemoved);

  QObject::connect(crossroad, &RegularCrossroad::positionChanged, this, &MapGraph::RecalculateOnCrossroadPositionChanged);
}

void MapGraph::RegisterRoadlane(RoadLane* roadlane)
{
  qWarning() << QString("from nodes=%1, edges=%2").arg(nodes.rowCount(), edges.size());
  roadlanes.append(roadlane);

  QList<Node*> roadNodesInGraph;

  // 1. nodes
  for (int i = 0; i < roadlane->rowCount(); ++i)
  {
    RoadPoint* roadPoint = roadlane->index(i, 0).data(DataRoles::RoadPointData).value<RoadPoint*>();
    Node::NodeType roadPointType = roadPoint->type;

    if (roadPointType == Node::None) {
      qWarning() << "road point with type None in a road";
      continue;
    }

    int matchesNodeIndex = -1;
    for (int j = 0; j < nodes.rowCount(); ++j)
    {
      Node* node = nodes.index(j, 0).data(DataRoles::NodeData).value<Node*>();
      if (node->type == roadPointType && node->GetPosition() == roadPoint->GetPosition())
      {
        matchesNodeIndex = j;
        break;
      }
    }

    if (matchesNodeIndex == -1)
    {
      nodes.AddNode(roadPointType, roadPoint->crossroad, roadPoint->crossroadSide, roadPoint->crossroadLane,
                    roadPoint->GetPosition(), roadPoint->GetAngle());
      roadNodesInGraph.append(nodes.index(nodes.rowCount() - 1, 0).data(DataRoles::NodeData).value<Node*>());
    }
    else
    {
      roadNodesInGraph.append(nodes.index(matchesNodeIndex, 0).data(DataRoles::NodeData).value<Node*>());
    }
  }

  emit nodesChanged();

  // 2. edges
  for (int i = 1; i < roadNodesInGraph.size(); ++i)
  {
    auto from = std::make_shared<Node>(roadNodesInGraph[i - 1]->type,
        roadNodesInGraph[i - 1]->crossroad,
        roadNodesInGraph[i - 1]->side,
        roadNodesInGraph[i - 1]->lane);
    auto to = std::make_shared<Node>(roadNodesInGraph[i]->type,
        roadNodesInGraph[i]->crossroad,
        roadNodesInGraph[i]->side,
        roadNodesInGraph[i]->lane);

    edges << qMakePair<std::shared_ptr<Node>, std::shared_ptr<Node>>(from, to);
  }

  emit edgesChanged();

  qWarning() << QString("to nodes=%1, edges=%2").arg(nodes.rowCount(), edges.size());
}

QList<Node*> MapGraph::AccessibleNodes(const Node* from) const
{
  QList<Node*> result;
  for (const auto& edge : edges)
    if (*edge.first.get() == *from)
      result << edge.second.get();
  return result;
}

void MapGraph::RecalculateOnSidesInserted(RegularCrossroad *crossroad, int first, int last)
{
  if (first != last)
    qWarning() << "inserted" << last - first + 1 << "sides";

  // 1. adjust old

  // nodes
  for (int i = 0; i < nodes.rowCount(); ++i)
  {
    Node* node = nodes.GetNode(i);
    if (!node->crossroad || (node->crossroad->GetId() != crossroad->GetId()))
      continue;

    if (node->side >= first)
      node->side += (last - first + 1);
  }

  // edges
  for (int i = 0; i < edges.count(); ++i)
  {
    auto& startNode = edges[i].first;
    if (!startNode->crossroad || (startNode->crossroad->GetId() == crossroad->GetId()))
    {
      if (startNode->side >= first)
        startNode->side += (last - first + 1);
    }

    Node* endNode = edges[i].second.get();
    if (!endNode->crossroad || (endNode->crossroad->GetId() == crossroad->GetId()))
    {
      if (endNode->side >= first)
        endNode->side += (last - first + 1);
    }
  }

  // 2. add new
  for (int i = first; i <= last; ++i)
  {
    CrossroadSide* side = crossroad->GetSide(i);
    for (int j = 0; j < side->GetInLanesCount(); ++j)
      nodes.AddNode(Node::NodeType::CrossroadIn, crossroad, i, j);
    for (int j = 0; j < side->GetOutLanesCount(); ++j)
      nodes.AddNode(Node::NodeType::CrossroadOut, crossroad, i, j);
  }

  emit nodesChanged();
  emit edgesChanged();
}

void MapGraph::RecalculateOnSidesRemoved(RegularCrossroad *crossroad, int first, int last)
{
  if (first != last)
    qWarning() << "removed" << last - first + 1 << "sides";

  // nodes
  for (int i = nodes.rowCount() - 1; i >= 0; --i)
  {
    Node* node = nodes.GetNode(i);
    if (!node->crossroad || (node->crossroad->GetId() != crossroad->GetId()))
      continue;
    if (node->side >= first && node->side <= last)
    {
      nodes.RemoveNode(i);
      continue;
    }

    if (node->side > last)
      node->side -= last - first + 1;
  }

  // edges
  for (int i = edges.count() - 1; i >= 0; --i)
  {
    Node* startNode = edges[i].first.get();
    if (!startNode->crossroad || (startNode->crossroad->GetId() != crossroad->GetId()))
      continue;
    if (startNode->side >= first && startNode->side <= last)
    {
      edges.removeAt(i);
      continue;
    }

    if (startNode->side > last)
      startNode->side -= last - first + 1;
  }
  for (int i = edges.count() - 1; i >= 0; --i)
  {
    Node* endNode = edges[i].second.get();
    if (!endNode->crossroad || (endNode->crossroad->GetId() != crossroad->GetId()))
      continue;
    if (endNode->side >= first && endNode->side <= last)
    {
      edges.removeAt(i);
      continue;
    }

    if (endNode->side > last)
      endNode->side -= last - first + 1;
  }

  emit nodesChanged();
  emit edgesChanged();
}

void MapGraph::RecalculateOnPassagesInserted(RegularCrossroad *crossroad, int first, int last)
{
  // add new edges
  for (int i = first; i <= last; ++i)
  {
    Passage* passage = crossroad->GetPassage(i);
    edges << qMakePair<std::shared_ptr<Node>, std::shared_ptr<Node>>(std::make_shared<Node>(Node::NodeType::CrossroadIn,
                                                                                            crossroad,
                                                                                            passage->inSideIndex,
                                                                                            passage->inLaneIndex),
                                                                     std::make_shared<Node>(Node::NodeType::CrossroadOut,
                                                                                            crossroad,
                                                                                            passage->outSideIndex,
                                                                                            passage->outLaneIndex));
  }

  emit edgesChanged();
}

void MapGraph::RecalculateOnPassagesRemoved(RegularCrossroad *crossroad, int first, int last)
{
  edges.clear();

  for (int i = 0; i < crossroad->CountPassages(); ++i)
  {
    Passage* passage = crossroad->GetPassage(i);
    edges << qMakePair<std::shared_ptr<Node>, std::shared_ptr<Node>>(std::make_shared<Node>(Node::NodeType::CrossroadIn,
                                                                                            crossroad,
                                                                                            passage->inSideIndex,
                                                                                            passage->inLaneIndex),
                                                                     std::make_shared<Node>(Node::NodeType::CrossroadOut,
                                                                                            crossroad,
                                                                                            passage->outSideIndex,
                                                                                            passage->outLaneIndex));
  }

  emit edgesChanged();
}

void MapGraph::RecalculateOnCrossroadPositionChanged()
{
  RegularCrossroad* changedCrossroad = qobject_cast<RegularCrossroad*>(sender());
  if (!changedCrossroad)
  {
    qWarning() << "not crossroad changed";
    return;
  }

  for (int i = 0; i < nodes.rowCount(); ++i)
    if (nodes.GetNode(i)->crossroad->GetId() == changedCrossroad->GetId())
      emit nodes.dataChanged(nodes.index(i, 0), nodes.index(i, 0), { DataRoles::NodePosition });
}
