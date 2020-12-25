#include "QmlPresenter.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

RegularCrossroad *QmlPresenter::getCrossroad() const
{
  return crossroad.get();
}

QmlPresenter::QmlPresenter(QObject *parent) : QObject(parent)
{
  crossroad = std::make_unique<RegularCrossroad>();
  car = std::make_unique<Car>();
}

void QmlPresenter::SaveCrossroad()
{
  QFile file("crossroad.txt");
  if (file.open(QIODevice::WriteOnly | QIODevice::Text))
  {
    QTextStream stream(&file);
    crossroad->Serialize(stream);
    file.close();
  }
}

bool QmlPresenter::OpenCrossroad()
{
  QFile file("crossroad.txt");
  if (!file.open(QIODevice::ReadOnly))
  {
    qWarning() << "Can't open file" << file.fileName();
    return false;
  }

  QTextStream stream(&file);
  bool result = crossroad->Deserialize(stream);

  file.close();
  return result;
}

void QmlPresenter::GoToNextFrame()
{
  car->Move();
}
