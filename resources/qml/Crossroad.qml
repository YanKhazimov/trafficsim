import QtQuick 2.0
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

    Repeater {
        id: sidesRepeater
        model: engine.Crossroad.Sides
        delegate: CrossroadSide {
            model: modelData
            x: modelData.StartX
            y: modelData.StartY
        }
    }
}
