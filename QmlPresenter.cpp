#include "QmlPresenter.h"

RegularCrossroad *QmlPresenter::getCrossroad() const
{
  return crossroad.get();
}

QmlPresenter::QmlPresenter(QObject *parent) : QObject(parent)
{
  crossroad = std::make_unique<RegularCrossroad>();
}
