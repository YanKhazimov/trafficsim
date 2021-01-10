#pragma once
#include "Car.h"
#include <QAbstractListModel>

class CarsModel : public QAbstractListModel
{
  Q_OBJECT

  Q_PROPERTY(int SelectionIndex MEMBER selectionIndex NOTIFY selectionIndexChanged)

  QList<std::shared_ptr<Car>> cars;
  int selectionIndex = -1;

public:
  explicit CarsModel(QObject *parent = nullptr);

  // QAbstractListModel
  Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
  Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  QHash<int, QByteArray> roleNames() const;

  void AddCar();
  Car* GetSelectedCar() const;
  Car* GetCar(int index) const;
  Q_INVOKABLE void Select(int idx);

signals:
  void selectionIndexChanged();
};

