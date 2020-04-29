import QtQuick 2.0
import QtQuick.Controls 2.2

Dialog {
    id: task_auto_achived
    height: 280
    width: 420

    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
    }
    contentItem: Item {
        anchors.fill: parent
        Rectangle {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/background_glow2.png"
            }
            Rectangle {
                color: Qt.rgba(255, 255, 255, 1)
                anchors.centerIn: parent
                width: parent.width * 0.8
                height: parent.height * 0.75
                Rectangle {
                    id: rect_task_achived_title
                    width: parent.width
                    height: parent.height * 0.3
                    color: "transparent"
                    Text {
                        color: "#4876FF"
                        text: qsTr("Task achieved")
                        font.pixelSize: parent.height * 0.4
                        font.bold: true
                        anchors.centerIn: parent
                    }
                    Image {
                        height: parent.height * 0.4
                        width: height
                        anchors {
                            right: parent.right
                            top:parent.top
                            rightMargin: parent.height * 0.1
                            topMargin: parent.height * 0.1
                        }
                        source: "qrc:/res/pictures/exit.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                task_auto_achived.close()
                            }
                        }
                    }
                }
                Rectangle {
                    id: rect_task_options
                    width: parent.width
                    height: parent.height * 0.8
                    color: "transparent"
                    anchors {
                        top: rect_task_achived_title.bottom
                    }
                    Rectangle {
                        id: select_return_type_list
                        width: parent.width * 0.85
                        height: parent.height * 0.6
                        color: "transparent"
                        anchors.horizontalCenter: parent.horizontalCenter
                        ListView {
                            id: list_return_type
                            anchors.fill: parent
                            spacing: height * 0.03
                            currentIndex: 0
                            highlight: Rectangle {color: "transparent"}
                            clip: true
                            highlightFollowsCurrentItem: false
                            delegate: ItemDelegate {
                                id: item
                                height: list_return_type.height * 0.45
                                width: parent.width
                                property real id_num: model.id_num
                                anchors.horizontalCenter: parent.horizontalCenter
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.centerIn: parent
                                    color: list_return_type.currentIndex === parent.id_num ?
                                                      Qt.rgba(0, 255, 0, 0.1) : "transparent"
                                    opacity: list_return_type.currentIndex == item.id_num ? 1 : 0.3
                                    radius: width / 2
                                    Text {
                                        id: attr_return_option
                                        clip: true
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: parent.height * 0.3
                                        text: model.btn_text
                                        width: parent.width * 0.8
                                        height: parent.height * 0.6
                                        font.bold: false
                                        font.pixelSize: list_return_type.currentIndex === item.id_num ?
                                                          height * 0.8 :height * 0.6
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignLeft
                                    }
                                    Image {
                                        height: parent.height * 0.5
                                        width: height
                                        opacity: 0.1
                                        source: "qrc:/res/pictures/arrow-right.png"
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        verticalAlignment: Image.AlignVCenter
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Rectangle {
                                        width: parent.width * 0.75
                                        height: 0.5
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: Qt.rgba(0, 0, 0, 0.1)
                                    }
                                }
                                onClicked: {
                                    list_return_type.currentIndex = index
                                }
                            }
                            model: ListModel {
                                id: list_model_attr
                                ListElement {
                                    id_num: 0
                                    btn_text: qsTr("Continue to perform tasks on this map")
                                }
                                ListElement {
                                    id_num: 1
                                    btn_text: qsTr("Switch map")
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: rect_update_btns
                        width: parent.width * 0.6
                        height: parent.height * 0.2
                        color: "transparent"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: select_return_type_list.bottom
                        TLButton {
                            id: btn_task_achived_sure
                            width: parent.width * 0.5
                            height: parent.height * 0.8
                            anchors {
                                verticalCenter: parent.verticalCenter
                                right: parent.horizontalCenter
                                rightMargin: height * 0.4
                            }

                            btn_text: qsTr("OK")
                            onClicked: {
                                if (list_return_type.currentIndex === 0) {
                                    map_task_manager.turnToSelectTask()
                                } else if (list_return_type.currentIndex === 1) {
                                    map_task_manager.turnToSelectMap()
                                }
                                list_return_type.currentIndex = 0
                                task_auto_achived.close()
                            }
                        }
                        TLButton {
                            id: btn_task_achived_cancle
                            width: parent.width * 0.5
                            height: parent.height * 0.8
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.horizontalCenter
                                leftMargin: height * 0.4
                            }
                            btn_text: qsTr("cancel")
                            onClicked: {
                                task_auto_achived.close()
                                list_return_type.currentIndex = 0
                            }
                        }
                    }
                }
            }
        }
    }
}
