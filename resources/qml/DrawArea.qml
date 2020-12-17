import QtQuick 2.15
import QtQuick.Shapes 1.12
import "Constants"

MouseArea {
    id: root

    cursorShape: Qt.CrossCursor
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
        engine.Crossroad.AddSide(sideDirectionPreview.startX - crossroadId.x, sideDirectionPreview.startY - crossroadId.y,
                                 sideDirectionPreview.getDirection(), 2, 1, 100, 10, 10)
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
                return endY > startY ? 270 : 90

            var arctan = 180.0 / Math.PI * Math.atan(-(endY - startY)/(endX - startX))
            return (endX > startX) ? arctan : (arctan + 180)
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
