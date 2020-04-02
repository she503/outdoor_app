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
        target: map_task_manager
        onUpdateChassisInfo: {
            var v_speed = speed
            var n_speed = Number(v_speed)
            if (n_speed <= 10) {
                text_speed.color = "green"
            } else if (n_speed > 10 && n_speed <= 15) {
                text_speed.color = "orange"
            } else if (n_speed > 15) {
                text_speed.color = "red"
            }
            text_speed.text = n_speed

            if (drive_mode === 0) {
                img_switch.source = "qrc:/res/pictures/switch_operate.png"
            } else if (drive_mode === 1) {
                img_switch.source = "qrc:/res/pictures/switch_auto.png"
            }
        }
    }

    property real length: height / 2 > width / 3 ?  width / 3 : height / 2
    //battery
    Rectangle {
        id: bac_battery
        width: parent.width / 3
        height:parent.height / 2
        color: "transparent"
        Image {
            width: length
            height: length
            source: "qrc:/res/pictures/battery.png"
            anchors.centerIn: parent
            Rectangle {
                id: content_soc
                width: parent.width / 2
                height: parent.height / 4
                color: "transparent"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: parent.height * 0.31
                }
                Text {
                    z: 2
                    id: text_soc
                    text: qsTr("1")
                    width: parent.width * 0.5
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: height * 0.5
                    font.bold: true
                    color: "white"
                }
                Text {
                    z: 2
                    anchors{
                        left: text_soc.right
                        //                    leftMargin: width * 0.1
                        bottom: parent.bottom
                        bottomMargin: height * 0.1
                    }
                    text: qsTr("%")
                    width: parent.width * 0.3
                    height: parent.height * 0.8
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: height * 0.5
                    font.bold: true
                    color: text_soc.color
                }
                Rectangle {
                    id: soc_color
                    width: parent.width * 0.72 * text_soc.text / 100
                    height: parent.height * 0.5
                    radius: height / 8
                    color: "white"
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.15
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.25
                }
            }
        }
    }

    //water
    Rectangle {
        id: bac_water
        width: parent.width / 3
        height:parent.height / 2
        color: "transparent"
        anchors.left: bac_battery.right
        Image {
            width: length
            height: length
            source: "qrc:/res/pictures/water.png"
            anchors.centerIn: parent

            Rectangle {
                id: content_water
                width: parent.width / 2
                height: parent.height / 4
                color: "transparent"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: parent.height * 0.3
                }
                Text {
                    id: text_water
                    text: qsTr("1")
                    width: parent.width * 0.5
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: height * 0.5
                    font.bold: true
                    color: "white"
                }
                Text {
                    anchors{
                        left: text_water.right
                        //                    leftMargin: width * 0.1
                        bottom: parent.bottom
                        bottomMargin: height * 0.1
                    }
                    text: qsTr("%")
                    width: parent.width * 0.3
                    height: parent.height * 0.8
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: height * 0.5
                    font.bold: true
                    color: text_water.color
                }
            }
        }
    }

    //operate
    Rectangle {
        id: bac_operate
        width: parent.width / 3
        height:parent.height / 2
        color: "transparent"
        anchors.left: bac_water.right
        Image {
            id: img_switch
            width: length
            height: length
            source: "qrc:/res/pictures/switch_operate.png"  //"qrc:/res/pictures/switch_auto.png"
            anchors.centerIn: parent
        }
    }

    //gear
    Rectangle {
        id: bac_gear
        width: parent.width / 3
        height:parent.height / 2
        color: "transparent"
        anchors{
            top: bac_battery.bottom
            left: parent.left
        }
        Image {
            width: length
            height: length
            source: "qrc:/res/pictures/controls.png"
            anchors.centerIn: parent
        }
    }

    //speed
    Rectangle {
        id: bac_speed
        width: parent.width / 3
        height:parent.height / 2
        color: "transparent"
        anchors{
            top: bac_water.bottom
            left: bac_gear.right
        }
        Image {
            width: length
            height: length
            source: "qrc:/res/pictures/speed.png"
            anchors.centerIn: parent
            Rectangle {
                id: content_speed
                width: parent.width / 2
                height: parent.height / 4
                color: "transparent"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: parent.height * 0.33
                }
                Rectangle{
                    anchors.fill: parent
                    color: "transparent"
                    Text {
                        id: text_speed
                        text: qsTr("1")
                        width: parent.width * 0.5
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: height * 0.5
                        font.bold: true
                        color: "white"
                    }
                    Text {
                        anchors{
                            left: text_speed.right
                            leftMargin: width * 0.1
                            bottom: parent.bottom
                            bottomMargin: height * 0.1
                        }
                        text: qsTr("m/s")
                        width: parent.width * 0.3
                        height: parent.height * 0.8
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: height * 0.5
                        font.bold: true
                        color: text_speed.color
                    }
                }
            }
        }
    }

    //state
    Rectangle {
        id: bac_state
        width: parent.width / 3
        height:parent.height / 2
        color: "transparent"
        anchors{
            top: bac_operate.bottom
            left: bac_speed.right
        }
        Image {
            width: length
            height: length
            source: "qrc:/res/pictures/states_no.png"
            anchors.centerIn: parent
        }
    }

}
