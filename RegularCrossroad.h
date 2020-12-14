#pragma once
#include "CrossroadSide.h"

#include <QObject>
#include <QMap>

class RegularCrossroad : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(RegularCrossroad)

  Q_PROPERTY(int SidesCount READ CountSides NOTIFY sidesChanged)
  Q_PROPERTY(CrossroadSide* Side1 READ GetSide1 CONSTANT)
  Q_PROPERTY(CrossroadSide* Side2 READ GetSide2 CONSTANT)

  QMap<qreal, CrossroadSide*> sides;

public:
  RegularCrossroad(QObject* parent = nullptr);
  bool AddSide(qreal angle, CrossroadSide* side);
  int CountSides() const;
  CrossroadSide* GetSide1() const;
  CrossroadSide* GetSide2() const;

signals:
  void sidesChanged();
};
Q_DECLARE_METATYPE(RegularCrossroad*)
