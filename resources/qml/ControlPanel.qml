import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: "#BBBBBB"

    readonly property bool crossroadConstructionMode: constructorPanel.visible
    signal crossroadValidated()

    function showConstructor() {
        constructorPanel.visible = true
        addButton.img = "qrc:/images/done.svg"
        addButton.callback = construct
    }

    function construct() {
        engine.Crossroad.Validate()
        root.crossroadValidated()

        constructorPanel.visible = false
        addButton.img = "qrc:/images/crossroad.svg"
        addButton.callback = showConstructor
    }

    TSButton {
        id: addButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        width: 50
        height: 50
        img: "qrc:/images/crossroad.svg"
        callback: showConstructor
    }

    CrossroadConstructor {
        id: constructorPanel
        visible: false
        anchors.top: addButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
    }
}
