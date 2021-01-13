#pragma once

#include <QObject>
#include <QList>
#include <QPoint>
#include <QUrl>
#include "NodesModel.h"

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
  Q_PROPERTY(QUrl Source MEMBER source CONSTANT)
  Q_PROPERTY(int SourceDirection MEMBER sourceDirection CONSTANT)

  Q_PROPERTY(QList<QPoint> RoutePoints READ getRoutePoints NOTIFY routeChanged)
  Q_PROPERTY(int ReachedRoutePoint MEMBER reachedRoutePoint NOTIFY reachedRoutePointChanged)

  int width, length;
  QUrl source; int sourceDirection;
  int x = 0, y = 0;
  int direction = 45; // rounded in degrees

  QList<QPair<QPoint, int>> route; // car center, direction
  int reachedRoutePoint = -1;

  int getDirection() const;
  qreal getDirectionInRadians() const;
  void setDirection(int degrees);
  QList<QPoint> getRoutePoints() const;

public:
  explicit Car(int width, int length, QUrl source, int sourceDirection, QObject *parent = nullptr);
  Q_INVOKABLE void MoveAlongRoute();
  Q_INVOKABLE void AddRouteNode(Node* node);
  void SetPosition(int x, int y);
  void SetRoute(const QList<QPair<QPoint, int>> &route);

signals:
  void parametersChanged();
  void routeChanged();
  void reachedRoutePointChanged();

};
Q_DECLARE_METATYPE(Car*)
