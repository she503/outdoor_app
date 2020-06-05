import QtQuick 2.0
import QtQuick.Controls 2.2
Rectangle {
    id: root
    color: "transparent"

    property string map_name: map_task_manager.getCurrentMapName()
    property var work_second: 0
    property var work_time: []
    property string title_color: "black"
    property string font_color: "blue"

    function toTime(s){
        var working_time = []
        if(s > -1){
            var hour = Math.floor(s / 3600)
            var min = Math.floor((s / 60) % 60)
            var sec = root.work_second % 60
            if(hour < 10){
                working_time = hour + " 时 "
            }
            if(min < 10){
                working_time += "0"
            }
            working_time += min + " 分 "
            if(sec < 10){
                working_time += "0"
            }
            working_time += sec.toFixed(0) + " 秒"
        }
        return working_time
    }

    Image {
        anchors.fill: parent
        source: "qrc:/res/pictures/background_glow1.png"
    }

    Timer{
        id: timer_task_timing
        interval: 1000
        repeat: true
        running: status_manager.getWorkStatus() === status_manager.getWorkingID()
        triggeredOnStart: true
        onTriggered: {
            root.work_second++
            root.work_time = toTime(work_second)
            text_work_time.text = root.work_time.toString()
        }
    }

    Connections {
        target: ros_message_manager
        onUpdateTaskProcessInfo: {
            text_progress.text = "" + progress + " %";
        }
    }

    Connections {
        target: status_manager
        onWorkStatusUpdate: {
            if (status === status_manager.getWorkingID()) {
                timer_task_timing.start()
            } else {
                root.work_second = 0
            }
        }
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
            }
        }
    }
}
