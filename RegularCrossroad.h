#pragma once
#include "CrossroadSidesModel.h"

#include <QObject>
#include <QTextStream>

class RegularCrossroad : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(RegularCrossroad)

  Q_PROPERTY(CrossroadSidesModel* Sides READ GetSides NOTIFY sidesChanged)

  CrossroadSidesModel sides;

public:
  RegularCrossroad(QObject* parent = nullptr);
  Q_INVOKABLE bool AddSide(int laneWidth, int startX, int startY, qreal normal, int inLanesCount, int outLanesCount, int inOffset = 0, int outOffset = 0, int midOffset = 0);
  Q_INVOKABLE bool RemoveSide(int index);
  Q_INVOKABLE CrossroadSide* GetSide(int index);
  Q_INVOKABLE bool Validate() const;
  int CountSides() const;
  CrossroadSidesModel* GetSides();
  void Serialize(QTextStream& stream) const;
  bool Deserialize(QTextStream& stream);

signals:
  void sidesChanged();
};
Q_DECLARE_METATYPE(RegularCrossroad*)
