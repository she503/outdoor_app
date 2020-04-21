import QtQuick 2.0
import QtQuick.Controls 2.2
import "CustomControl"



Rectangle {
    id: root

    color: "transparent"

    property string map_name: ""
    property string work_time: ""
    property string title_color: "black"
    property string font_color: "blue"

    signal sigBackBtnPress()
    signal stopTaskCommond()

    Connections {
        target: ros_message_manager
        onUpdateTaskProcessInfo: {
            text_progress.text = "" + progress + " %";
            if (progress == 100) {
                task_auto_achived.open()
            }
        }
    }
    // test progress == 100
//    Timer {
//        interval: 5000
//        running: true
//        repeat: true
//        onTriggered: {
//            text_progress.text = "" + "100" + " %";
//            task_auto_achived.open()
//        }
//    }

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
                    source: "qrc:/res/pictures/BUTTON-HOME.png"
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
                    source: _is_pause ? "qrc:/res/pictures/BUTTON-START.png" :
                                        "qrc:/res/pictures/BUTTON-PAUSE.png"
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
                    source: "qrc:/res/pictures/BUTTON-STOP.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //                            repeat_need_stop_task.x = (parent.parent.width - width ) / 2
                            //                            repeat_need_stop_task.y = 0
                            repeat_need_stop_task.open()
                        }
                    }
                    Connections {
                        target: map_task_manager
                        onUpdateStopTaskInfo: {
                            //                            repeat_need_stop_task.x = (parent.parent.parent.parent.width - width ) / 2
                            //                            repeat_need_stop_task.y =  (parent.parent.parent.parent.height - height ) / 2
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
                color: Qt.rgba(255, 255, 255, 0.5)
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
                                    width: parent.width * 0.5
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                    font.pixelSize: width / 7.5
                                    color: root.title_color
                                }
                                Text {
                                    id: text_map_name
                                    text: root.map_name
                                    width: parent.width * 0.5
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: width / 8
                                    anchors.left: text_1.right
                                    color: root.font_color
                                    font.bold: true
                                }
                                Rectangle {
                                    width: parent.width * 0.97
                                    height: 0.5
                                    anchors.bottom: parent.bottom
                                    color: Qt.rgba(0, 0, 0, 0.1)
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
                                    width: parent.width * 0.5
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                    font.pixelSize: width / 7.5
                                    color: root.title_color
                                }
                                Text {
                                    id: text_work_time
                                    text: root.work_time
                                    width: parent.width * 0.5
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: width / 8
                                    anchors.left: text_2.right
                                    color: root.font_color
                                    font.bold: true
                                }
                                Rectangle {
                                    width: parent.width * 0.97
                                    height: 0.5
                                    anchors.bottom: parent.bottom
                                    color: Qt.rgba(0, 0, 0, 0.1)
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
                                Rectangle {
                                    width: parent.width * 0.97
                                    height: 0.5
                                    anchors.bottom: parent.bottom
                                    color: Qt.rgba(0, 0, 0, 0.1)
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
        height: parent.height * 0.5
        width: height * 1.5
        cancel: true

    }

    TLDialog {
        id: repeat_need_stop_task
        cancel: true
        ok: true
        height: 280
        width: 420
        x: (root_main.width - width ) / 2
        y: (root_main.height - height ) / 2
        cancel_text: qsTr("cancel")
        ok_text: qsTr("sure")
        dia_title: qsTr("repeter")
        status: 1
        dia_content: qsTr("please comfirm if you need to stop task.")
        onOkClicked: {
            map_task_manager.sendStopTaskCommond()
            repeat_need_stop_task.close()
            stopTaskCommond()
            btn_stop._is_pause = false
        }

    }

    Dialog {
        id: task_auto_achived
        height: 280
        width: 420
        x:(root_main.width - width) / 2
        y: (root_main.height - height) / 2
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
                                        map_task_manager.returnMapSelete()
                                    } else if (list_return_type.currentIndex === 1) {

                                    }
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
}
