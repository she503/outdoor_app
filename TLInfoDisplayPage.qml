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

    Connections {
        target: socket_manager
        onUpdateBatteryInfo: {
            var v_soc = soc;
            var n_soc = Number(v_soc)
            if (n_soc <= 20) {
                info_battery.info_text_color = "red"
            } else if (n_soc > 20 && n_soc <= 50) {
                info_battery.info_text_color = "orange"
            } else if (n_soc > 50) {
                info_battery.info_text_color = "green"
            }
            info_battery.info_text = v_soc + "%"
        }
        onUpdateVehicleSpeed: {
            var v_speed = speed
            var n_speed = Number(v_speed)
            if (n_speed <= 10) {
                info_speed.info_text_color = "green"
            } else if (n_speed > 10 && n_speed <= 15) {
                info_speed.info_text_color = "orange"
            } else if (n_speed > 15) {
                info_speed.info_text_color = "red"
            }
            info_speed.info_text = n_speed / 10.0 + "m/s"
        }
        onUpdateWaterVolume: {
            var v_water_volume = water_volume
            info_water.info_text = v_water_volume + "%"
            var n_water_volume = Number(v_water_volume)

            if (n_water_volume <= 20) {
                info_water.info_text_color = "red"
            } else if (n_water_volume > 20 && n_water_volume <= 50) {
                info_water.info_text_color = "orange"
            } else if (n_water_volume > 50) {
                info_water.info_text_color = "green"
            }
            info_water.info_text = v_water_volume + "%"
        }
    }

    //battery
    Rectangle {
        id: rect_battery_info
        width: rect_info_display.cellWidth
        height: rect_info_display.cellHeight
        color: "transparent"
        anchors {
            top: parent.top
            topMargin: height * 0.05
            left: parent.left
        }
        TLInfoDisplay {
            id: info_battery
            x: (rect_battery_info.width - rect_info_display.min_length) / 2
            y: (rect_battery_info.height - rect_info_display.min_length) / 2
            width: rect_info_display.btn_size
            height: rect_info_display.btn_size

            isImage: false
            model_name_text: qsTr("Battery Soc")
            info_text: "85%"
            info_text_color: "green"
        }
    }

    //water
    Rectangle {
        id: rect_water_info
        width: rect_info_display.cellWidth
        height: rect_info_display.cellHeight
        color: "transparent"
        anchors {
            top: parent.top
            topMargin: height * 0.05
            left: rect_battery_info.right
        }
        TLInfoDisplay {
            id: info_water
            x: (rect_battery_info.width - rect_info_display.min_length) / 2
            y: (rect_battery_info.height - rect_info_display.min_length) / 2
            width: rect_info_display.btn_size
            height: rect_info_display.btn_size

            isImage: false
            model_name_text: qsTr("Water")

            info_text: "85%"
            info_text_color: "green"
        }
    }

    //operate
    Rectangle {
        id: rect_operate_info
        width: rect_info_display.cellWidth
        height: rect_info_display.cellHeight
        color: "transparent"
        anchors {
            top: parent.top
            topMargin: height * 0.05
            left: rect_water_info.right
        }
        TLInfoDisplay {
            id: info_operate
            x: (rect_battery_info.width - rect_info_display.min_length) / 2
            y: (rect_battery_info.height - rect_info_display.min_length) / 2
            width: rect_info_display.btn_size
            height: rect_info_display.btn_size

            isImage: true
            model_name_text: qsTr("operate --- auto")
            img_source: "qrc:/res/pictures/switch-operate.png"
        }
    }

    //gear
    Rectangle {
        id: rect_gear_info
        width: rect_info_display.cellWidth
        height: rect_info_display.cellHeight
        color: "transparent"
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        TLInfoDisplay {
            id: info_gear
            x: (rect_battery_info.width - rect_info_display.min_length) / 2
            y: (rect_battery_info.height - rect_info_display.min_length) / 2
            width: rect_info_display.btn_size
            height: rect_info_display.btn_size

            isImage: true
            model_name_text: qsTr("gear")
            img_source: "qrc:/res/pictures/controls.png"
        }
    }

    //speed
    Rectangle {
        id: rect_speed_info
        width: rect_info_display.cellWidth
        height: rect_info_display.cellHeight
        color: "transparent"
        anchors {
            bottom: parent.bottom
            left: rect_gear_info.right
        }
        TLInfoDisplay {
            id: info_speed
            x: (rect_battery_info.width - rect_info_display.min_length) / 2
            y: (rect_battery_info.height - rect_info_display.min_length) / 2
            width: rect_info_display.btn_size
            height: rect_info_display.btn_size

            isImage: false
            model_name_text: qsTr("Speed")

            info_text: "30m/s"
            info_text_color: "red"
        }
    }

    //state
    Rectangle {
        id: rect_state_info
        width: rect_info_display.cellWidth
        height: rect_info_display.cellHeight
        color: "transparent"
        anchors {
            bottom: parent.bottom
            left: rect_speed_info.right
        }
        TLInfoDisplay {
            id: info_state
            x: (rect_battery_info.width - rect_info_display.min_length) / 2
            y: (rect_battery_info.height - rect_info_display.min_length) / 2
            width: rect_info_display.btn_size
            height: rect_info_display.btn_size

            isImage: true
            model_name_text: qsTr("States")
            img_source: "qrc:/res/pictures/information.png"
        }
    }

}
