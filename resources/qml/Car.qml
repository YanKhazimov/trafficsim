import QtQuick 2.15
import QtGraphicalEffects 1.12
import TrafficSimApp 1.0
import "Constants"

Item {
    id: root

    property CarModel model
    property Item viewItem
    readonly property int hDimension: Sizes.scaleToView(root.model.SourceDirection / 90 % 2 === 0 ? root.model.Length : root.model.Width)
    readonly property int vDimension: Sizes.scaleToView(root.model.SourceDirection / 90 % 2 === 0 ? root.model.Width : root.model.Length)

    x: Sizes.mapXToView(root.model.X, viewItem)
    y: Sizes.mapYToView(root.model.Y, viewItem)
    rotation: -root.model.DirectionDegrees + root.model.SourceDirection

    signal clicked()

    Behavior on x {
        PropertyAnimation {
            duration: engine.TickMilliseconds
        }
    }

    Behavior on y {
        PropertyAnimation {
            duration: engine.TickMilliseconds
        }
    }

    Behavior on rotation {
        RotationAnimation {
            duration: engine.TickMilliseconds
            direction: RotationAnimation.Shortest
        }
    }

    Image {
        id: img_const
        source: root.model.Source2dBase
        x: -root.hDimension/2
        y: -root.vDimension/2
        sourceSize.width: root.hDimension
        sourceSize.height: root.vDimension
        smooth: true
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: img_dynamic
        source: root.model.Source2dDynamic
        x: -root.hDimension/2
        y: -root.vDimension/2
        sourceSize.width: root.hDimension
        sourceSize.height: root.vDimension
        smooth: true
        visible: false
    }

    ColorOverlay {
        id: overlay
        anchors.fill: img_dynamic
        source: img_dynamic
        color: root.model.UserColor
    }

    MouseArea {
        anchors.centerIn: root
        width: root.model.Length
        height: root.model.Length
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
