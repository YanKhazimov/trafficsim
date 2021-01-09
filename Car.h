#pragma once

#include <QObject>
#include <QList>
#include <QPoint>

class Car : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(Car)

  Q_PROPERTY(int DirectionDegrees READ getDirection WRITE setDirection NOTIFY parametersChanged)
  Q_PROPERTY(qreal DirectionRadians READ getDirectionInRadians NOTIFY parametersChanged)
  Q_PROPERTY(int X MEMBER x NOTIFY parametersChanged)
  Q_PROPERTY(int Y MEMBER y NOTIFY parametersChanged)
  Q_PROPERTY(int Width MEMBER width CONSTANT)
  Q_PROPERTY(int Length MEMBER length CONSTANT)

  Q_PROPERTY(QList<QPoint> RoutePoints MEMBER route NOTIFY routeChanged)
  Q_PROPERTY(int ReachedRoutePoint MEMBER reachedRoutePoint NOTIFY reachedRoutePointChanged)

  int width = 40, length = 80;
  int x = 0, y = 0;
  int direction = 0; // rounded in degrees

  QList<QPoint> route;
  int reachedRoutePoint = -1;

  int getDirection() const;
  qreal getDirectionInRadians() const;
  void setDirection(int degrees);

public:
  explicit Car(QObject *parent = nullptr);
  Q_INVOKABLE void MoveAlongRoute();
  void SetPosition(int x, int y);
  void SetRoute(const QList<QPoint> &route);

signals:
  void parametersChanged();
  void routeChanged();
  void reachedRoutePointChanged();

};
Q_DECLARE_METATYPE(Car*)
