#pragma once
#include "Lane.h"

#include <QObject>
#include <QVector>
#include <QTextStream>
#include <QPoint>

class CrossroadSide : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(CrossroadSide)

  Q_PROPERTY(QList<Lane*> InLanes READ getInLanes NOTIFY parametersChanged)
  Q_PROPERTY(QList<Lane*> OutLanes READ getOutLanes NOTIFY parametersChanged)
  Q_PROPERTY(int InLanesCount READ GetInLanesCount NOTIFY parametersChanged)
  Q_PROPERTY(int OutLanesCount READ GetOutLanesCount NOTIFY parametersChanged)
  Q_PROPERTY(int InOffset MEMBER inOffset NOTIFY parametersChanged) // ensure not negative
  Q_PROPERTY(int OutOffset MEMBER outOffset NOTIFY parametersChanged) // ensure not negative
  Q_PROPERTY(int MidOffset MEMBER midOffset NOTIFY parametersChanged) // ensure not negative
  Q_PROPERTY(int Length READ getLength NOTIFY parametersChanged)
  Q_PROPERTY(int NormalDegrees READ GetNormal WRITE setNormal NOTIFY parametersChanged)
  Q_PROPERTY(qreal NormalRadians READ GetNormalInRadians NOTIFY parametersChanged)
  Q_PROPERTY(int StartX MEMBER startX NOTIFY parametersChanged)
  Q_PROPERTY(int StartY MEMBER startY NOTIFY parametersChanged)

  Q_PROPERTY(bool IsHighlighted MEMBER isHighlighted NOTIFY isHighlightedChanged)
  Q_PROPERTY(bool IsHighlightedX MEMBER isHighlightedX NOTIFY isHighlightedXChanged)
  Q_PROPERTY(bool IsHighlightedY MEMBER isHighlightedY NOTIFY isHighlightedYChanged)
  Q_PROPERTY(bool IsHighlightedR MEMBER isHighlightedR NOTIFY isHighlightedRChanged)

  const int laneWidth;
  int startX, startY;
  int normal; // rounded in degrees
  QVector<Lane*> inLanes;
  QVector<Lane*> outLanes;
  int inOffset, outOffset, midOffset;

  bool isHighlighted = false;
  bool isHighlightedX = false;
  bool isHighlightedY = false;
  bool isHighlightedR = false;

  QList<Lane*> getInLanes() const;
  QList<Lane*> getOutLanes() const;
  void setNormal(int degrees);
  int getLength() const;

public:
  CrossroadSide(QObject* parent = nullptr);
  CrossroadSide(int laneWidth, int startX, int startY, int normal, int inLanesCount, int outLanesCount,
                int inOffset = 0, int outOffset = 0, int midOffset = 0, QObject* parent = nullptr);

  int GetNormal() const;
  qreal GetNormalInRadians() const;
  int GetInLanesCount() const;
  int GetOutLanesCount() const;
  int GetX() const;
  int GetY() const;
  Q_INVOKABLE bool AddInLane();
  Q_INVOKABLE bool RemoveInLane();
  Q_INVOKABLE bool AddOutLane();
  Q_INVOKABLE bool RemoveOutLane();

  void Serialize(QTextStream& stream) const;

  QPoint AtStopLine(int laneIndex) const;
  QPoint AtExit(int laneIndex) const;

signals:
  void parametersChanged();
  void isHighlightedChanged();
  void isHighlightedXChanged();
  void isHighlightedYChanged();
  void isHighlightedRChanged();
};
Q_DECLARE_METATYPE(CrossroadSide*)
