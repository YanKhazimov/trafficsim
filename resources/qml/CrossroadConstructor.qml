import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

ScrollView {
    id: root
    implicitHeight: 500
    contentWidth: availableWidth

    ListView {
        model: engine.Crossroad.Sides
        spacing: 15
        delegate: MouseArea {
            id: delegateMouseArea
            width: parent.width
            height: sideInfo.height
            hoverEnabled: true

            property bool inEditMode: false

            Rectangle {
                id: sideInfo
                width: parent.width
                height: delegateMouseArea.inEditMode ? (5 + editorLayout.y + editorLayout.height) : (5 + infoText.y + infoText.height)
                radius: 10
                color: parent.containsMouse ? "#DDDDDD" : "grey"

                Text {
                    id: infoText
                    visible: !delegateMouseArea.inEditMode
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: 5
                    text: "Side #%1 (%2 IN : %3 OUT)".arg(index + 1).arg(modelData.InLanesCount).arg(modelData.OutLanesCount)
                    color: "white"
                }

                Binding {
                    target: modelData
                    property: "IsHighlighted"
                    value: delegateMouseArea.containsMouse
                }

                TSButton {
                    id: editButton

                    anchors {
                        right: parent.right; rightMargin: 10
                        top: parent.top; topMargin: -10
                    }

                    width: height
                    img: delegateMouseArea.inEditMode ? "qrc:/images/done.svg" : "qrc:/images/edit.svg"
                    callback: function() {
                        delegateMouseArea.inEditMode = !delegateMouseArea.inEditMode
                    }
                }

                TSButton {
                    anchors {
                        right: editButton.left; rightMargin: 10
                        top: parent.top; topMargin: -10
                    }

                    width: height
                    img: "qrc:/images/remove.svg"
                    callback: function() {
                        engine.Crossroad.RemoveSide(index)
                    }
                }

                ColumnLayout {
                    id: editorLayout
                    visible: delegateMouseArea.inEditMode
                    anchors.left: parent.left
                    anchors.top: editButton.bottom
                    anchors.margins: 5
                    anchors.right: parent.right

                    RowLayout {
                        spacing: 10
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/minus.svg"
                            callback: function() { modelData.StartX = modelData.StartX - 1 }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "x: " + modelData.StartX
                            font.pointSize: 14
                        }
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/plus.svg"
                            callback: function() { modelData.StartX = modelData.StartX + 1 }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/minus.svg"
                            callback: function() { modelData.StartY = modelData.StartY - 1 }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "y: " + modelData.StartY
                            font.pointSize: 14
                        }
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/plus.svg"
                            callback: function() { modelData.StartY = modelData.StartY + 1 }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/minus.svg"
                            callback: function() { modelData.NormalDegrees = modelData.NormalDegrees - 1 }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "angle: " + modelData.NormalDegrees + "\u00B0"
                            font.pointSize: 14
                        }
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/plus.svg"
                            callback: function() { modelData.NormalDegrees = modelData.NormalDegrees + 1 }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/minus.svg"
                            callback: function() { modelData.RemoveInLane() }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "in lanes: " + modelData.InLanesCount
                            font.pointSize: 14
                        }
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/plus.svg"
                            callback: function() { modelData.AddInLane() }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/minus.svg"
                            callback: function() { modelData.RemoveOutLane() }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "out lanes: " + modelData.OutLanesCount
                            font.pointSize: 14
                        }
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/plus.svg"
                            callback: function() { modelData.AddOutLane() }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/minus.svg"
                            callback: function() { modelData.InOffset = modelData.InOffset - 1 }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "in margin: " + modelData.InOffset
                            font.pointSize: 14
                        }
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/plus.svg"
                            callback: function() { modelData.InOffset = modelData.InOffset + 1 }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/minus.svg"
                            callback: function() { modelData.OutOffset = modelData.OutOffset - 1 }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "out margin: " + modelData.OutOffset
                            font.pointSize: 14
                        }
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/plus.svg"
                            callback: function() { modelData.OutOffset = modelData.OutOffset + 1 }
                        }
                    }

                    RowLayout {
                        spacing: 10
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/minus.svg"
                            callback: function() { modelData.MidOffset = modelData.MidOffset - 1 }
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "mid margin: " + modelData.MidOffset
                            font.pointSize: 14
                        }
                        TSButton {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            img: "qrc:/images/plus.svg"
                            callback: function() { modelData.MidOffset = modelData.MidOffset + 1 }
                        }
                    }
                }
            }
        }
    }
}
