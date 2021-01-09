#pragma once
#include <QObject>
#include <memory>

#include "RegularCrossroad.h"
#include "Car.h"
#include "CarsModel.h"

class QmlPresenter : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(QmlPresenter)

  Q_PROPERTY(RegularCrossroad* Crossroad READ getCrossroad CONSTANT)
  Q_PROPERTY(Car* SelectedCar READ getSelectedCar NOTIFY selectedCarChanged)
  Q_PROPERTY(EditorState EditorState MEMBER editorState NOTIFY editorStateChanged)
  Q_PROPERTY(CarsModel* Cars READ getCars NOTIFY carsChanged)

  RegularCrossroad* getCrossroad() const;
  Car* getSelectedCar() const;
  CarsModel* getCars();

  std::unique_ptr<RegularCrossroad> crossroad;
  CarsModel cars;

public:
  enum EditorState {
    NotEditing,
    InLaneSelection,
    OutLaneSelection
  };
  Q_ENUMS(EditorState)

  explicit QmlPresenter(QObject *parent = nullptr);

  Q_INVOKABLE void SaveCrossroad();
  Q_INVOKABLE bool OpenCrossroad();

  Q_INVOKABLE void GoToNextFrame();

private:
  EditorState editorState = EditorState::NotEditing;

signals:
  void editorStateChanged();
  void carsChanged();
  void selectedCarChanged();
};
