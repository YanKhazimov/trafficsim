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

  if (role == DataRoles::IsPassageHighlighted)
    return QVariant::fromValue(passages[row]->IsHighlighted());

  return QVariant();
}

bool CrossroadPassagesModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
  int row = index.row();

  if (row < 0 || row >= rowCount()) {
    qWarning() << "Cannot set data for row" << row;
    return false;
  }

  DataRoles dataRole = static_cast<DataRoles>(role);

  if (dataRole == DataRoles::IsPassageHighlighted)
  {
    passages[row]->SetHighlighted(value.toBool());
    emit dataChanged(this->index(row, 0), this->index(row, 0), { role });
    return true;
  }

  qDebug() << "CrossroadPassagesModel::setData" << "unsupported role" << dataRole;
  return false;
}

QHash<int, QByteArray> CrossroadPassagesModel::roleNames() const
{
  return {
    { DataRoles::CrossroadPassageData, "RolePassageData" },
    { DataRoles::IsPassageHighlighted, "RoleIsHighlighted" }
  };
}

void CrossroadPassagesModel::AddPassage(const QList<std::shared_ptr<CurvePoint>>& points, int inSideIndex, int inLaneIndex, int outSideIndex, int outLaneIndex)
{
  beginInsertRows(QModelIndex(), passages.count(), passages.count());
  passages.insert(passages.count(), std::make_shared<Passage>(points, inSideIndex, inLaneIndex, outSideIndex, outLaneIndex));
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

void CrossroadPassagesModel::RecalculatePassagesOnSidesInserted(int first, int last)
{
  if (first != last)
    qWarning() << "inserted" << last - first + 1 << "sides";

  for (int i = 0; i < passages.count(); ++i)
  {
    auto& passage = passages[i];
    if (passage->inSideIndex >= first)
    {
      passage->SetInLane(passage->inSideIndex + (last - first + 1), passage->inLaneIndex);
      //emit dataChanged(index(i, 0), index(i, 0), { DataRoles::PassageParameters });
    }

    if (passage->outSideIndex >= first)
    {
      passage->SetOutLane(passage->outSideIndex + (last - first + 1), passage->outLaneIndex);
      //emit dataChanged(index(i, 0), index(i, 0), { DataRoles::PassageParameters });
    }
  }
}

void CrossroadPassagesModel::RecalculatePassagesOnSidesRemoved(int first, int last)
{
  if (first != last)
    qWarning() << "removed" << last - first + 1 << "sides";

  for (int i = passages.count() - 1; i >= 0; --i)
  {
    if (passages[i]->inSideIndex >= first && passages[i]->inSideIndex <= last)
    {
      beginRemoveRows(QModelIndex(), i, i);
      passages.removeAt(i);
      endRemoveRows();
      continue;
    }

    if (passages[i]->outSideIndex >= first && passages[i]->outSideIndex <= last)
    {
      beginRemoveRows(QModelIndex(), i, i);
      passages.removeAt(i);
      endRemoveRows();
      continue;
    }

    if (passages[i]->inSideIndex > last)
    {
      passages[i]->SetInLane(passages[i]->inSideIndex - (last - first + 1), passages[i]->inLaneIndex);
      //emit dataChanged(index(i, 0), index(i, 0), { DataRoles::PassageParameters });
    }

    if (passages[i]->outSideIndex > last)
    {
      passages[i]->SetOutLane(passages[i]->outSideIndex - (last - first + 1), passages[i]->outLaneIndex);
      //emit dataChanged(index(i, 0), index(i, 0), { DataRoles::PassageParameters });
    }
  }
}
