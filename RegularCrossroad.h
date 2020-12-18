#pragma once
#include "CrossroadSide.h"

#include <QObject>
#include <QMap>

class RegularCrossroad : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(RegularCrossroad)

  Q_PROPERTY(QList<CrossroadSide*> Sides READ GetSides NOTIFY sidesChanged)

  QList<CrossroadSide*> sides;

public:
  RegularCrossroad(QObject* parent = nullptr);
  Q_INVOKABLE bool AddSide(int laneWidth, int startX, int startY, qreal normal, int inLanesCount, int outLanesCount, int inOffset = 0, int outOffset = 0, int midOffset = 0);
  Q_INVOKABLE bool RemoveSide(int index);
  Q_INVOKABLE bool Validate() const;
  int CountSides() const;
  QList<CrossroadSide*> GetSides() const;
  virtual ~RegularCrossroad();

signals:
  void sidesChanged();
};
Q_DECLARE_METATYPE(RegularCrossroad*)
