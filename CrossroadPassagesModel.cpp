#include "CrossroadPassagesModel.h"
#include "DataRoles.h"
#include <QDebug>

CrossroadPassagesModel::CrossroadPassagesModel(QObject *parent) : QAbstractListModel(parent)
{

}

int CrossroadPassagesModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return passages.count();
}

QVariant CrossroadPassagesModel::data(const QModelIndex &index, int role) const
{
  int row = index.row();

  if (row < 0 || row >= rowCount()) {
    qWarning() << "requested passages data for row" << row;
    return QVariant();
  }

  if (role == DataRoles::CrossroadPassageData)
    return QVariant::fromValue(passages[row].get());

  return QVariant();
}

QHash<int, QByteArray> CrossroadPassagesModel::roleNames() const
{
  return {
    { DataRoles::CrossroadPassageData, "RolePassageData" }
  };
}

void CrossroadPassagesModel::AddPassage(Passage* newPassage)
{
  beginInsertRows(QModelIndex(), passages.count(), passages.count());
  passages.insert(passages.count(), std::make_shared<Passage>(newPassage->inSideIndex, newPassage->inLaneIndex,
                                                              newPassage->outSideIndex, newPassage->outLaneIndex));
  endInsertRows();
}

bool CrossroadPassagesModel::RemovePassage(int index)
{
  if (index < 0 || index >= passages.size()) {
    qWarning() << "removing passage" << index;
    return false;
  }

  beginRemoveRows(QModelIndex(), index, index);
  passages.removeAt(index);
  endRemoveRows();

  return true;
}
