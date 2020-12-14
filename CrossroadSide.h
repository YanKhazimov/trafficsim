#pragma once
#include "Lane.h"

#include <QObject>
#include <QVector>

class CrossroadSide : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(CrossroadSide)

  Q_PROPERTY(int InLanesCount READ CountInLanes NOTIFY inLanesChanged)
  Q_PROPERTY(int OutLanesCount READ CountOutLanes NOTIFY outLanesChanged)
  Q_PROPERTY(int InOffset MEMBER inOffset CONSTANT)
  Q_PROPERTY(int OutOffset MEMBER outOffset CONSTANT)
  Q_PROPERTY(int MidOffset MEMBER midOffset CONSTANT)

  QVector<Lane> inLanes;
  QVector<Lane> outLanes;
  int inOffset, outOffset, midOffset;

  int CountInLanes() const;
  int CountOutLanes() const;

public:
  CrossroadSide(QObject* parent = nullptr);
  CrossroadSide(int inLanesCount, int outLanesCount, int inOffset = 0, int outOffset = 0, int midOffset = 0, QObject* parent = nullptr);

  Q_INVOKABLE int GetLength(int laneWidth) const;

signals:
  void inLanesChanged();
  void outLanesChanged();
};
Q_DECLARE_METATYPE(CrossroadSide*)
