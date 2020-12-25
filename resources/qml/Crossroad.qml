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

    function atStopLine(sideNumber, inLaneNumber) {
        if (sideNumber >= engine.Crossroad.Sides.length) {
            console.error("Crossroad does not have side", sideNumber)
            return Qt.point(0, 0)
        }

        var local = sidesRepeater.itemAt(sideNumber).atStopLine(inLaneNumber)
        return Qt.point(sidesRepeater.itemAt(sideNumber).x + local.x,
                        sidesRepeater.itemAt(sideNumber).y + local.y)
    }

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
            model: RoleSideData
            x: modelData.StartX
            y: modelData.StartY
        }
    }


    Connections {
        target: engine.Crossroad
        function onSidesChanged() {
            sidesRepeater.model = []
            sidesRepeater.model = engine.Crossroad.Sides
            crossroadId.fill()
        }
    }
}
