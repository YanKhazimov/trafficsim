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

public:
  RegularCrossroad(QObject* parent = nullptr);
  Q_INVOKABLE bool AddSide(int laneWidth, int startX, int startY, qreal normal, int inLanesCount, int outLanesCount, int inOffset = 0, int outOffset = 0, int midOffset = 0);
  Q_INVOKABLE bool RemoveSide(int index);
  Q_INVOKABLE bool RemovePassage(int index);
  Q_INVOKABLE CrossroadSide* GetSide(int index);
  Q_INVOKABLE bool Validate() const;
  void Serialize(QTextStream& stream) const;
  bool Deserialize(QTextStream& stream);
  Q_INVOKABLE void SetNewPassageInLane(int sideIndex, int laneIndex);
  Q_INVOKABLE void SetNewPassageOutLane(int sideIndex, int laneIndex);
  Q_INVOKABLE void ConstructPassage();

signals:
  void sidesChanged();
  void passagesChanged();
};
Q_DECLARE_METATYPE(RegularCrossroad*)
