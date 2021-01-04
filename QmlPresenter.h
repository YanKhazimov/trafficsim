#pragma once
#include <QObject>
#include <memory>

#include "RegularCrossroad.h"
#include "Car.h"

class QmlPresenter : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(QmlPresenter)

  Q_PROPERTY(RegularCrossroad* Crossroad READ getCrossroad CONSTANT)
  Q_PROPERTY(Car* Car READ getCar CONSTANT)
  Q_PROPERTY(EditorState EditorState MEMBER editorState NOTIFY editorStateChanged)

  RegularCrossroad* getCrossroad() const;
  Car* getCar() const;

  std::unique_ptr<RegularCrossroad> crossroad;
  std::unique_ptr<Car> car;

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
};
