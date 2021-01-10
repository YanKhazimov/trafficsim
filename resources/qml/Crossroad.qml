import QtQuick 2.15
import QtQuick.Shapes 1.12
import "Constants"

Rectangle {
    id: root
    implicitHeight: 5
    implicitWidth: 5
    radius: 5/2
    border.color: Colors.lane
    border.width: 2

    function fill() {
        insides.path = []

        for (var i = 0; i < sidesRepeater.count * 2; ++i)
            insides.path.push(insides.getPoint(i))

        polyline.path = insides.path
    }

    Shape {
        id: insides
        antialiasing: true

        function getPoint(index) {
            if (index < 0 || index >= sidesRepeater.count * 2) {
                console.log("Cannot get point", index)
                return Qt.point(0, 0)
            }

            var side = index / 2

            return index % 2 === 0 ?
                        Qt.point(sidesRepeater.itemAt(side).x + sidesRepeater.itemAt(side).end.x,
                                 sidesRepeater.itemAt(side).y + sidesRepeater.itemAt(side).end.y) :
                        Qt.point(sidesRepeater.itemAt(side).x + sidesRepeater.itemAt(side).start.x,
                                 sidesRepeater.itemAt(side).y + sidesRepeater.itemAt(side).start.y)
        }
        property var path: []

        ShapePath {
            id: pathStart
            fillColor: Colors.lane
            strokeColor: "transparent"
            strokeWidth: 1
            startX: 0
            startY: 0

            PathPolyline {
                id: polyline
            }
        }
    }

    Repeater {
        id: sidesRepeater
        model: engine.Crossroad.Sides
        delegate: CrossroadSide {
            model: modelData
            x: modelData.StartX
            y: modelData.StartY
            onInLaneClicked: engine.Crossroad.SetNewPassageInLane(index, laneIndex)
            onOutLaneClicked: engine.Crossroad.SetNewPassageOutLane(index, laneIndex)
        }
    }

    Connections {
        target: engine.Crossroad
        function onSidesChanged() {
            sidesRepeater.model = []
            sidesRepeater.model = engine.Crossroad.Sides
            crossroadId.fill()
        }
        function onPassagesChanged() {
            passagesRepeater.model = []
            passagesRepeater.model = engine.Crossroad.Passages
        }
    }

    Repeater {
        id: passagesRepeater
        model: engine.Crossroad.Passages
        delegate: Passage {
            model: RolePassageData
            startX: engine.Crossroad.AtStopLine(RolePassageData.InSideIndex, RolePassageData.InLaneIndex).x - root.x
            startY: engine.Crossroad.AtStopLine(RolePassageData.InSideIndex, RolePassageData.InLaneIndex).y - root.y
            endX: engine.Crossroad.AtExit(RolePassageData.OutSideIndex, RolePassageData.OutLaneIndex).x - root.x
            endY: engine.Crossroad.AtExit(RolePassageData.OutSideIndex, RolePassageData.OutLaneIndex).y - root.y
        }
    }
}
