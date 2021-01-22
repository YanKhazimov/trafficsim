#pragma once
#include <QObject>

class Lane : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(Lane)

public:
  explicit Lane(QObject *parent = nullptr);
};
