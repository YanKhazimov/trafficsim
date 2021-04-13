import QtQuick 2.15
import "Constants"

Rectangle {
    id: root
    color: mouseArea.containsPress ? "#EEEEEE" : mouseArea.containsMouse ? "#DDDDDD" : "#CCCCCC"
    implicitWidth: text === "" ? 30 : (buttonText.width + 2 * Sizes.minMargin)
    implicitHeight: 30
    radius: 10

    property alias img: image.source
    property alias text: buttonText.text
    property var callback
    property alias enabled: mouseArea.enabled

    Image {
        id: image
        anchors.fill: parent
        anchors.margins: 5
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        font.pointSize: 12
        color: root.enabled ? "black" : "#333333"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (root.callback !== undefined)
                root.callback()
        }
    }
}
