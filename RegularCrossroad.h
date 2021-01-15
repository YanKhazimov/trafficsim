#pragma once
#include "CrossroadSidesModel.h"
#include "Passage.h"
#include "CrossroadPassagesModel.h"

#include <QObject>
#include <QTextStream>

class RegularCrossroad : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(RegularCrossroad)

  Q_PROPERTY(int X MEMBER x NOTIFY positionChanged)
  Q_PROPERTY(int Y MEMBER y NOTIFY positionChanged)
  Q_PROPERTY(CrossroadSidesModel* Sides READ getSides NOTIFY sidesChanged)
  Q_PROPERTY(Passage* PassageUnderConstruction READ getPassageUnderConstruction CONSTANT)
  Q_PROPERTY(CrossroadPassagesModel* Passages READ getPassages NOTIFY passagesChanged)

  CrossroadSidesModel sides;

  Passage passageUnderConstruction;
  CrossroadPassagesModel passages;

  CrossroadSidesModel* getSides();
  Passage* getPassageUnderConstruction();
  CrossroadPassagesModel* getPassages();

  bool AddPassage(int inSideIndex, int inLaneIndex, int outSideIndex, int outLaneIndex);

  QString id;
  int x = 0, y = 0;

public:
  RegularCrossroad(QString id, QObject* parent = nullptr);
  Q_INVOKABLE bool AddSide(int laneWidth, int startX, int startY, qreal normal, int inLanesCount, int outLanesCount, int inOffset = 0, int outOffset = 0, int midOffset = 0);
  Q_INVOKABLE bool RemoveSide(int index);
  Q_INVOKABLE bool RemovePassage(int index);
  Q_INVOKABLE CrossroadSide* GetSide(int index);
  Passage* GetPassage(int index);
  Q_INVOKABLE bool Validate() const;
  void Serialize(QTextStream& stream) const;
  bool Deserialize(QTextStream& stream);
  Q_INVOKABLE void SetNewPassageInLane(int sideIndex, int laneIndex);
  Q_INVOKABLE void SetNewPassageOutLane(int sideIndex, int laneIndex);
  Q_INVOKABLE void ConstructPassage();
  Q_INVOKABLE QPoint AtStopLine(int sideIndex, int laneIndex) const;
  Q_INVOKABLE QPoint AtExit(int sideIndex, int laneIndex) const;
  int CountSides() const;
  int CountPassages() const;
  QString GetId() const;

signals:
  void sidesChanged();
  void sidesInserted(RegularCrossroad* crossroad, int first, int last);
  void sidesRemoved(RegularCrossroad* crossroad, int first, int last);
  void sideParametersChanged(int side);
  void passagesChanged();
  void passagesInserted(RegularCrossroad* crossroad, int first, int last);
  void passagesRemoved(RegularCrossroad* crossroad, int first, int last);
  void positionChanged();
};
Q_DECLARE_METATYPE(RegularCrossroad*)
