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

                Behavior on height {
                    PropertyAnimation {
                        id: heightAnimation
                    }
                }

                Text {
                    id: infoText
                    visible: !delegateMouseArea.inEditMode
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: 5
                    text: "Side #%1 (%4\u00B0, %2 IN : %3 OUT)".arg(index + 1).arg(RoleSideData.InLanesCount).arg(RoleSideData.OutLanesCount).arg(RoleSideData.NormalDegrees)
                    color: "white"
                }

                Binding {
                    target: RoleSideData
                    property: "IsHighlighted"
                    value: delegateMouseArea.containsMouse
                }

                TSButton {
                    id: editButton

                    anchors {
                        right: parent.right; rightMargin: 10
                        top: parent.top; topMargin: -10
                    }

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

                    img: "qrc:/images/remove.svg"
                    callback: function() {
                        engine.Crossroad.RemoveSide(index)
                    }
                }

                ColumnLayout {
                    id: editorLayout
                    visible: delegateMouseArea.inEditMode && !heightAnimation.running
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: editButton.bottom
                    anchors.margins: 5

                    MouseArea {
                        id: rowMouseAreaX
                        hoverEnabled: true
                        Layout.fillWidth: true
                        height: childrenRect.height

                        Binding {
                            target: RoleSideData
                            property: "IsHighlightedX"
                            value: rowMouseAreaX.containsMouse
                        }

                        RowLayout {
                            spacing: 10
                            width: parent.width

                            TSButton {
                                img: "qrc:/images/minus.svg"
                                callback: function() { RoleSideData.StartX = RoleSideData.StartX - 1 }
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "x: " + RoleSideData.StartX
                                font.pointSize: 14
                            }
                            TSButton {
                                img: "qrc:/images/plus.svg"
                                callback: function() { RoleSideData.StartX = RoleSideData.StartX + 1 }
                            }
                        }
                    }

                    MouseArea {
                        id: rowMouseAreaY
                        hoverEnabled: true
                        Layout.fillWidth: true
                        height: childrenRect.height

                        Binding {
                            target: RoleSideData
                            property: "IsHighlightedY"
                            value: rowMouseAreaY.containsMouse
                        }

                        RowLayout {
                            spacing: 10
                            width: parent.width

                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/minus.svg"
                                callback: function() { RoleSideData.StartY = RoleSideData.StartY - 1 }
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "y: " + RoleSideData.StartY
                                font.pointSize: 14
                            }
                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/plus.svg"
                                callback: function() { RoleSideData.StartY = RoleSideData.StartY + 1 }
                            }
                        }
                    }

                    MouseArea {
                        id: rowMouseAreaR
                        hoverEnabled: true
                        Layout.fillWidth: true
                        height: childrenRect.height

                        Binding {
                            target: RoleSideData
                            property: "IsHighlightedR"
                            value: rowMouseAreaR.containsMouse
                        }

                        RowLayout {
                            spacing: 10
                            width: parent.width

                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/minus.svg"
                                callback: function() { RoleSideData.NormalDegrees = RoleSideData.NormalDegrees - 1 }
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "angle: " + RoleSideData.NormalDegrees + "\u00B0"
                                font.pointSize: 14
                            }
                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/plus.svg"
                                callback: function() { RoleSideData.NormalDegrees = RoleSideData.NormalDegrees + 1 }
                            }
                        }
                    }

                    MouseArea {
                        hoverEnabled: true
                        Layout.fillWidth: true
                        height: childrenRect.height

                        RowLayout {
                            spacing: 10
                            width: parent.width

                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/minus.svg"
                                callback: function() { RoleSideData.RemoveInLane() }
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "in lanes: " + RoleSideData.InLanesCount
                                font.pointSize: 14
                            }
                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/plus.svg"
                                callback: function() { RoleSideData.AddInLane() }
                            }
                        }
                    }

                    MouseArea {
                        hoverEnabled: true
                        Layout.fillWidth: true
                        height: childrenRect.height

                        RowLayout {
                            spacing: 10
                            width: parent.width

                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/minus.svg"
                                callback: function() { RoleSideData.RemoveOutLane() }
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "out lanes: " + RoleSideData.OutLanesCount
                                font.pointSize: 14
                            }
                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/plus.svg"
                                callback: function() { RoleSideData.AddOutLane() }
                            }
                        }
                    }

                    MouseArea {
                        hoverEnabled: true
                        Layout.fillWidth: true
                        height: childrenRect.height

                        RowLayout {
                            spacing: 10
                            width: parent.width

                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/minus.svg"
                                callback: function() { RoleSideData.InOffset = RoleSideData.InOffset - 1 }
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "in margin: " + RoleSideData.InOffset
                                font.pointSize: 14
                            }
                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/plus.svg"
                                callback: function() { RoleSideData.InOffset = RoleSideData.InOffset + 1 }
                            }
                        }
                    }

                    MouseArea {
                        hoverEnabled: true
                        Layout.fillWidth: true
                        height: childrenRect.height

                        RowLayout {
                            spacing: 10
                            width: parent.width

                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/minus.svg"
                                callback: function() { RoleSideData.OutOffset = RoleSideData.OutOffset - 1 }
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "out margin: " + RoleSideData.OutOffset
                                font.pointSize: 14
                            }
                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/plus.svg"
                                callback: function() { RoleSideData.OutOffset = RoleSideData.OutOffset + 1 }
                            }
                        }
                    }

                    MouseArea {
                        hoverEnabled: true
                        Layout.fillWidth: true
                        height: childrenRect.height

                        RowLayout {
                            spacing: 10
                            width: parent.width

                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/minus.svg"
                                callback: function() { RoleSideData.MidOffset = RoleSideData.MidOffset - 1 }
                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "mid margin: " + RoleSideData.MidOffset
                                font.pointSize: 14
                            }
                            TSButton {
                                Layout.maximumWidth: height
                                img: "qrc:/images/plus.svg"
                                callback: function() { RoleSideData.MidOffset = RoleSideData.MidOffset + 1 }
                            }
                        }
                    }
                }
            }
        }
    }
}
