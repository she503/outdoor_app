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

            isImage: true
            model_name_text: qsTr("Battery Soc")
            img_source: "qrc:/res/pictures/battery.png"
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