#include "QmlPresenter.h"
#include "DataRoles.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QFileInfo>

RegularCrossroad *QmlPresenter::getCrossroad() const
{
  return crossroad.get();
}

RoadLane *QmlPresenter::getRoadUnderConstruction() const
{
  return roadUnderConstruction.get();
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

RoadLanesModel* QmlPresenter::getRoadLanes()
{
  return &roadLanes;
}

int QmlPresenter::getViewScale() const
{
  return viewScalePct;
}

QmlPresenter::QmlPresenter(QObject *parent) : QObject(parent)
{
  crossroad = std::make_unique<RegularCrossroad>("Toreza");
  graph.RegisterCrossroad(crossroad.get());

  roadUnderConstruction = std::make_unique<RoadLane>();

  cars.AddCar(30, 65, QUrl("qrc:/models3d/xc70/XC70.qml"), QUrl("qrc:/images/xc70_base.png"), QUrl("qrc:/images/xc70_dynamic.png"), 270);
  cars.AddCar(28, 55, QUrl("qrc:/models3d/a45/A45.qml"), QUrl("qrc:/images/a45_base.png"), QUrl("qrc:/images/a45_dynamic.png"), 90);

  QObject::connect(&cars, &CarsModel::selectionIndexChanged, this, &QmlPresenter::selectedCarChanged);

  QObject::connect(&roadLanes, &RoadLanesModel::rowsInserted, this, &QmlPresenter::roadLanesChanged);
}

void QmlPresenter::SaveMap()
{
  QFile fileToreza("toreza.txt");
  if (fileToreza.open(QIODevice::WriteOnly | QIODevice::Text))
  {
    QTextStream stream(&fileToreza);
    crossroad->Serialize(stream);
    fileToreza.close();
  }

  QFile fileLanes("lanes.txt");
  if (fileLanes.open(QIODevice::WriteOnly | QIODevice::Text))
  {
    QTextStream stream(&fileLanes);
    roadLanes.Serialize(stream);
    fileLanes.close();
  }
}

bool QmlPresenter::OpenMap()
{
  QFile fileToreza("toreza.txt");
  if (!fileToreza.open(QIODevice::ReadOnly))
  {
    qWarning() << "Can't open file" << fileToreza.fileName();
    return false;
  }

  QTextStream stream(&fileToreza);
  bool result = crossroad->Deserialize(stream);

  fileToreza.close();

  QFile fileLanes("lanes.txt");
  if (!fileLanes.open(QIODevice::ReadOnly))
  {
    qWarning() << "Can't open file" << fileLanes.fileName();
    return false;
  }

  QTextStream streamLanes(&fileLanes);
  result &= roadLanes.Deserialize(streamLanes, crossroad.get(), &graph);

  fileLanes.close();

  return result;
}

void QmlPresenter::GoToNextFrame()
{
  Car* selectedCar = getSelectedCar();
  if (selectedCar)
    selectedCar->MoveAlongRoute();
}

void QmlPresenter::MoveAlongLane()
{
  Car* selectedCar = getSelectedCar();
  if (selectedCar)
    selectedCar->MoveAlongRoadLane(qmlRoot);
}

void QmlPresenter::MoveAlongPassage0()
{
  Car* selectedCar = getSelectedCar();
  if (selectedCar)
    selectedCar->MoveAlongPassage(qmlRoot);
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

void QmlPresenter::AddRoad()
{
  const auto& trajectory = roadUnderConstruction->GetPoints();
  if (!trajectory.empty())
  {
    roadLanes.AddRoadLane(roadUnderConstruction.get());
    graph.RegisterRoadlane(roadLanes.index(roadLanes.rowCount() - 1, 0).data(DataRoles::RoadLaneData).value<RoadLane*>());
  }

  roadUnderConstruction->Clear();
}

void QmlPresenter::SetQmlRoot(QObject *object)
{
    qmlRoot = object;
}

QString QmlPresenter::CropFilename(QUrl filepath) const
{
    return QFileInfo(filepath.toString()).fileName();
}
