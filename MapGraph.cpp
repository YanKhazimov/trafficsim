#include "MapGraph.h"
#include <QDebug>

MapGraph::MapGraph()
{
}

void MapGraph::AddEgde(const QPair<Node, Node> &edge)
{
  edges << edge;
}

QList<Node> MapGraph::Next(const Node &from) const
{
  QList<Node> result;
  for (const auto& edge : edges)
    if (edge.first == from)
      result << edge.second;
  return result;
}

bool Node::operator ==(const Node &other) const
{
  return type == other.type &&
      crossroadId == other.crossroadId &&
      side == other.side &&
      lane == other.lane;
}

void MapGraph::RecalculateGraphNodesOnSidesInserted(RegularCrossroad *crossroad, int first, int last)
{
  if (first != last)
    qWarning() << "inserted" << last - first + 1 << "sides";

  // 1. adjust old

  // nodes
  for (int i = 0; i < nodes.count(); ++i)
  {
    auto& node = nodes[i];
//    if (node.crossroadId != crossroad->GetId())
//      continue;

    if (node.side >= first)
      node.side += (last - first + 1);
  }

  // edges
  for (int i = 0; i < edges.count(); ++i)
  {
    auto& startNode = edges[i].first;
//    if (startNode.crossroadId == crossroad->GetId())
    {
      if (startNode.side >= first)
        startNode.side += (last - first + 1);
    }

    auto& endNode = edges[i].second;
//    if (endNode.crossroadId == crossroad->GetId())
    {
      if (endNode.side >= first)
        endNode.side += (last - first + 1);
    }
  }

  // 2. add new
  for (int i = first; i <= last; ++i)
  {
    CrossroadSide* side = crossroad->GetSide(i);
    for (int j = 0; j < side->GetInLanesCount(); ++j)
      nodes << Node { NodeType::CrossroadIn, -1, i, j };
    for (int j = 0; j < side->GetOutLanesCount(); ++j)
      nodes << Node { NodeType::CrossroadOut, -1, i, j };
  }
}

void MapGraph::RecalculateGraphNodesOnSidesRemoved(RegularCrossroad *crossroad, int first, int last)
{
  if (first != last)
    qWarning() << "removed" << last - first + 1 << "sides";

  // nodes
  for (int i = nodes.count() - 1; i >= 0; --i)
  {
    auto& node = nodes[i];
//    if (node.crossroadId != crossroad->GetId())
//      continue;
    if (node.side >= first && node.side <= last)
    {
      nodes.removeAt(i);
      continue;
    }

    if (node.side > last)
      node.side -= last - first + 1;
  }

  // edges
  for (int i = edges.count() - 1; i >= 0; --i)
  {
    auto& startNode = edges[i].first;
//    if (startNode.crossroadId != crossroad->GetId())
//      continue;
    if (startNode.side >= first && startNode.side <= last)
    {
      edges.removeAt(i);
      continue;
    }

    if (startNode.side > last)
      startNode.side -= last - first + 1;
  }
  for (int i = edges.count() - 1; i >= 0; --i)
  {
    auto& endNode = edges[i].second;
//    if (endNode.crossroadId != crossroad->GetId())
//      continue;
    if (endNode.side >= first && endNode.side <= last)
    {
      edges.removeAt(i);
      continue;
    }

    if (endNode.side > last)
      endNode.side -= last - first + 1;
  }
}
