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

void CarsModel::AddCar()
{
  int idx = rowCount();
  beginInsertRows(QModelIndex(), idx, idx);
  cars.insert(idx, std::make_shared<Car>());
  cars[idx]->SetPosition((idx + 1) * 100, 0);
  cars[idx]->SetRoute({{(idx + 1) * 100, 100}, {(idx + 1) * 100, 200}});
  endInsertRows();
}

Car *CarsModel::GetSelectedCar() const
{
  return selectionIndex >= 0 && selectionIndex < rowCount() ?
        cars[selectionIndex].get() : nullptr;
}

void CarsModel::Select(int idx)
{
  if (selectionIndex != idx)
  {
    selectionIndex = idx;
    emit selectionIndexChanged();
  }
}
