import QtQuick 2.15
import TrafficSimApp 1.0
import "Constants"

Item {
    id: root
    property CarModel model
    property Item viewItem
    x: Sizes.mapXToView(root.model.X, viewItem)
    y: Sizes.mapYToView(root.model.Y, viewItem)
    signal clicked()

    Image {
        id: img
        readonly property int hDimension: Sizes.scaleToView(root.model.SourceDirection / 90 % 2 === 0 ? root.model.Length : root.model.Width)
        readonly property int vDimension: Sizes.scaleToView(root.model.SourceDirection / 90 % 2 === 0 ? root.model.Width : root.model.Length)
        source: root.model.Source
        sourceSize.width: hDimension
        x: -hDimension/2
        y: -vDimension/2
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
