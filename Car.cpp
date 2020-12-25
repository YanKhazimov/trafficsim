#include "Car.h"
#include <QtMath>

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

Car::Car(QObject *parent) : QObject(parent)
{

}

void Car::Move()
{

}
