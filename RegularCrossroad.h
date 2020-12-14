#pragma once
#include "CrossroadSide.h"

#include <QObject>
#include <QMap>

class RegularCrossroad : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(RegularCrossroad)

  Q_PROPERTY(int SidesCount READ CountSides NOTIFY sidesChanged)
  Q_PROPERTY(QList<CrossroadSide*> Sides READ GetSides CONSTANT)

  QList<CrossroadSide*> sides;

public:
  RegularCrossroad(QObject* parent = nullptr);
  bool AddSide(CrossroadSide* side);
  int CountSides() const;
  QList<CrossroadSide*> GetSides() const;

signals:
  void sidesChanged();
};
Q_DECLARE_METATYPE(RegularCrossroad*)
