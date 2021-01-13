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
  emit nodesChanged();
  emit edgesChanged();
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
    if (node->crossroad->GetId() != crossroad->GetId())
      continue;

    if (node->side >= first)
      node->side += (last - first + 1);
  }

  // edges
  for (int i = 0; i < edges.count(); ++i)
  {
    auto& startNode = edges[i].first;
    if (startNode->crossroad->GetId() == crossroad->GetId())
    {
      if (startNode->side >= first)
        startNode->side += (last - first + 1);
    }

    Node* endNode = edges[i].second.get();
    if (endNode->crossroad->GetId() == crossroad->GetId())
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
      nodes.AddNode(NodeType::CrossroadIn, crossroad, i, j);
    for (int j = 0; j < side->GetOutLanesCount(); ++j)
      nodes.AddNode(NodeType::CrossroadOut, crossroad, i, j);
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
    if (node->crossroad->GetId() != crossroad->GetId())
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
    if (startNode->crossroad->GetId() != crossroad->GetId())
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
    if (endNode->crossroad->GetId() != crossroad->GetId())
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
    edges << qMakePair<std::shared_ptr<Node>, std::shared_ptr<Node>>(std::make_shared<Node>(NodeType::CrossroadIn,
                                                                                            crossroad,
                                                                                            passage->inSideIndex,
                                                                                            passage->inLaneIndex),
                                                                     std::make_shared<Node>(NodeType::CrossroadOut,
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
    edges << qMakePair<std::shared_ptr<Node>, std::shared_ptr<Node>>(std::make_shared<Node>(NodeType::CrossroadIn,
                                                                                            crossroad,
                                                                                            passage->inSideIndex,
                                                                                            passage->inLaneIndex),
                                                                     std::make_shared<Node>(NodeType::CrossroadOut,
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
