import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "./homemade_components"
Item {
    id: root

    signal lockScreen()
    signal cannotOperatorTask()
    property bool is_locked: false
    property bool has_error: false
    property var error_text_color: "red"//: ["yellow", "orange", "red"]
    property bool is_first_get_error: false

    function showMessagePics(flag) {
        if (flag) {
            btn_error.anchors.right = btn_lock.left
            btn_error.anchors.rightMargin = root.width * 0.05
            btn_error.anchors.verticalCenter = root.verticalCenter
            message_pic.visible = true
        } else {
            btn_error.anchors.horizontalCenter = root.horizontalCenter
            btn_error.anchors.verticalCenter = root.verticalCenter
            message_pic.visible = false
        }
    }

    Row {
        id: message_pic
        visible: true
        anchors.fill: parent

        TLBtnWithPic {
            id: lab_battery
            width: parent.width * 0.15
            height: parent.height
            backgroundDefaultColor: "transparent"
            img_source: "qrc:/res/ui/mission_bord/battery_pic.png"
            btn_text: "100 %"
            font_size: height * 0.3

            Connections{
                target: ros_message_manager
                onUpdateBatteryInfo: {
                    lab_battery.btn_text = soc + " %"
                }
            }
        }

        TLBtnWithPic {
            id: lab_speed
            width: parent.width * 0.15
            height: parent.height
            backgroundDefaultColor: "transparent"
            img_source: "qrc:/res/ui/mission_bord/speed_pic.png"
            btn_text: "1 m/s"
            font_size: height * 0.3
        }

        TLBtnWithPic {
            id: lab_progress
            width: parent.width * 0.15
            height: parent.height
            backgroundDefaultColor: "transparent"
            img_source: "qrc:/res/ui/mission_bord/task_progress.png"
            font_size: height * 0.3
            btn_text: "99 %"
            Connections {
                target: ros_message_manager
                onUpdateTaskProcessInfo: {
                    lab_progress.btn_text = "" + progress + " %";
                }
            }
        }


        Image {
            id: lab_gear
            width: parent.width * 0.1
            height: parent.height * 0.8
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/res/ui/mission_bord/gear_N_pic.png"
            Connections {
                target: ros_message_manager
                onUpdateChassisInfo: {
                    var v_speed = speed
                    var n_speed = Number(v_speed)

                    if (drive_mode === 0) {
                        lab_operate.source = "qrc:/res/ui/mission_bord/operate_hand_pic.png"
                    } else if (drive_mode === 1) {
                        lab_operate.source = "qrc:/res/ui/mission_bord/operate_auto_pic.png"
                    }

                    if(Math.abs(n_speed) <= 0.05) {
                        lab_gear.source = "qrc:/res/ui/mission_bord/gear_N_pic.png"
                    } else if(n_speed > 0.05) {
                        lab_gear.source = "qrc:/res/ui/mission_bord/gear_D_pic.png"
                    } else if (n_speed < -0.05) {
                        lab_gear.source = "qrc:/res/ui/mission_bord/gear_R_pic.png"
                    }
                    lab_speed.btn_text = v_speed + " m/s"
                }
            }
        }

        Image {
            id: lab_operate
            width: parent.width * 0.15
            height: parent.height
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/res/ui/mission_bord/operate_auto_pic.png"
        }
    }

    Connections {
        target: ros_message_manager
        onUpdateMonitorMessageInfo: {
            message_list_model.clear()
            root.has_error = true
            if (!is_first_get_error) {
                timer_btn_errror_flashes.start()
                root.is_first_get_error = true
                draw_error.open()
                timer_no_error_close.running = true

                //                timer_btn_errror_open.start()   debug
                //                root.cannotOperatorTask ()      debug
            }
            for(var i = 0; i < monitor_message.length; ++i) {
                message_list_model.append({"error_time" : monitor_message[i][0],
                                              "error_level" : monitor_message[i][1],
                                              "error_code" : monitor_message[i][2],
                                              "error_message" : monitor_message[i][3]})
            }
        }
    }

    Button {
        id: btn_lock
        visible: !is_locked
        height: parent.height * 0.6
        width: height
        anchors{
            right: parent.right
            rightMargin: parent.width * 0.05
            verticalCenter: parent.verticalCenter
        }
        background: Rectangle {
            height: parent.height * 2.27
            width: height
            color: "transparent"
            anchors.centerIn: parent
            radius: width / 2
            Image {
                height: parent.height * 0.6
                width: height
                anchors.centerIn: parent
                source: "qrc:/res/ui/mission_bord/lock.png"
                fillMode: Image.PreserveAspectFit
            }
        }
        onClicked: {
            root.lockScreen()
        }
    }

    Button {
        id: btn_error
        visible: has_error
        height: parent.height * 0.7
        width: height
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle {
            height: parent.height * 1.36
            width: height
            color: "transparent"
            anchors.centerIn: parent
            radius: width / 2
            Image {
                anchors.fill: parent
                source: "qrc:/res/ui/mission_bord/warn.png"
                fillMode: Image.PreserveAspectFit
            }
        }
        onClicked: {
            message_list_model.clear()
            if(draw_error.visible){
                draw_error.close()
            }else{
                draw_error.open()
            }
        }
    }


    Drawer {
        id: draw_error
        visible: false
        width: parent.width
        height: parent.height
        modal: true
        dim: false
        edge: Qt.RightEdge
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle{
            opacity: 0.6
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient
                {
                    GradientStop{position: 0.3; color:"grey"}
                    GradientStop{position: 1; color:"black"}
                }
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                draw_error.close()
            }
        }
        Rectangle {
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/background_glow1.png"
            }
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.6
            x: (parent.width - width ) / 2
            y: (parent.height - height) / 2
            color: "transparent"
            Rectangle {
                width: parent.width * 0.9
                height: parent.height * 0.88
                anchors.centerIn: parent
                color: "transparent"
                Rectangle {
                    id: rec_message_head
                    width: parent.width
                    height: parent.height * 0.1
                    color: "transparent"
                    border.width: 1
                    border.color: Qt.rgba(100, 100, 200, 0.6)

                    Rectangle {
                        width: parent.width
                        height: parent.height //* 0.5
                        anchors.bottom: parent.bottom
                        color: "transparent"
                        Text {
                            id: title_time
                            text: qsTr("error time")
                            width: parent.width * 0.2
                            height: parent.height
                            anchors.left: parent.left
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: parent.height * 0.5
                            font.bold: true
                            color: "black"
                            property int sort_type: 0
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (title_time.sort_type === 0) {
                                        title_time.sort_type = 1
                                    } else if(title_time.sort_type === 1) {
                                        title_time.sort_type = 0
                                    }
                                    ros_message_manager.setSort(0, title_time.sort_type)
                                }
                            }
                        }
                        Text {
                            id: title_code
                            text: qsTr("error code")
                            width: parent.width * 0.2
                            height: parent.height
                            anchors.left: title_time.right
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: parent.height * 0.5
                            font.bold: true
                            color: "black"

                        }
                        Text {
                            id: title_level
                            text: qsTr("error level")
                            width: parent.width * 0.2
                            height: parent.height
                            anchors.left: title_code.right
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: parent.height * 0.5
                            font.bold: true
                            color: "black"
                            property int sort_type: 0
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (title_level.sort_type === 0) {
                                        title_level.sort_type = 1
                                    } else if(title_level.sort_type === 1) {
                                        title_level.sort_type = 0
                                    }
                                    ros_message_manager.setSort(1, title_level.sort_type)
                                }
                            }
                        }
                        Text {
                            id: title_message
                            text: qsTr("error message")
                            width: parent.width * 0.4
                            height: parent.height
                            anchors.left: title_level.right
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: parent.height * 0.5
                            font.bold: true
                            color: "black"
                        }
                    }
                }
                Rectangle {
                    id: rec_message_info
                    width: parent.width
                    height: parent.height * 0.9
                    anchors.top: rec_message_head.bottom
                    border.width: 1
                    border.color: Qt.rgba(100, 100, 100, 0.6)
                    color: "transparent"
                    ListView {
                        id: list_error_message
                        clip: true
                        width: parent.width
                        height: parent.height
                        orientation:ListView.Vertical
                        spacing: height * 0.02
                        delegate: ItemDelegate {
                            id: item_message
                            width: parent.width
                            height: ListView.height
                            property bool is_active: false
                            background: Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                            }
                            Row {
                                anchors.fill: parent
                                Rectangle {
                                    width: item_message.width * 0.2
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        id: text_error_time
                                        clip: true
                                        anchors.fill: parent
                                        anchors.left: parent.left
                                        anchors.leftMargin: parent.width * 0.05
                                        text: model.error_time
                                        font.pixelSize: height * 0.3
                                        font.bold: true
                                        color: error_text_color
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.Wrap
                                    }
                                }
                                Rectangle {
                                    width: item_message.width * 0.2
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        id: text_error_code
                                        clip: true
                                        anchors.fill: parent
                                        anchors.left: parent.left
                                        anchors.leftMargin: parent.width * 0.05
                                        text: model.error_code
                                        font.pixelSize: height * 0.3
                                        font.bold: true
                                        color: error_text_color
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.Wrap
                                    }
                                }
                                Rectangle {
                                    width: item_message.width * 0.2
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        id: text_error_level
                                        clip: true
                                        anchors.fill: parent
                                        anchors.left: parent.left
                                        anchors.leftMargin: parent.width * 0.05
                                        text: model.error_level
                                        font.pixelSize: height * 0.3
                                        font.bold: true
                                        color: error_text_color
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.Wrap
                                    }
                                }
                                Rectangle {
                                    width: item_message.width * 0.4
                                    height: parent.height
                                    color: "transparent"
                                    Text {
                                        id: text_error_message
                                        clip: true
                                        anchors.fill: parent
                                        anchors.left: parent.left
                                        anchors.leftMargin: parent.width * 0.05
                                        text: model.error_message
                                        font.pixelSize: height * 0.3
                                        font.bold: true
                                        color: error_text_color
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.Wrap
                                    }
                                }
                            }
                        }
                        model: ListModel {
                            id: message_list_model
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: timer_btn_errror_flashes
        running: false
        repeat: true
        interval: 800
        onTriggered: {
            if (has_error) {
                btn_error.opacity = btn_error.opacity === 0 ? 1 : 0
                timer_no_error_close.times = 0
            } else {
                timer_btn_errror_flashes.stop()
                btn_error.visible = false
            }
        }
    }
    Timer {
        id: timer_btn_errror_open
        running: false
        repeat: true
        interval: 5000
        onTriggered: {
            if (has_error) {
                draw_error.open()
            } else {
                timer_btn_errror_open.stop()
                btn_error.visible = false
            }
        }
    }
    Timer {
        id: timer_no_error_close
        running: false
        repeat: true
        interval: 1000
        property int times: 0
        onTriggered: {
            ++times
            if (times === 2) {
                timer_btn_errror_open.stop()
                timer_btn_errror_flashes.stop()
                btn_error.visible = false
                root.has_error = false
                root.is_first_get_error = false
            }
        }
    }
}
