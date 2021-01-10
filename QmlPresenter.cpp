#include "QmlPresenter.h"
#include "DataRoles.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

RegularCrossroad *QmlPresenter::getCrossroad() const
{
  return crossroad.get();
}

Car* QmlPresenter::getSelectedCar() const
{
  return cars.GetSelectedCar();
}

CarsModel *QmlPresenter::getCars()
{
  return &cars;
}

QmlPresenter::QmlPresenter(QObject *parent) : QObject(parent)
{
  crossroad = std::make_unique<RegularCrossroad>();

  cars.AddCar();
  cars.AddCar();


  QObject::connect(&cars, &CarsModel::selectionIndexChanged, this, &QmlPresenter::selectedCarChanged);
  QObject::connect(crossroad.get(), &RegularCrossroad::sidesInserted, &graph, &MapGraph::RecalculateGraphNodesOnSidesInserted);
  QObject::connect(crossroad.get(), &RegularCrossroad::sidesRemoved, &graph, &MapGraph::RecalculateGraphNodesOnSidesRemoved);
}

void QmlPresenter::SaveCrossroad()
{
  QFile file("crossroad.txt");
  if (file.open(QIODevice::WriteOnly | QIODevice::Text))
  {
    QTextStream stream(&file);
    crossroad->Serialize(stream);
    file.close();
  }
}

bool QmlPresenter::OpenCrossroad()
{
  QFile file("crossroad.txt");
  if (!file.open(QIODevice::ReadOnly))
  {
    qWarning() << "Can't open file" << file.fileName();
    return false;
  }

  QTextStream stream(&file);
  bool result = crossroad->Deserialize(stream);

  file.close();

  QPoint in20 = crossroad->AtStopLine(2, 0);
  QPoint exit00 = crossroad->AtExit(0, 0);
  cars.GetCar(1)->SetRoute({ in20, exit00 });

  return result;
}

void QmlPresenter::GoToNextFrame()
{
  for (int i = 1; i < cars.rowCount(); ++i)
  {
    Car* car = cars.index(i, 0).data(DataRoles::CarData).value<Car*>();
    car->MoveAlongRoute();
  }
}
