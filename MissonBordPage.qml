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
    property bool is_first_error: true
    property var error_text_color: "red"//: ["yellow", "orange", "red"]

    property var p_process: 0
    property var s_single: 0
    property var t_total: 0
    property var s_speed: 0
    property var min_time: 0

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

    Row {       //沿单边定义其子项，水平定位一系列项目
        id: message_pic
        visible: true
        anchors.fill: parent

        TLBtnWithPic {      //显示当前电量
            id: lab_battery
            width: parent.width * 0.12
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

        TLBtnWithPic {      //显示当前速度
            id: lab_speed
            width: parent.width * 0.14
            height: parent.height
            backgroundDefaultColor: "transparent"
            img_source: "qrc:/res/ui/mission_bord/speed_pic.png"
            btn_text: "1 m/s"
            font_size: height * 0.3
            Connections {
                target: ros_message_manager
                onUpdateDrivingInfo: {
                    s_speed = speed
                    lab_speed.btn_text = s_speed + " m/s"
                }
            }
        }

        TLBtnWithPic {      //显示任务进度
            id: lab_progress
            width: parent.width * 0.12
            height: parent.height
            backgroundDefaultColor: "transparent"
            img_source: "qrc:/res/ui/mission_bord/task_progress.png"
            font_size: height * 0.3
            btn_text: "99 %"
            Connections {
                target: ros_message_manager
                onUpdateTaskProcessInfo: {
                     p_process = progress
                    lab_progress.btn_text = "" + progress + " %";
                }
            }
        }

        TLBtnWithPic {          //显示里程
            id: mileage
            width: parent.width * 0.17
            height: parent.height
            backgroundDefaultColor: "transparent"
            img_source: "qrc:/res/ui/mission_bord/mileage.png"
            font_size: height * 0.3
            Connections {
                target: ros_message_manager
                onUpdateMileageInfo: {
                     s_single = single
                    mileage.btn_text = s_single + "|" + total
                }
            }
        }

//        TLBtnWithPic {          //显示时间
//            id: s_time
//            width: parent.width * 0.15
//            height: parent.height
//            backgroundDefaultColor: "transparent"
//            img_source: "qrc:/res/ui/mission_bord/time.png"
//            font_size: height * 0.3
//            btn_text: "0"
//            Timer {
//                id: timer_btn
//                running: false
//                repeat: true
//                interval: 1000
//                onTriggered: {
//                    btn_text :(((s_single/p_process)*100 - s_single)/s_speed) * 60
//                }
//            }
//        }

//        Image {
//            id: lab_gear
//            width: parent.width * 0.1
//            height: parent.height * 0.8
//            fillMode: Image.PreserveAspectFit
//            anchors.verticalCenter: parent.verticalCenter
//            source: "qrc:/res/ui/mission_bord/gear_N_pic.png"

//                    var n_speed = Number(v_speed)

//                    if (drive_mode === 0) {
//                        lab_operate.source = "qrc:/res/ui/mission_bord/operate_hand_pic.png"
//                    } else if (drive_mode === 1) {
//                        lab_operate.source = "qrc:/res/ui/mission_bord/operate_auto_pic.png"
//                    }

//                    if(Math.abs(n_speed) <= 0.05) {
//                        lab_gear.source = "qrc:/res/ui/mission_bord/gear_N_pic.png"
//                    } else if(n_speed > 0.05) {
//                        lab_gear.source = "qrc:/res/ui/mission_bord/gear_D_pic.png"
//                    } else if (n_speed < -0.05) {
//                        lab_gear.source = "qrc:/res/ui/mission_bord/gear_R_pic.png"
//                    }

//            }
//        }

//        Image {
//            id: lab_operate
//            width: parent.width * 0.15
//            height: parent.height
//            fillMode: Image.PreserveAspectFit
//            anchors.verticalCenter: parent.verticalCenter
//            source: "qrc:/res/ui/mission_bord/operate_auto_pic.png"
//        }
    }

    Connections {       //连接到ros_message
        target: ros_message_manager
        onUpdateMonitorMessageInfo: {
            busy_indicator.close()
            message_list_model.clear()
            root.has_error = true       //有错误信息
            timer_no_error_close.times = 0

            if (root.is_first_error) {
                root.is_first_error = false
                btn_error.visible = true
                timer_no_error_close.start()
                timer_btn_errror_flashes.start()
                draw_error.open()
            }

            for(var i = 0; i < monitor_message.length; ++i) {
                message_list_model.append({"error_time" : monitor_message[i][0],
                                              "error_level" : monitor_message[i][1],
                                              "error_code" : monitor_message[i][2],
                                              "error_message" : monitor_message[i][3]})
            }
        }
    }

    Button {        //锁屏
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

    Button {        //警告按钮
        id: btn_error
        visible: has_error      //false
        height: parent.height * 0.7
        width: height

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
        onClicked: {        //点击事件查看错误信息
            message_list_model.clear()
            if(draw_error.visible){
                draw_error.close()
            }else{
                draw_error.open()
            }
        }
    }


    Drawer {        //基于滑动的侧面板，类似那些常见于触摸界面的侧面板，已提供导航的中心位置
        id: draw_error
        visible: false
        width: parent.width
        height: parent.height
        modal: true
        dim: false
        edge: Qt.RightEdge      //从右边拖出
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        //确定弹出窗口关闭情况，允许多方式关闭窗口
        //在窗口外按下即可关闭，当escape键被按下关闭
        background: Rectangle{
            opacity: 0.6        //如果有错误信息显示，弹出的背景页面
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient      //渐变色
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
        Rectangle {     //故障框外框
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/background_glow1.png"    //透明框
            }
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.6
            x: (parent.width - width ) / 2
            y: (parent.height - height) / 2
            color: "transparent"
            Rectangle {     //故障信息框内框
                width: parent.width * 0.9
                height: parent.height * 0.88
                anchors.centerIn: parent
                color: "transparent"
                Rectangle {     //框顶字段信息
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
                        Text {          //故障时间
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
                        Text {          //故障码
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
                        Text {              //故障等级
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
                        Text {          //故障信息
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
                Rectangle {     //故障信息内容列表框
                    id: rec_message_info
                    width: parent.width
                    height: parent.height * 0.9
                    anchors.top: rec_message_head.bottom
                    border.width: 1
                    border.color: Qt.rgba(100, 100, 100, 0.6)
                    color: "transparent"
                    ListView {      //故障信息列表
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
                            background: Rectangle {     //单条故障信息
                                anchors.fill: parent
                                color: "transparent"
                            }
                            Row {       //故障信息字段内容，单行排列
                                anchors.fill: parent
                                Rectangle {
                                    width: item_message.width * 0.2
                                    height: parent.height
                                    color: "transparent"    //故障时间
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
                                    color: "transparent"        //故障码
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
                                    color: "transparent"        //故障等级
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
                                    color: "transparent"        //故障信息
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

    Timer {     //计时器
        id: timer_btn_errror_flashes
        running: false
        repeat: true        //为真则在指定时间内重复触发
        interval: 800       //800毫秒触发
        onTriggered: {      //警告图标跳动
                btn_error.opacity = btn_error.opacity === 0 ? 1 : 0
            //===判断类型和值相同则为真
        }
    }

    Timer {
        id: timer_no_error_close
        running: false
        repeat: true
        interval: 1000   //间隔1000毫秒
        property int times: 0
        onTriggered: {  //间隔1000毫秒触发，触发三次关闭
            ++times
            if (times >= 3) {
                draw_error.close()
                timer_btn_errror_flashes.stop()
                btn_error.visible = false
                root.has_error = false
                timer_no_error_close.stop()
                root.is_first_error = true
            }
        }
    }
}
