#include "Car.h"
#include <QtMath>
#include <QDebug>

int Car::getDirection() const
{
  return direction;
}

qreal Car::getDirectionInRadians() const
{
  return qDegreesToRadians(static_cast<qreal>(direction));
}

void Car::setDirection(int degrees)
{
  while (degrees < 0)
    degrees += 360;
  direction = degrees % 360;
  emit parametersChanged();
}

void Car::SetPosition(int _x, int _y)
{
  x = _x;
  y = _y;
  emit parametersChanged();
}

Car::Car(QObject *parent) : QObject(parent)
{
}

void Car::MoveAlongRoute()
{
  if (route.empty())
  {
    qWarning() << "empty route";
    return;
  }

  reachedRoutePoint = (reachedRoutePoint + 1) % route.size();
  emit reachedRoutePointChanged();

  SetPosition(route[reachedRoutePoint].x(), route[reachedRoutePoint].y());
}

void Car::SetRoute(const QList<QPoint>& _route)
{
  route = _route;
  emit routeChanged();
}
