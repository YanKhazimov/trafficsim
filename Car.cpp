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

QList<QPoint> Car::getRoutePoints() const
{
  QList<QPoint> result;
  for (auto& point : route)
    result << point.first;
  return result;
}

void Car::SetPosition(int _x, int _y)
{
  x = _x;
  y = _y;
  emit parametersChanged();
}

Car::Car(int _width, int _length, QUrl _source, int _sourceDirection, QObject *parent)
  : QObject(parent), width(_width), length(_length), source(_source), sourceDirection(_sourceDirection)
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

  SetPosition(route[reachedRoutePoint].first.x(), route[reachedRoutePoint].first.y());
  setDirection(route[reachedRoutePoint].second);
}

void Car::AddRouteNode(Node* node)
{
  QPoint nodePosition = node->GetPosition();
  int sideNormal = node->crossroad->GetSide(node->side)->GetNormal();
  QPoint carCenter(nodePosition.x() + length/2 * qCos(node->crossroad->GetSide(node->side)->GetNormalInRadians()),
                   nodePosition.y() - length/2 * qSin(node->crossroad->GetSide(node->side)->GetNormalInRadians()));
  int direction = 0;
  if (node->type == Node::NodeType::CrossroadIn)
    direction = (sideNormal + 180) % 360;
  else if (node->type == Node::NodeType::CrossroadOut)
    direction = sideNormal;
  else
    qWarning() << "need to define node direction";
  route.append({ carCenter, direction });
  emit routeChanged();
}

void Car::SetRoute(const QList<QPair<QPoint, int>>& _route)
{
  route = _route;
  emit routeChanged();
}
