import QtQuick 2.15
import QtQuick.Shapes 1.12
import abc 1.0

Item {
    id: root
    property CrossroadSideModel model
    property Item crossroadSideItem

    Shape {
        visible: root.model.IsHighlighted

        ShapePath {
            strokeColor: "#DDDDDD"
            fillColor: "transparent"
            strokeWidth: 2
            strokeStyle: ShapePath.DashLine
            startX: crossroadSideItem.start.x
            startY: crossroadSideItem.start.y

            PathLine {
                x: crossroadSideItem.end.x
                y: crossroadSideItem.end.y
            }

            PathLine {
                x: crossroadSideItem.end.x + 100 * Math.cos(root.model.NormalRadians)
                y: crossroadSideItem.end.y - 100 * Math.sin(root.model.NormalRadians)
            }

            PathLine {
                x: crossroadSideItem.start.x + 100 * Math.cos(root.model.NormalRadians)
                y: crossroadSideItem.start.y - 100 * Math.sin(root.model.NormalRadians)
            }

            PathLine {
                x: crossroadSideItem.start.x
                y: crossroadSideItem.start.y
            }
        }
    }

    Shape {
        visible: root.model.IsHighlightedX

        ShapePath {
            strokeColor: "#DDDDDD"
            strokeWidth: 2
            strokeStyle: ShapePath.DashLine
            startX: 0
            startY: -500

            PathLine {
                x: 0
                y: 500
            }
        }
    }

    Shape {
        visible: root.model.IsHighlightedY

        ShapePath {
            strokeColor: "#DDDDDD"
            strokeWidth: 2
            strokeStyle: ShapePath.DashLine
            startX: -500
            startY: 0

            PathLine {
                x: 500
                y: 0
            }
        }
    }

    Shape {
        visible: root.model.IsHighlightedR
        antialiasing: true

        ShapePath {
            strokeColor: "#DDDDDD"
            strokeWidth: 2
            strokeStyle: ShapePath.DashLine
            startX: 0
            startY: 0

            PathLine {
                x: 500 * Math.cos(root.model.NormalRadians)
                y: -500 * Math.sin(root.model.NormalRadians)
            }
        }

        ShapePath {
            strokeColor: "#DDDDDD"
            strokeWidth: 2
            strokeStyle: ShapePath.DashLine
            startX: 0
            startY: 0

            PathLine {
                x: 500
                y: 0
            }
        }

        ShapePath {
            strokeColor: "#DDDDDD"
            fillColor: "transparent"
            strokeWidth: 2
            strokeStyle: ShapePath.DashLine
            startX: 50
            startY: 0

            PathArc {
                x: 50 * Math.cos(root.model.NormalRadians)
                y: -50 * Math.sin(root.model.NormalRadians)
                radiusX: 50
                radiusY: 50
                direction: PathArc.Counterclockwise
                useLargeArc: root.model.NormalDegrees > 180
            }
        }
    }
}
