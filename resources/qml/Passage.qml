import QtQuick 2.15
import QtQuick.Shapes 1.12
import TrafficSimApp 1.0
import "Constants"

Shape {
    id: root
    property PassageModel model
    property alias startX: pathStart.startX
    property alias startY: pathStart.startY
    property alias endX: pathEnd.x
    property alias endY: pathEnd.y

    antialiasing: true
    vendorExtensionsEnabled: true

    ShapePath {
        id: pathStart
        strokeColor: "white"
        strokeWidth: root.model.IsHighlighted ? 3 : 1

//        PathLine {
//        }

//        PathAngleArc {
//        }

        PathLine {
            id: pathEnd
        }
    }
}
