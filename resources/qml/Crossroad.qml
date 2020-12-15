import QtQuick 2.0
import QtQuick.Shapes 1.12
import "Constants"

Rectangle {
    id: root
    implicitHeight: 300
    implicitWidth: 300//crossroad.Sides[0]._GetLength(Sizes.laneWidth)

    color: Colors.lane

    Text {
        id: name
        text: root.width
        color: "white"
    }

    function atStopLine(sideNumber, inLaneNumber) {
        if (sideNumber >= crossroad.Sides.length) {
            console.error("Crossroad does not have side", sideNumber)
            return Qt.point(0, 0)
        }

        var local = sidesRepeater.itemAt(sideNumber).atStopLine(inLaneNumber)
        return Qt.point(sidesRepeater.itemAt(sideNumber).x + local.x,
                        sidesRepeater.itemAt(sideNumber).y + local.y)
    }

    Repeater {
        id: sidesRepeater
        model: crossroad.Sides
        delegate: CrossroadSide {
            model: modelData
            x: root.width/2 + root.width/2 * Math.cos(modelData.Normal)
            y: root.height/2 - root.height/2 * Math.sin(modelData.Normal)
        }
    }
}
