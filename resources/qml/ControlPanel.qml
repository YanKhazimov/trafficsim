import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: "#BBBBBB"

    readonly property bool crossroadConstructionMode: constructorPanel.visible
    signal crossroadValidated()

    function showConstructor() {
        constructorPanel.visible = true
        addButton.icon.source = "qrc:/images/hammer.svg"
        addButton.callback = construct
    }

    function construct() {
        engine.Crossroad.Validate()
        root.crossroadValidated()

        constructorPanel.visible = false
        addButton.icon.source = "qrc:/images/crossroad.svg"
        addButton.callback = showConstructor
    }

    Button {
        id: addButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        icon.source: "qrc:/images/crossroad.svg"
        property var callback: showConstructor
        onClicked: callback()
    }

    CrossroadConstructor {
        id: constructorPanel
        visible: false
        anchors.top: addButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
    }
}
