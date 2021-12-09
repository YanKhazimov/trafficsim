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

Car::Car(int _width, int _length, QUrl _source3d, QUrl _source2dBase, QUrl _source2dDynamic, int _sourceDirection, QObject *parent)
  : QObject(parent), width(_width), length(_length), source3d(_source3d), source2dBase(_source2dBase), source2dDynamic(_source2dDynamic),
    userColor(255, 0, 0, 150), sourceDirection(_sourceDirection)
{
}

void Car::MoveAlongRoute()
{
  // just teleport to the next route point
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

void Car::MoveAlongRoadLane(QObject *qmlRoot)
{
  int currentRoadLane = 1;

  QVariant accurateTotalLength = 0.0;
  QMetaObject::invokeMethod(qmlRoot, "roadLaneLength",
                            Q_RETURN_ARG(QVariant, accurateTotalLength),
                            Q_ARG(QVariant, currentRoadLane));

  static int counter = -1;
  counter = counter + 1;
  qreal moveDistance = qMin(counter * 20.0, accurateTotalLength.value<qreal>()); // TODO replace 20 with tick travel distance

  qreal moveProgress = moveDistance / accurateTotalLength.value<qreal>();
  QVariant coordsVariant;
  QMetaObject::invokeMethod(qmlRoot, "roadLaneCoords",
                            Q_RETURN_ARG(QVariant, coordsVariant),
                            Q_ARG(QVariant, currentRoadLane),
                            Q_ARG(QVariant, moveProgress));

  QVariantMap coords = coordsVariant.value<QVariantMap>();
  Q_ASSERT(coords.contains("x") && coords.contains("y") && coords.contains("rotation"));
  int x = coords.value("x").toInt();
  int y = coords.value("y").toInt();
  // interpolation rotation is clockwise
  int angle = -(coords.value("rotation").toInt());

  SetPosition(x, y);
  setDirection(angle);
}

void Car::MoveAlongPassage(QObject *qmlRoot)
{
  int currentPassage = 0;

  QVariant accurateTotalLength = 0.0;
  QMetaObject::invokeMethod(qmlRoot, "passageLength",
                            Q_RETURN_ARG(QVariant, accurateTotalLength),
                            Q_ARG(QVariant, currentPassage));

  static int counter = -1;
  counter = counter + 1;
  qreal moveDistance = qMin(counter * 20.0, accurateTotalLength.value<qreal>()); // TODO replace 20 with tick travel distance

  qreal moveProgress = moveDistance / accurateTotalLength.value<qreal>();
  QVariant coordsVariant;
  QMetaObject::invokeMethod(qmlRoot, "passageCoords",
                            Q_RETURN_ARG(QVariant, coordsVariant),
                            Q_ARG(QVariant, currentPassage),
                            Q_ARG(QVariant, moveProgress));

  QVariantMap coords = coordsVariant.value<QVariantMap>();
  Q_ASSERT(coords.contains("x") && coords.contains("y") && coords.contains("rotation"));
  int x = coords.value("x").toInt();
  int y = coords.value("y").toInt();
  // interpolation rotation is clockwise
  int angle = -(coords.value("rotation").toInt());

  SetPosition(x, y);
  setDirection(angle);
}

void Car::AddRouteNode(Node* node)
{
  QPoint nodePosition = node->GetPosition();
  QPoint carCenter;
  qreal direction = node->GetAngle();

  switch (node->type)
  {
  case Node::NodeType::CrossroadIn:
  {
    carCenter = QPoint(nodePosition.x() - length/2 * qCos(qDegreesToRadians(direction)),
                        nodePosition.y() + length/2 * qSin(qDegreesToRadians(direction)));
    break;
  }
  case Node::NodeType::CrossroadOut:
  {
    carCenter = QPoint(nodePosition.x() + length/2 * qCos(qDegreesToRadians(direction)),
                        nodePosition.y() - length/2 * qSin(qDegreesToRadians(direction)));
    break;
  }
  case Node::NodeType::RoadJoint:
  {
    carCenter = QPoint(nodePosition.x(), nodePosition.y());
    break;
  }
  default:
    qWarning() << "need to define node direction. route node not added";
    return;
  }

  route.append({ carCenter, (int)direction });
  emit routeChanged();
}

void Car::SetRoute(const QList<QPair<QPoint, int>>& _route)
{
  route = _route;
  emit routeChanged();
}
