#pragma once
#include <QObject>
#include <memory>

#include "RegularCrossroad.h"
#include "Car.h"
#include "CarsModel.h"
#include "MapGraph.h"
#include "RoadLanesModel.h"

class QmlPresenter : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(QmlPresenter)

  Q_PROPERTY(RegularCrossroad* Crossroad READ getCrossroad CONSTANT)
  Q_PROPERTY(Car* SelectedCar READ getSelectedCar NOTIFY selectedCarChanged)
  Q_PROPERTY(EditorState EditorState MEMBER editorState NOTIFY editorStateChanged)
  Q_PROPERTY(CarsModel* Cars READ getCars NOTIFY carsChanged)
  Q_PROPERTY(MapGraph* Graph READ getGraph NOTIFY graphChanged)
  Q_PROPERTY(QPoint ViewCenter MEMBER viewCenter NOTIFY viewCenterChanged)
  Q_PROPERTY(int ViewScale READ getViewScale NOTIFY viewScaleChanged)
  Q_PROPERTY(RoadLane* RoadUnderConstruction READ getRoadUnderConstruction NOTIFY roadUnderConstructionChanged)
  Q_PROPERTY(RoadLanesModel* RoadLanes READ getRoadLanes NOTIFY roadLanesChanged)

  RegularCrossroad* getCrossroad() const;
  RoadLane* getRoadUnderConstruction() const;
  Car* getSelectedCar() const;
  CarsModel* getCars();
  MapGraph* getGraph();
  RoadLanesModel* getRoadLanes();
  int getViewScale() const;

  std::unique_ptr<RegularCrossroad> crossroad;
  std::unique_ptr<RoadLane> roadUnderConstruction;
  CarsModel cars;
  MapGraph graph;
  RoadLanesModel roadLanes;

  QPoint viewCenter = QPoint(0, 0);
  int viewScalePct = 100;

public:
  enum EditorState {
    NotEditing,
    InLaneSelection,
    OutLaneSelection,
    RouteCreation,
    RoadCreation
  };
  Q_ENUMS(EditorState)

  explicit QmlPresenter(QObject *parent = nullptr);

  Q_INVOKABLE void SaveCrossroad();
  Q_INVOKABLE bool OpenCrossroad();

  Q_INVOKABLE void GoToNextFrame();

  Q_INVOKABLE void ChangeViewScale(int steps);

  Q_INVOKABLE void AddRoad();

private:
  EditorState editorState = EditorState::NotEditing;

signals:
  void editorStateChanged();
  void carsChanged();
  void selectedCarChanged();
  void graphChanged();
  void viewCenterChanged();
  void viewScaleChanged();
  void roadUnderConstructionChanged();
  void roadLanesChanged();
};
