import QtQuick 2.15
import TrafficSimApp 1.0
import "Constants"

Item {
    id: root
    property CarModel model
    signal clicked()

    Image {
        id: img
        source: "qrc:/images/car.png"
        sourceSize.width: Sizes.laneWidth
        x: root.model.X - root.model.Width/2
        y: root.model.Y - root.model.Length/2
        rotation: root.model.DirectionDegrees
    }

    MouseArea {
        anchors.fill: img
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
