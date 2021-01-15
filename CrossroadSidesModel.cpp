#include "CrossroadSidesModel.h"
#include "DataRoles.h"
#include <QDebug>

CrossroadSidesModel::CrossroadSidesModel(QObject *parent) : QAbstractListModel(parent)
{

}

int CrossroadSidesModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return sides.count();
}

QVariant CrossroadSidesModel::data(const QModelIndex &index, int role) const
{
  int row = index.row();

  if (row < 0 || row >= rowCount()) {
    qWarning() << "requested sides data for row" << row;
    return QVariant();
  }

  if (role == DataRoles::CrossroadSideData)
    return QVariant::fromValue(sides[row].get());

  return QVariant();
}

QHash<int, QByteArray> CrossroadSidesModel::roleNames() const
{
  return {
    { DataRoles::CrossroadSideData, "RoleSideData" }
  };
}

int CrossroadSidesModel::InsertSide(int laneWidth, int startX, int startY, int normal, int inLanesCount, int outLanesCount, int inOffset, int outOffset, int midOffset)
{
  int row = 0;
  while (row < rowCount() && sides[row]->GetNormal() < normal)
    ++row;

  beginInsertRows(QModelIndex(), row, row);
  sides.insert(row, std::make_shared<CrossroadSide>(laneWidth, startX, startY, normal, inLanesCount, outLanesCount, inOffset, outOffset, midOffset));
  endInsertRows();

  return row;
}

bool CrossroadSidesModel::RemoveSide(int index)
{
  if (index < 0 || index >= sides.size())
    return false;

  beginRemoveRows(QModelIndex(), index, index);
  sides.removeAt(index);
  endRemoveRows();

  return true;
}

CrossroadSide* CrossroadSidesModel::GetSide(int index) const
{
  if (index < 0 || index >= sides.size())
    return nullptr;

  return sides[index].get();
}
