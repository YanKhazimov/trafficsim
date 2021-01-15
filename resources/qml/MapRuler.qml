import QtQuick 2.15
import "Constants"

Item {
    id: root
    property Item mapSource
    anchors.fill: mapSource

    Text {
        text: engine.ViewCenter.x - Math.round(Sizes.scaleViewToMap(mapSource.width / 2))
        anchors.bottom: parent.top; anchors.bottomMargin: 2 * Sizes.minMargin
        anchors.horizontalCenter: parent.left
        font.pointSize: 12
        color: "white"
    }
    Rectangle {
        width: 2
        height: Sizes.minMargin
        color: "black"
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.left
    }

    Text {
        text: engine.ViewCenter.x
        anchors.bottom: parent.top; anchors.bottomMargin: 2 * Sizes.minMargin
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
        color: "white"
    }
    Rectangle {
        width: 2
        height: Sizes.minMargin
        color: "black"
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        text: engine.ViewCenter.x + Math.round(Sizes.scaleViewToMap(mapSource.width / 2))
        anchors.bottom: parent.top; anchors.bottomMargin: 2 * Sizes.minMargin
        anchors.horizontalCenter: parent.right
        font.pointSize: 12
        color: "white"
    }
    Rectangle {
        width: 2
        height: Sizes.minMargin
        color: "black"
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.right
    }

    Text {
        text: engine.ViewCenter.y - Math.round(Sizes.scaleViewToMap(mapSource.height / 2))
        anchors.left: parent.right; anchors.leftMargin: 2 * Sizes.minMargin
        anchors.verticalCenter: parent.top
        font.pointSize: 12
        color: "white"
    }
    Rectangle {
        width: Sizes.minMargin
        height: 2
        color: "black"
        anchors.left: parent.right
        anchors.verticalCenter: parent.top
    }

    Text {
        text: engine.ViewCenter.y
        anchors.left: parent.right; anchors.leftMargin: 2 * Sizes.minMargin
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 12
        color: "white"
    }
    Rectangle {
        width: Sizes.minMargin
        height: 2
        color: "black"
        anchors.left: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: engine.ViewCenter.y + Math.round(Sizes.scaleViewToMap(mapSource.height / 2))
        anchors.left: parent.right; anchors.leftMargin: 2 * Sizes.minMargin
        anchors.verticalCenter: parent.bottom
        font.pointSize: 12
        color: "white"
    }
    Rectangle {
        width: Sizes.minMargin
        height: 2
        color: "black"
        anchors.left: parent.right
        anchors.verticalCenter: parent.bottom
    }

    Image {
        id: scaleImage
        source: "qrc:/images/magnifier.svg"
        anchors {
            verticalCenter: scaleText.verticalCenter
            left: parent.left; leftMargin: Sizes.minMargin
        }
        height: scaleText.contentHeight
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: scaleText
        anchors {
            bottom: parent.bottom; bottomMargin: Sizes.minMargin
            left: scaleImage.right; leftMargin: Sizes.minMargin
        }
        text: engine.ViewScale + "%"
        font.pointSize: 12
        color: "black"
    }
}
