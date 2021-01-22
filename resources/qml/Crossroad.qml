import QtQuick 2.15
import QtQuick.Shapes 1.12
import "Constants"

Item {
    id: root

    function fill(reason) {
        insides.path = []

        for (var i = 0; i < sidesRepeater.count * 2; ++i) {
            var point = insides.getPoint(i)
            if (point === null)
                return
            insides.path.push(point)
        }

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

            var side = Math.floor(index / 2)

            var sideItem = sidesRepeater.itemAt(side)
            if (sideItem === null) {
                return null
            }

            return index % 2 === 0 ?
                        Qt.point(sideItem.x + sideItem.end.x, sideItem.y + sideItem.end.y) :
                        Qt.point(sideItem.x + sideItem.start.x, sideItem.y + sideItem.start.y)
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
            x: Sizes.scaleToView(modelData.StartX)
            y: Sizes.scaleToView(modelData.StartY)
            onInLaneClicked: engine.Crossroad.SetNewPassageInLane(index, laneIndex)
            onOutLaneClicked: engine.Crossroad.SetNewPassageOutLane(index, laneIndex)
            onXChanged: crossroadId.fill("x")
            onYChanged: crossroadId.fill("y")
        }
    }

    Connections {
        target: engine.Crossroad
        function onSidesChanged() {
            sidesRepeater.model = []
            sidesRepeater.model = engine.Crossroad.Sides
            crossroadId.fill("sides")
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
            startX: Sizes.scaleToView(engine.Crossroad.AtStopLine(RolePassageData.InSideIndex, RolePassageData.InLaneIndex).x)
            startY: Sizes.scaleToView(engine.Crossroad.AtStopLine(RolePassageData.InSideIndex, RolePassageData.InLaneIndex).y)
            endX: Sizes.scaleToView(engine.Crossroad.AtExit(RolePassageData.OutSideIndex, RolePassageData.OutLaneIndex).x)
            endY: Sizes.scaleToView(engine.Crossroad.AtExit(RolePassageData.OutSideIndex, RolePassageData.OutLaneIndex).y)
        }
    }

    Rectangle {
        id: origin
        implicitHeight: 4
        implicitWidth: 4
        anchors.centerIn: parent
        color: "purple"
    }
}
