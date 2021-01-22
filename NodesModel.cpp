#include "NodesModel.h"
#include "DataRoles.h"
#include <QDebug>

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
    return node->type == Node::NodeType::CrossroadIn;

  if (role == DataRoles::NodePosition)
    return node->GetPosition();

  if (role == DataRoles::NodeType)
    return QVariant::fromValue(node->type);

  return QVariant();
}

QHash<int, QByteArray> NodesModel::roleNames() const
{
  return {
    { DataRoles::NodeData, "RoleNodeData" },
    { DataRoles::NodePosition, "RoleNodePosition" },
    { DataRoles::NodeType, "RoleNodeType" }
  };
}

void NodesModel::AddNode(Node::NodeType type, RegularCrossroad* crossroad, int side, int lane)
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
