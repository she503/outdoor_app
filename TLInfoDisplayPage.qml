import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: rect_info_display
    width: parent.width
    height: parent.height

    property real cellWidth: width / 3
    property real cellHeight: height / 2
    property real min_length: Math.min(cellHeight, cellWidth)
    property real btn_size: min_length * 0.8

    color: "transparent"
    //    Connections {
    //        target: socket_manager
    //        onUpdateBatteryInfo: {
    //            var v_soc = soc;
    //            var n_soc = Number(v_soc)
    //            if (n_soc <= 20) {
    //                soc_color.color = "red"
    //            } else if (n_soc > 20 && n_soc <= 50) {
    //                soc_color.color = "orange"
    //            } else if (n_soc > 50) {
    //                soc_color.color = "#00ff24"
    //            }
    //            text_soc.text = v_soc
    //        }
    //        onUpdateVehicleSpeed: {

    //        }
    //        onUpdateWaterVolume: {
    //            var v_water_volume = water_volume
    //            text_water.color = v_water_volume
    //            var n_water_volume = Number(v_water_volume)

    //            if (n_water_volume <= 20) {
    ////                color_water.color = "red"
    //            } else if (n_water_volume > 20 && n_water_volume <= 50) {
    ////                color_water.color = "orange"
    //            } else if (n_water_volume > 50) {
    ////                color_water.color = "#00ff24"
    //            }
    //            text_water.text = v_water_volume
    //        }
    //    }

    Connections {
        target: ros_message_manager
        onUpdateChassisInfo: {
//            var v_speed = speed
//            var n_speed = Number(v_speed)
////            text_speed.color = "lightgreen"
////            text_speed.text = n_speed

//            if (drive_mode === 0) {
//                img_switch.source = "qrc:/res/pictures/switch_operate.png"
//            } else if (drive_mode === 1) {
//                img_switch.source = "qrc:/res/pictures/switch_auto.png"
//            }

//            if (cleaning_agency_state == 0) {
//                shuazi.source = "qrc:/res/pictures/states_no.png"
//            } else if (cleaning_agency_state == 1) {
//                shuazi.source = "qrc:/res/pictures/states_success.png"
//            }

//            if(water_tank_signal) {

//            } else {

//            }

//            if(Math.abs(n_speed) <= 0.05) {
//                gear.source = "qrc:/res/pictures/gear_n.png"
//            }
//            if(n_speed > 0.05) {
//                gear.source = "qrc:/res/pictures/gear_d.png"
//            } else if (n_speed < -0.05) {
//                 gear.source = "qrc:/res/pictures/gear_r.png"
//            }
        }
        onUpdateBatteryInfo: {
//            var v_soc = soc;
//            if (v_soc <= 20) {
//                soc_color.color = "red"
//            } else if (v_soc > 20 && v_soc < 50) {
//                soc_color.color = "orange"
//            } else if (v_soc >= 50) {
//                soc_color.color = "#00ff24"
//            }
//            text_soc.text = v_soc
////            console.info(soc)
        }
    }

    property real left_length: height / 3 > width / 2 ?  width / 2 : height / 3
    property real right_length: height / 2 > width / 2 ?  width / 2 : height / 2

    //left view
    Rectangle {
        id: rect_left_view
        width: parent.width / 2
        height: parent.height
        color: "transparent"
        Rectangle {
            id: bac_battery
            width: parent.width
            height: parent.height / 3
//            color: Qt.rgba(255,0,0,0.1)
            color: "transparent"
            Rectangle {
                anchors.centerIn: parent
                width: left_length
                height: left_length * 0.6
                color: "transparent"
                Image {
                    source: "qrc:/res/ui/CenterBigBtn/battery.png"
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: - left_length * 0.16
                    width: left_length * 0.85
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
        Rectangle {
            id: bac_water
            width: parent.width
            height: parent.height / 3
//            color: Qt.rgba(255,0,0,0.2)
            color: "transparent"
            anchors.top: bac_battery.bottom
            Rectangle {
                anchors.centerIn: parent
                width: left_length
                height: left_length * 0.6
                color: "transparent"
                Image {
                    source: "qrc:/res/ui/CenterBigBtn/water.png"
                    width: left_length * 0.85
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: - left_length * 0.02
                    anchors.leftMargin: - left_length * 0.3
                    fillMode: Image.PreserveAspectFit
                }
            }

        }
        Rectangle {
            id: bac_state
            width: parent.width
            height: parent.height / 3
//            color: Qt.rgba(255,0,0,0.3)
            color: "transparent"
            anchors.top: bac_water.bottom
            Rectangle {
                anchors.centerIn: parent
                width: left_length
                height: left_length * 0.65
//                color: Qt.rgba(255,0,0,0.3)
                color: "transparent"
                Image {
                    source: "qrc:/res/ui/CenterBigBtn/pro_is_clearning.png"
                    width: left_length * 0.95
                    fillMode: Image.PreserveAspectFit
                    anchors.left: parent.left
                    anchors.leftMargin: left_length * 0.02
                }
            }
        }
    }

    //right  view
    Rectangle {
        id: rect_right_view
        width: parent.width / 2
        height: parent.height
        color: "transparent"
        anchors.left: rect_left_view.right
        Rectangle {
            id: bac_gear
            width: parent.width
            height: parent.height / 2
//            color: Qt.rgba(0,255,0,0.1)
            color: "transparent"
            Rectangle {
                anchors.centerIn: parent
                width: right_length / 2
                height: right_length / 2
//                color: "transparent"//Qt.rgba(0,255,0,0.3)
                color: "transparent"
                Row {
                    width: parent.width
                    height: parent.height * 0.55
                    anchors.left: parent.left
                    anchors.leftMargin: right_length * 0.14
                    anchors.bottom: parent.bottom
                    Rectangle {
                        width: parent.width / 3
                        height: parent.height
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            anchors.margins: right_length * 0.03
                            source: "qrc:/res/ui/CenterBigBtn/gear_D.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    Rectangle {
                        width: parent.width / 3
                        height: parent.height
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            anchors.margins: right_length * 0.03
                            source: "qrc:/res/ui/CenterBigBtn/gear_N.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    Rectangle {
                        width: parent.width / 3
                        height: parent.height
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            anchors.margins: right_length * 0.03
                            source: "qrc:/res/ui/CenterBigBtn/gear_R.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }
        Rectangle {
            id: bac_operate
            width: parent.width
            height: parent.height / 2
//            color: Qt.rgba(0,255,0,0.2)
            color: "transparent"
            anchors.top: bac_gear.bottom
            Rectangle {
                anchors.centerIn: parent
                width: right_length / 2
                height: right_length / 2
                color: "transparent"
                Image {
                    source: "qrc:/res/ui/CenterBigBtn/manual_mode.png" //"qrc:/res/ui/CenterBigBtn/auto_mode.png"
                    anchors.top: parent.top
                    anchors.topMargin: - right_length * 0.05
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: right_length * 0.1
                    width: left_length / 2
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
    //center view
    Rectangle {
        id: bac_start_task
        z: 1
        width: parent.width * 0.39
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: - right_length * 0.02
        color: "transparent"
        radius: width / 2
        Image {
            anchors.fill: parent
            source: "qrc:/res/ui/background/start_task.png"
            fillMode: Image.PreserveAspectFit
        }
        Rectangle {
            width: parent.width * 0.5
            height: width
            anchors.centerIn: parent
            color: "transparent"
            Image {
                anchors.fill: parent
                anchors.centerIn: parent
                source: "qrc:/res/ui/CenterBigBtn/btn_start.png"
                fillMode: Image.PreserveAspectFit
            }
        }
    }

//    //battery
//    Rectangle {
//        id: bac_battery
//        width: parent.width / 3
//        height:parent.height / 2
//        color: "transparent"
//        Image {
//            width: length
//            height: length / 3
//            source: "qrc:/res/ui/CenterBigBtn/battery.png"
//            anchors.centerIn: parent
//            fillMode: Image.PreserveAspectFit
////            Rectangle {
////                id: content_soc
////                width: parent.width / 2
////                height: parent.height / 4
////                color: "red"
////                anchors {
////                    horizontalCenter: parent.horizontalCenter
////                    top: parent.top
////                    topMargin: parent.height * 0.31
////                }
////                Text {
////                    z: 2
////                    id: text_soc
////                    text: qsTr("1")
////                    width: parent.width * 0.5
////                    height: parent.height
////                    verticalAlignment: Text.AlignVCenter
////                    horizontalAlignment: Text.AlignRight
////                    font.pixelSize: height * 0.5
////                    font.bold: true
////                    color: "white"
////                }
////                Text {
////                    z: 2
////                    anchors{
////                        left: text_soc.right
////                        //                    leftMargin: width * 0.1
////                        bottom: parent.bottom
////                        bottomMargin: height * 0.1
////                    }
////                    text: qsTr("%")
////                    width: parent.width * 0.3
////                    height: parent.height * 0.8
////                    verticalAlignment: Text.AlignVCenter
////                    horizontalAlignment: Text.AlignHCenter
////                    font.pixelSize: height * 0.5
////                    font.bold: true
////                    color: text_soc.color
////                }
////                Rectangle {
////                    id: soc_color
////                    width: parent.width * 0.72 * text_soc.text / 100
////                    height: parent.height * 0.5
////                    radius: height / 8
////                    color: "white"
////                    anchors.left: parent.left
////                    anchors.leftMargin: parent.width * 0.15
////                    anchors.top: parent.top
////                    anchors.topMargin: parent.height * 0.25
////                }
////            }
//        }
//    }

//    //water
//    Rectangle {
//        id: bac_water
//        width: parent.width / 3
//        height:parent.height / 2
//        color: "transparent"
//        anchors.left: bac_battery.right
//        Image {
//            width: length
//            height: length
//            source: "qrc:/res/pictures/water.png"
//            anchors.centerIn: parent

//            Rectangle {
//                id: content_water
//                width: parent.width / 2
//                height: parent.height / 4
//                color: "transparent"
//                anchors {
//                    horizontalCenter: parent.horizontalCenter
//                    top: parent.top
//                    topMargin: parent.height * 0.3
//                }
//                Text {
//                    id: text_water
//                    text: qsTr("")
//                    width: parent.width * 0.5
//                    height: parent.height
//                    verticalAlignment: Text.AlignVCenter
//                    horizontalAlignment: Text.AlignRight
//                    font.pixelSize: height * 0.5
//                    font.bold: true
//                    color: "white"
//                }
//                Text {
//                    anchors{
//                        left: text_water.right
//                        //                    leftMargin: width * 0.1
//                        bottom: parent.bottom
//                        bottomMargin: height * 0.1
//                    }
//                    text: qsTr("")
//                    width: parent.width * 0.3
//                    height: parent.height * 0.8
//                    verticalAlignment: Text.AlignVCenter
//                    horizontalAlignment: Text.AlignHCenter
//                    font.pixelSize: height * 0.5
//                    font.bold: true
//                    color: text_water.color
//                }
//            }
//        }
//    }

//    //operate
//    Rectangle {
//        id: bac_operate
//        width: parent.width / 3
//        height:parent.height / 2
//        color: "transparent"
//        anchors.left: bac_water.right
//        Image {
//            id: img_switch
//            width: length
//            height: length
//            source: "qrc:/res/pictures/switch_operate.png"  //"qrc:/res/pictures/switch_auto.png"
//            anchors.centerIn: parent
//        }
//    }

//    //gear
//    Rectangle {
//        id: bac_gear
//        width: parent.width / 3
//        height:parent.height / 2
//        color: "transparent"
//        anchors{
//            top: bac_battery.bottom
//            left: parent.left
//        }
//        Image {
//            id: gear
//            width: length
//            height: length
//            source: "qrc:/res/pictures/controls.png"
//            anchors.centerIn: parent
//        }
//    }

//    //speed
//    Rectangle {
//        id: bac_speed
//        width: parent.width / 3
//        height:parent.height / 2
//        color: "transparent"
//        anchors{
//            top: bac_water.bottom
//            left: bac_gear.right
//        }
//        Image {
//            width: length
//            height: length
//            source: "qrc:/res/pictures/speed.png"
//            anchors.centerIn: parent
//            Rectangle {
//                id: content_speed
//                width: parent.width / 2
//                height: parent.height / 4
//                color: "transparent"
//                anchors {
//                    horizontalCenter: parent.horizontalCenter
//                    top: parent.top
//                    topMargin: parent.height * 0.33
//                }
//                Rectangle{
//                    anchors.fill: parent
//                    color: "transparent"
//                    Text {
//                        id: text_speed
//                        text: qsTr("1")
//                        width: parent.width * 0.5
//                        height: parent.height
//                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignRight
//                        font.pixelSize: height * 0.5
//                        font.bold: true
//                        color: "white"
//                    }
//                    Text {
//                        anchors{
//                            left: text_speed.right
//                            leftMargin: width * 0.1
//                            bottom: parent.bottom
//                            bottomMargin: height * 0.1
//                        }
//                        text: qsTr("m/s")
//                        width: parent.width * 0.3
//                        height: parent.height * 0.8
//                        verticalAlignment: Text.AlignVCenter
//                        horizontalAlignment: Text.AlignHCenter
//                        font.pixelSize: height * 0.5
//                        font.bold: true
//                        color: text_speed.color
//                    }
//                }

//            }
//        }
//    }

//    //state
//    Rectangle {
//        id: bac_state
//        width: parent.width / 3
//        height:parent.height / 2
//        color: "transparent"
//        anchors{
//            top: bac_operate.bottom
//            left: bac_speed.right
//        }
//        Image {
//            id: shuazi
//            width: length
//            height: length
//            source: "qrc:/res/pictures/states_no.png"
//            anchors.centerIn: parent
//        }
//    }

}
