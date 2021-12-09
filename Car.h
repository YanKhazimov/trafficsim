#pragma once

#include <QObject>
#include <QList>
#include <QPoint>
#include <QUrl>
#include <QColor>
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
  Q_PROPERTY(QUrl Source2dBase MEMBER source2dBase CONSTANT)
  Q_PROPERTY(QUrl Source2dDynamic MEMBER source2dDynamic CONSTANT)
  Q_PROPERTY(QUrl Source3d MEMBER source3d CONSTANT)
  Q_PROPERTY(QColor UserColor MEMBER userColor NOTIFY userColorChanged)
  Q_PROPERTY(int SourceDirection MEMBER sourceDirection CONSTANT)

  Q_PROPERTY(QList<QPoint> RoutePoints READ getRoutePoints NOTIFY routeChanged)
  Q_PROPERTY(int ReachedRoutePoint MEMBER reachedRoutePoint NOTIFY reachedRoutePointChanged)

  int width, length;
  QUrl source3d;
  QUrl source2dBase;
  QUrl source2dDynamic;
  int sourceDirection;
  QColor userColor;
  int x = 0, y = 0;
  int direction = 45; // rounded in degrees

  QList<QPair<QPoint, int>> route; // car center, direction
  int reachedRoutePoint = -1;

  int getDirection() const;
  qreal getDirectionInRadians() const;
  void setDirection(int degrees);
  QList<QPoint> getRoutePoints() const;

public:
  explicit Car(int width, int length, QUrl source3d, QUrl source2dBase, QUrl source2dColored, int sourceDirection, QObject *parent = nullptr);
  Q_INVOKABLE void MoveAlongRoute();
  Q_INVOKABLE void MoveAlongRoadLane(QObject *qmlRoot);
  Q_INVOKABLE void MoveAlongPassage(QObject *qmlRoot);
  Q_INVOKABLE void AddRouteNode(Node* node);
  void SetPosition(int x, int y);
  void SetRoute(const QList<QPair<QPoint, int>> &route);

  // TODO set graph

signals:
  void parametersChanged();
  void routeChanged();
  void reachedRoutePointChanged();
  void userColorChanged();

};
Q_DECLARE_METATYPE(Car*)
