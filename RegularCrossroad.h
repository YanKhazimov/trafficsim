#pragma once
#include "CrossroadSide.h"

#include <QObject>
#include <QMap>

class RegularCrossroad : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(RegularCrossroad)

  Q_PROPERTY(int SidesCount READ CountSides NOTIFY sidesChanged)
  Q_PROPERTY(CrossroadSide* Side READ GetSide CONSTANT)

  QMap<qreal, CrossroadSide*> sides;

public:
  RegularCrossroad(QObject* parent = nullptr);
  bool AddSide(qreal angle, CrossroadSide* side);
  int CountSides() const;
  CrossroadSide* GetSide() const;

signals:
  void sidesChanged();
};
Q_DECLARE_METATYPE(RegularCrossroad*)
