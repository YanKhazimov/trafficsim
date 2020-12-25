#pragma once

#include <QObject>

class Car : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(Car)

  Q_PROPERTY(int DirectionDegrees READ getDirection WRITE setDirection NOTIFY parametersChanged)
  Q_PROPERTY(qreal DirectionRadians READ getDirectionInRadians NOTIFY parametersChanged)
  Q_PROPERTY(int X MEMBER x NOTIFY parametersChanged)
  Q_PROPERTY(int Y MEMBER y NOTIFY parametersChanged)
  Q_PROPERTY(int Width MEMBER width CONSTANT)
  Q_PROPERTY(int Height MEMBER height CONSTANT)

  int direction = 0; // rounded in degrees
  int width, height;
  int x = 0, y = 0;

  int getDirection() const;
  qreal getDirectionInRadians() const;
  void setDirection(int degrees);

public:
  explicit Car(QObject *parent = nullptr);
  void Move();

signals:
  void parametersChanged();

};
Q_DECLARE_METATYPE(Car*)
