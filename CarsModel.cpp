#include "CarsModel.h"
#include "DataRoles.h"
#include <QDebug>

CarsModel::CarsModel(QObject *parent) : QAbstractListModel(parent)
{
}

int CarsModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return cars.count();
}

QVariant CarsModel::data(const QModelIndex &index, int role) const
{
  int row = index.row();

  if (row < 0 || row >= rowCount()) {
    qWarning() << "requested cars data for row" << row;
    return QVariant();
  }

  if (role == DataRoles::CarData)
    return QVariant::fromValue(cars[row].get());

  return QVariant();
}

QHash<int, QByteArray> CarsModel::roleNames() const
{
  return {
    { DataRoles::CarData, "RoleCarData" }
  };
}

void CarsModel::AddCar(int width, int length, QUrl source, int sourceDirection)
{
  int idx = rowCount();
  beginInsertRows(QModelIndex(), idx, idx);
  cars.insert(idx, std::make_shared<Car>(width, length, source, sourceDirection));
  cars[idx]->SetPosition((idx + 1) * 100, 0);
  endInsertRows();
}

Car* CarsModel::GetSelectedCar() const
{
  return selectionIndex >= 0 && selectionIndex < rowCount() ?
        cars[selectionIndex].get() : nullptr;
}

Car* CarsModel::GetCar(int index) const
{
  return index >= 0 && index < rowCount() ?
        cars[index].get() : nullptr;
}

void CarsModel::Select(int idx)
{
  if (selectionIndex != idx)
  {
    selectionIndex = idx;
    emit selectionIndexChanged();
  }
}
