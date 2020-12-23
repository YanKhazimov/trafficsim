import QtQuick 2.15

Rectangle {
    id: root
    color: mouseArea.containsMouse ? "#DDDDDD" : "#CCCCCC"
    implicitWidth: 30
    implicitHeight: 30
    radius: 10

    property alias img: image.source
    property var callback

    Image {
        id: image
        anchors.fill: parent
        anchors.margins: 5
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (root.callback !== undefined)
                root.callback()
        }
    }
}
