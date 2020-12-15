import QtQuick 2.0
import QtQuick.Shapes 1.12
import "Constants"

Shape {
    id: root
    property point start
    property int length: 100
    property real angle: Math.PI / 2
    property color color: Colors.lane
    property int w: Sizes.laneWidth
    property bool markup: true
    //antialiasing: true

    vendorExtensionsEnabled: true

    ShapePath {
        id: markupWide
        strokeColor: root.markup ? Colors.markup : root.color
        strokeWidth: root.w
        startX: start.x + strokeWidth/2 * Math.cos(angle)
        startY: start.y - strokeWidth/2 * Math.sin(angle)

        PathLine {
            x: start.x + (length - markupWide.strokeWidth/2) * Math.cos(angle)
            y: start.y - (length - markupWide.strokeWidth/2) * Math.sin(angle)
        }
    }

    ShapePath {
        id: markupExcluded
        strokeColor: root.color
        strokeWidth: root.markup ? root.w - 2 : 0
        startX: start.x + (strokeWidth/2) * Math.cos(angle)
        startY: start.y - (strokeWidth/2) * Math.sin(angle)

        PathLine {
            x: start.x + (length - markupExcluded.strokeWidth/2) * Math.cos(angle)
            y: start.y - (length - markupExcluded.strokeWidth/2) * Math.sin(angle)
        }
    }
}
