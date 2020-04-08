import QtQuick 2.0
import QtQuick.Controls 2.2
import "CustomControl"



Rectangle {
    id: root

    color: "transparent"

    property string map_name: ""
    property string work_time: ""
    property string title_color: "black"
    property string font_color: "lightgreen"

    signal sigBackBtnPress()
    signal sigStopBtnPress()
    signal sigEndingBtnPress()

    Connections {
        target: ros_message_manager
        onUpdateTaskProcessInfo: {
            text_progress.text = "" + progress + " %";

        }
    }

    Column{
        anchors.fill: parent
        Rectangle {
            id: rect_info
            width: parent.width
            height: parent.height * 0.4
            color: "transparent"
            TLInfoDisplayPage {
                id: tl_info_display
                anchors.fill: parent
            }
        }
        Rectangle {
            id: rect_btns
            width: parent.width
            height: parent.height * 0.1
            color: "transparent"
            Row {
                property real btn_spacing: parent.width * 0.03
                spacing: btn_spacing / 3
                height: parent.height
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    id: btn_back
                    source: "qrc:/res/pictures/back.png"
                    width: (parent.width -  parent.btn_spacing)/ 3
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.sigBackBtnPress()

                        }
                    }
                }
                Image {
                    id: btn_stop
                    width: (parent.width -  parent.btn_spacing)/ 3
                    height: parent.height
                    source: _is_pause ? "qrc:/res/pictures/task_stop.png" :
                                        "qrc:/res/pictures/task_start.png"
                    fillMode: Image.PreserveAspectFit
                    property bool _is_pause: false
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            map_task_manager.sendPauseTaskCommond(!btn_stop._is_pause)
                        }
                    }
                    Connections {
                        target: map_task_manager
                        onUpdatePauseTaskInfo: {
                            pause_stop_message.x = (parent.parent.parent.parent.width - width ) / 2
                            pause_stop_message.y =  (parent.parent.parent.parent.height - height ) / 2
                            y: (parent.parent.parent.parent.height - height ) / 2
                            if (status === 0 ) {
                                if (!btn_stop._is_pause) {
                                    pause_stop_message.dia_title = qsTr("Error")
                                    pause_stop_message.dia_content = qsTr("faild to start the task")
                                    pause_stop_message.status = 0
                                    pause_stop_message.open()
                                } else if (btn_stop._is_pause) {
                                    pause_stop_message.dia_title = qsTr("Error")
                                    pause_stop_message.dia_content = qsTr("faild to stop the task")
                                    pause_stop_message.status = 0
                                    pause_stop_message.open()
                                }
                            } else if (status === 1 ) {
//                                if (!btn_stop._is_pause) {
//                                    pause_stop_message.dia_title = qsTr("Success")
//                                    pause_stop_message.dia_content = qsTr("success to pause the task, if you want start the task, please click this btn again.")
//                                    pause_stop_message.status = 1
//                                    pause_stop_message.open()

//                                } else if (btn_stop._is_pause) {
//                                    pause_stop_message.dia_title = qsTr("Success")
//                                    pause_stop_message.dia_content = qsTr("success to start the task")
//                                    pause_stop_message.status = 1
//                                    pause_stop_message.open()
//                                }
                                btn_stop._is_pause = !is_pause
                            }
                        }
                    }
                }
                Image {
                    id: btn_ending
                    width:  (parent.width -  parent.btn_spacing)/ 3
                    height: parent.height
                    source: "qrc:/res/pictures/task_end.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            repeat_need_stop_task.x = (parent.parent.width - width ) / 2
                            repeat_need_stop_task.y = 0
                            repeat_need_stop_task.open()
                        }
                    }
                    Connections {
                        target: map_task_manager
                        onUpdateStopTaskInfo: {
                            repeat_need_stop_task.x = (parent.parent.parent.parent.width - width ) / 2
                            repeat_need_stop_task.y =  (parent.parent.parent.parent.height - height ) / 2
                            if (status === 0) {
                                pause_stop_message.dia_title = qsTr("Error")
                                pause_stop_message.dia_content = qsTr("faild to stop the task!")
                                pause_stop_message.status = 0
                                pause_stop_message.open()
                            } /*else if (status === 1) {
                                pause_stop_message.dia_title = qsTr("Success")
                                pause_stop_message.dia_content = qsTr("success to stop the task!")
                                pause_stop_message.status = 1
                                pause_stop_message.x = 400
                                pause_stop_message.open()
                            }*/
                        }
                    }
                }
            }
        }
        Rectangle {
            id: rect_logo_process
            width: parent.width
            height: parent.height * 0.5
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/background_glow1.png"
            }
            Rectangle {
                width: parent.width * 0.9
                height: parent.height * 0.88
                anchors.centerIn: parent
                color: "white"
//                color: Qt.rgba(255, 255, 255, 0.5)
                Column {
                    anchors.fill: parent
                    Rectangle {
                        id: rect_logo
                        width: parent.width
                        height: parent.height * 0.4
                        color: "transparent"
                        Image {
                            width: parent.width * 0.75
                            height: parent.height * 0.75
                            anchors.centerIn: parent
                            source: "qrc:/res/pictures/logo_2.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    Rectangle {
                        id: rect_task_progress
                        width: parent.width
                        height: parent.height * 0.6
                        color: "transparent"
                        Column {
                            anchors.fill: parent
                            anchors.leftMargin: parent.height * 0.05
                            Rectangle {
                                id: rect_map_name
                                width: parent.width
                                height: parent.height * 0.3
                                color: "transparent"
                                Text {
                                    id: text_1
                                    text: qsTr("Current map name: ")
                                    width: parent.width * 0.7
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                    font.pixelSize: width / 10
                                    color: root.title_color
                                }
                                Text {
                                    id: text_map_name
                                    text: root.map_name
                                    width: parent.width * 0.3
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: width / 10
                                    anchors.left: text_1.right
                                    color: root.font_color
                                }
                            }

                            Rectangle {
                                id: rect_work_time
                                width: parent.width
                                height: parent.height * 0.3
                                color: "transparent"
                                Text {
                                    id: text_2
                                    text: qsTr("Work time: ")
                                    width: parent.width * 0.7
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                    font.pixelSize: width / 10
                                    color: root.title_color
                                }
                                Text {
                                    id: text_work_time
                                    text: root.work_time
                                    width: parent.width * 0.3
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: width / 6
                                    anchors.left: text_2.right
                                    color: root.font_color
                                }

                            }

                            Rectangle {
                                id: rect_progress
                                width: parent.width
                                height: parent.height * 0.3
                                color: "transparent"
                                Text {
                                    id: text_3
                                    text: qsTr("task persent: ")
                                    width: parent.width * 0.7
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                    font.pixelSize: width / 10
                                    color: root.title_color
                                }
                                Text {
                                    id: text_progress
                                    text: "%"
                                    width: parent.width * 0.3
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: width / 6
                                    font.bold: true
                                    anchors.left: text_3.right
                                    color: root.font_color
                                }

                            }
                        }
                        ListModel {
                            id: list_model_process
                        }
                    }
                }
            }



        }
    }

    TLDialog {
        id: pause_stop_message
        cancel: true

    }

    TLDialog {
        id: repeat_need_stop_task
        cancel: true
        ok: true
        x: (parent.parent.parent.width - width ) / 2
        y: (parent.parent.parent.height - height ) / 2
        cancel_text: qsTr("cancel")
        ok_text: qsTr("sure")
        dia_title: qsTr("repeter")
        status: 1
        dia_content: qsTr("please comfirm if you need to stop task.")
        onOkClicked: {
            map_task_manager.sendStopTaskCommond()
            repeat_need_stop_task.close()
        }

    }
}
