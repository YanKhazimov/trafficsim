import QtQuick 2.0
import QtQuick.Shapes 1.12
import "Constants"

Shape {
    id: root
    property point start
    property int length: 100
    vendorExtensionsEnabled: true

    ShapePath {
        id: markupWide
        strokeColor: Colors.markup
        strokeWidth: Sizes.laneWidth
        startX: start.x
        startY: start.y - strokeWidth/2

        PathLine {
            x: markupWide.startX
            y: start.y - root.length + markupWide.strokeWidth/2
        }
    }

    ShapePath {
        id: markupExcluded
        strokeColor: Colors.lane
        strokeWidth: Sizes.laneWidth - 2
        startX: start.x
        startY: start.y - strokeWidth/2

        PathLine {
            x: markupExcluded.startX
            y: start.y - root.length + markupExcluded.strokeWidth/2
        }
    }
}
