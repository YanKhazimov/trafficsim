import QtQuick 2.0
import QtQuick.Shapes 1.12
import "Constants"

Rectangle {
    id: root
    implicitHeight: 300
    implicitWidth: crossroad.Sides[0]._GetLength(Sizes.laneWidth)

    color: Colors.lane

    Text {
        id: name
        text: root.width
        color: "white"
    }

    // side 0
    CrossroadSide {
        x: root.width / 2
        y: 0
        model: crossroad.Sides[0]
    }

    // side 1
    CrossroadSide {
        x: root.width
        y: root.height / 2
        model: crossroad.Sides[1]
    }

    CrossroadSide {
        x: root.width / 2
        y: root.height
        model: crossroad.Sides[2]
    }

    CrossroadSide {
        x: 0
        y: root.height / 2
        model: crossroad.Sides[3]
    }
}
