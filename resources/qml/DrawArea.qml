import QtQuick 2.15
import QtQuick.Shapes 1.12
import "Constants"

MouseArea {
    id: root

    clip: true
    cursorShape: enabled ? Qt.CrossCursor : Qt.ArrowCursor
    pressAndHoldInterval: 100

    onPressed: {
        sideDirectionPreview.startX = mouseX
        sideDirectionPreview.startY = mouseY
        sideDirectionPreview.endX = mouseX
        sideDirectionPreview.endY = mouseY
    }
    onPressAndHold: {
        sideDirectionPreview.visible = true
    }
    onPositionChanged: {
        sideDirectionPreview.endX = mouseX
        sideDirectionPreview.endY = mouseY
    }
    onReleased: {
        if (!sideDirectionPreview.visible) {
            // TODO suggest dragging
            return
        }

        sideDirectionPreview.visible = false
        // construct
        engine.Crossroad.AddSide(Sizes.laneWidth,
                                 Sizes.scaleViewToMap(sideDirectionPreview.startX - crossroadId.x),
                                 Sizes.scaleViewToMap(sideDirectionPreview.startY - crossroadId.y),
                                 sideDirectionPreview.getDirection(), 2, 1, 0, 0, 10)
    }

    Shape {
        id: sideDirectionPreview

        property alias startX: pathStart.startX
        property alias startY: pathStart.startY
        property alias endX: pathEnd.x
        property alias endY: pathEnd.y

        visible: false
        antialiasing: true
        vendorExtensionsEnabled: true

        function getDirection() {
            if (endX == startX)
                return endY > startY ? (Math.PI * 3 / 2) : (Math.PI / 2)

            var arctan = Math.atan(-(endY - startY)/(endX - startX))
            return (endX > startX) ? arctan : (arctan + Math.PI)
        }

        ShapePath {
            id: pathStart
            strokeColor: Colors.lane
            strokeWidth: 1

            PathLine {
                id: pathEnd
            }
        }
    }
}
