#pragma once
#include <QObject>
#include <memory>

#include "RegularCrossroad.h"

class QmlPresenter : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(QmlPresenter)

  Q_PROPERTY(RegularCrossroad* Crossroad READ getCrossroad CONSTANT)

  RegularCrossroad* getCrossroad() const;

  std::unique_ptr<RegularCrossroad> crossroad;

public:
  explicit QmlPresenter(QObject *parent = nullptr);

  Q_INVOKABLE void SaveCrossroad();
  Q_INVOKABLE bool OpenCrossroad();
};
