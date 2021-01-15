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

MapGraph *QmlPresenter::getGraph()
{
  return &graph;
}

int QmlPresenter::getViewScale() const
{
  return viewScalePct;
}

QmlPresenter::QmlPresenter(QObject *parent) : QObject(parent)
{
  crossroad = std::make_unique<RegularCrossroad>("Toreza");

  cars.AddCar(35, 70, QUrl("qrc:/images/car.png"), 90);
  cars.AddCar(40, 100, QUrl("qrc:/images/truck.png"), 180);

  graph.RegisterCrossroad(crossroad.get());

  QObject::connect(&cars, &CarsModel::selectionIndexChanged, this, &QmlPresenter::selectedCarChanged);
  QObject::connect(crossroad.get(), &RegularCrossroad::sidesInserted, &graph, &MapGraph::RecalculateOnSidesInserted);
  QObject::connect(crossroad.get(), &RegularCrossroad::sidesRemoved, &graph, &MapGraph::RecalculateOnSidesRemoved);
  QObject::connect(crossroad.get(), &RegularCrossroad::passagesInserted, &graph, &MapGraph::RecalculateOnPassagesInserted);
  QObject::connect(crossroad.get(), &RegularCrossroad::passagesRemoved, &graph, &MapGraph::RecalculateOnPassagesRemoved);

  QObject::connect(crossroad.get(), &RegularCrossroad::positionChanged, &graph, &MapGraph::RecalculateOnCrossroadPositionChanged);
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

  return result;
}

void QmlPresenter::GoToNextFrame()
{
  Car* selectedCar = getSelectedCar();
  if (selectedCar)
    selectedCar->MoveAlongRoute();
}

void QmlPresenter::ChangeViewScale(int steps)
{
  int newValue = qMax(50, qMin(200, viewScalePct + 10 * steps));
  if (newValue != viewScalePct)
  {
    viewScalePct = newValue;
    emit viewScaleChanged();
  }
}
