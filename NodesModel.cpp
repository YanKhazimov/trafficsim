#include "NodesModel.h"
#include "DataRoles.h"
#include <QDebug>

Node::Node(QObject *parent) : QObject(parent)
{
}

Node::Node(NodeType _type, RegularCrossroad* _crossroad, int _side, int _lane, QObject *parent)
  : QObject(parent), type(_type), crossroad(_crossroad), side(_side), lane(_lane)
{
}

bool Node::operator ==(const Node &other) const
{
  return type == other.type &&
      crossroad->GetId() == other.crossroad->GetId() &&
      side == other.side &&
      lane == other.lane;
}

QPoint Node::GetPosition() const
{
  if (type == NodeType::CrossroadIn)
    return QPoint(crossroad->AtStopLine(side, lane));
  else if (type == NodeType::CrossroadOut)
    return QPoint(crossroad->AtExit(side, lane));

  qWarning() << "requested position of unsupported node type" << (int)type;
  return QPoint();
}

NodesModel::NodesModel(QObject *parent) : QAbstractListModel(parent)
{
}

int NodesModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return nodes.count();
}

QVariant NodesModel::data(const QModelIndex &index, int role) const
{
  int row = index.row();

  if (row < 0 || row >= rowCount()) {
    qWarning() << "requested nodes data for row" << row;
    return QVariant();
  }

  std::shared_ptr<Node> node = nodes[row];

  if (role == DataRoles::NodeData)
    return QVariant::fromValue(node.get());

  if (role == DataRoles::IsStartNode)
    return node->type == NodeType::CrossroadIn;

  if (role == DataRoles::NodePosition)
    return node->GetPosition();

  return QVariant();
}

QHash<int, QByteArray> NodesModel::roleNames() const
{
  return {
    { DataRoles::NodeData, "RoleNodeData" },
    { DataRoles::NodePosition, "RoleNodePosition" }
  };
}

void NodesModel::AddNode(NodeType type, RegularCrossroad* crossroad, int side, int lane)
{
  beginInsertRows(QModelIndex(), nodes.count(), nodes.count());
  nodes.insert(nodes.count(), std::make_shared<Node>(type, crossroad, side, lane));
  endInsertRows();
}

bool NodesModel::RemoveNode(int index)
{
  if (index < 0 || index >= nodes.size())
    return false;

  beginRemoveRows(QModelIndex(), index, index);
  nodes.removeAt(index);
  endRemoveRows();

  return true;
}

Node* NodesModel::GetNode(int index)
{
  if (index < 0 || index >= nodes.size())
    return nullptr;

  return nodes[index].get();
}
