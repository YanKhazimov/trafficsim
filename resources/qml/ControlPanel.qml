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
        addButton.img = "qrc:/images/edit.svg"
        addButton.callback = showConstructor
    }

    Row {
        id: buttonsRow
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 20

        TSButton {
            id: addButton
            width: 40
            height: 40
            img: "qrc:/images/edit.svg"
            callback: showConstructor
        }

        TSButton {
            id: saveButton
            width: 40
            height: 40
            img: "qrc:/images/save.svg"
            callback: function() {
                engine.SaveCrossroad()
            }
        }

        TSButton {
            id: openButton
            width: 40
            height: 40
            img: "qrc:/images/open.svg"
            callback: function() {
                engine.OpenCrossroad()
            }
        }
    }

    CrossroadConstructor {
        id: constructorPanel
        visible: false
        anchors.top: buttonsRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
    }
}
