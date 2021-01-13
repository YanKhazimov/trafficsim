import QtQuick 2.15
import TrafficSimApp 1.0
import "Constants"

Item {
    id: root
    property CarModel model
    signal clicked()

    Image {
        id: img
        readonly property int hDimension: root.model.SourceDirection / 90 % 2 === 0 ? root.model.Length : root.model.Width
        readonly property int vDimension: root.model.SourceDirection / 90 % 2 === 0 ? root.model.Width : root.model.Length
        source: root.model.Source
        sourceSize.width: hDimension
        x: root.model.X - hDimension/2
        y: root.model.Y - vDimension/2
        rotation: -root.model.DirectionDegrees + root.model.SourceDirection
    }

    MouseArea {
        anchors.centerIn: img
        width: root.model.Length
        height: root.model.Length
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
