import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../homemade_components"

Item {
    id: root
    width: parent.width
    height: parent.height

    signal sigBackBtnPress()
    property var btn_stop_pressed: ""

    onBtn_stop_pressedChanged: {
        if (btn_stop_pressed === "Manual") {
            map_task_manager.setPauseTaskCommond(true)
            pop_lock.open()
            dialog_stop_task_tip.open()
        } else if (btn_stop_pressed === "Auto") {
            map_task_manager.setPauseTaskCommond(true)
            pop_lock.open()
            task_auto_achived.open()
        } else if (btn_stop_pressed === "Exit") {
            map_task_manager.setPauseTaskCommond(false)
            pop_lock.close()
        } else {

        }
    }

    Connections {
        target: status_manager
        onWorkStatusUpdate: {
           if (status < status_manager.getWorkingID()) {
               root.btn_stop_pressed = "Exit"
           }
        }
    }

    Popup {         //弹出窗口显示在项目上方
        id: pop_lock
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        dim: false
        closePolicy: Popup.CloseOnPressOutsideParent    //父对象之外按下关闭
        background: Rectangle {
            anchors.fill: parent
            opacity: 0.3
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient
                {
                    GradientStop{position: 0.3; color:"grey"}
                    GradientStop{position: 1; color:"black"}
                }
            }
        }
        contentItem: Item {
            anchors.fill: parent
            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"
                TLDialog {
                    id: dialog_stop_task_tip
                    height: parent.height * 0.5
                    width: height * 1.5
                    x: (root.width - width) / 2
                    y: (root.height - height) / 2
                    dia_title: qsTr("Repeat")
                    dia_content: qsTr("Whether to stop the task?")
                    status: 1
                    ok: true
                    cancel_text: qsTr("cancel")
                    ok_text: qsTr("yes")
                    closePolicy: Popup.NoAutoClose
                    onCancelClicked: {
                        root.btn_stop_pressed = "Exit"
                    }
                    onOkClicked: {
                        dialog_stop_task_tip.close()
                        task_auto_achived.open()
                    }
                }
                Dialog {
                    id: task_auto_achived
                    height: parent.height * 0.7
                    width: height * 1.5
                    dim: false
                    closePolicy: Popup.NoAutoClose
                    x: (root.width - width) / 2
                    y: (root.height - height) / 2
                    background: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                    }
                    contentItem: Item {
                        anchors.fill: parent
                        Rectangle {
                            color: "transparent"
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                            radius: 10
                            Rectangle {
                                id: rect_task_achived_title
                                width: parent.width
                                height: parent.height * 0.2
                                color: "transparent"
                                Text {
                                    color: "#4876FF"
                                    text: qsTr("Task achieved")
                                    font.pixelSize: parent.height * 0.6
                                    font.bold: true
                                    anchors.centerIn: parent
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
                                    height: parent.height * 0.8
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
                                            height: list_return_type.height * 0.3
                                            width: parent.width
                                            property real id_num: model.id_num
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            Rectangle {
                                                anchors.fill: parent
                                                anchors.centerIn: parent
                                                color: list_return_type.currentIndex === parent.id_num ?
                                                           Qt.rgba(0, 255, 0, 0.3) : "transparent"
                                                opacity: list_return_type.currentIndex == item.id_num ? 1 : 0.5
                                                radius: width / 2
                                                Text {
                                                    id: attr_return_option
                                                    clip: true
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: parent.height
                                                    text: model.btn_text
                                                    width: parent.width * 0.8
                                                    height: parent.height * 0.6
                                                    font.bold: false
                                                    font.pixelSize: list_return_type.currentIndex === item.id_num ?
                                                                        height * 0.8 : height * 0.6
                                                    verticalAlignment: Text.AlignVCenter
                                                    horizontalAlignment: Text.AlignLeft
                                                }
                                                Image {
                                                    height: parent.height * 0.5
                                                    width: height
                                                    opacity: 0.5
                                                    source: "qrc:/res/pictures/arrow-right.png"
                                                    anchors.left: parent.left
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
                                                btn_text: qsTr("Continue to pe  rform tasks on this map")
                                            }
                                            ListElement {
                                                id_num: 1
                                                btn_text: qsTr("Switch map")
                                            }
                                            ListElement {
                                                id_num: 2
                                                btn_text: qsTr("Back HomePage")
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
                                        id: btn_task_accdhived_sure
                                        width: parent.width * 0.5
                                        height: parent.height * 0.8
                                        anchors.centerIn: parent
                                        btn_text: qsTr("OK")
                                        onClicked: {
                                            if (list_return_type.currentIndex === 0) {
                                                map_task_manager.turnToSelectTask()
                                            } else if (list_return_type.currentIndex === 1) {
                                                map_task_manager.turnToSelectMap()
                                            } else if (list_return_type.currentIndex === 2) {
                                                map_task_manager.turnToSelectMap()
                                                root.sigBackBtnPress()
                                            }
                                            root.btn_stop_pressed = "Exit"
                                            list_return_type.currentIndex = 0
                                            task_auto_achived.close()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
