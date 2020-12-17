import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: "#BBBBBB"

    property var callback: showConstructor

    function showConstructor() {
        sidesColumn.visible = true
        addButton.text = "construct"
        root.callback = construct
    }

    function construct() {
        sidesColumn.visible = false
        addButton.text = "new crossroad"
        root.callback = showConstructor
    }

    Button {
        id: addButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        text: "new crossroad"
        onClicked: root.callback()
    }

    CrossroadConstructor {
        id: sidesColumn
        visible: false
        anchors.top: addButton.bottom
    }
}
