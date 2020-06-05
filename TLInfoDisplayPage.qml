import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root

    color: "transparent"
    signal sigCenterBtnClicked()
    Rectangle {
        id: rect_battery
        width: parent.width * 0.3
        height: parent.height * 0.4
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: parent.width * 0.1
        }
        color: "transparent"

        Image {
            id: img_battery
            width: parent.width
            height: parent.height
            source: "qrc:/res/ui/CenterBigBtn/battery.png"
            fillMode: Image.PreserveAspectFit

            property int battery_little_width: img_battery.width * 0.2
            property int battery_more_width: img_battery.width * 0.58

            function changeBatteryUI(soc) {
                if ((soc) < 30) {
                    img_battery_full_bar.visible = false
                    img_battery_more_bat.visible = false
                    img_battery_little_bar.visible = true
                    img_battery_little_bar.width = battery_little_width / 30 * soc

                } else if ((soc) >= 30 && (soc) <= 90) {
                    img_battery_full_bar.visible = false
                    img_battery_little_bar.visible = false
                    img_battery_more_bat.visible = true
                    img_battery_more_bat.width = battery_more_width / 90 * soc
                } else if ((soc) > 90) {
                    img_battery_more_bat.visible = false
                    img_battery_little_bar.visible = false
                    img_battery_full_bar.visible = true
                }
                txt_battery.text = soc + " %"
            }

            Connections {
                target: ros_message_manager
                onUpdateBatteryInfo: {
                    var v_soc = soc;
                    var n_soc = Number(v_soc)
                    img_battery.changeBatteryUI(n_soc)
                }
            }
            Image {
                id: img_battery_full_bar
                visible: true
                width: img_battery.paintedWidth * 0.60
                height: img_battery.paintedHeight * 0.15
                source: "qrc:/res/ui/background/progress_full.png"
                //                fillMode: Image.PreserveAspectFit
                anchors {
                    top: parent.top
                    topMargin: parent.height * 0.394
                    left: parent.left
                    leftMargin: parent.width * 0.2
                }

            }
            Rectangle {
                id: img_battery_little_bar
                visible: false
                width: parent.width * 0.2
                height: parent.height * 0.060
                color: Qt.rgba(255, 0, 0, 0.4)
                anchors {
                    top: parent.top
                    topMargin: parent.height * 0.394
                    left: parent.left
                    leftMargin: parent.width * 0.2

                }
            }
            Rectangle {
                id: img_battery_more_bat
                visible: false
                width: parent.width * 0.58
                height: parent.height * 0.060
                color: Qt.rgba(0, 10, 255, 0.4)
                anchors {
                    top: parent.top
                    topMargin: parent.height * 0.394
                    left: parent.left
                    leftMargin: parent.width * 0.2
                }
            }
            Text {
                id: txt_battery
                width: parent.width * 0.58
                height: parent.height * 0.062
                font.pixelSize: height
                font.bold: true
                text: "100 %"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                anchors {
                    top: parent.top
                    topMargin: parent.height * 0.39
                    left: parent.left
                    leftMargin: parent.width * 0.19
                }
            }
        }
    }

    Rectangle {
        id: rect_water
        width: parent.width * 0.3
        height: parent.height * 0.3
        color: "transparent"
        anchors {
            top: rect_battery.bottom
            topMargin: - parent.height * 0.1
            left: parent.left
            leftMargin: parent.width * 0.03
        }
        Image {
            id: img_water
            width: parent.width
            height: parent.height
            source: "qrc:/res/ui/CenterBigBtn/water.png"
            fillMode: Image.PreserveAspectFit
        }
        Rectangle {
            id: img_water_progress_bar
            visible: true
            width: parent.width * 0.58
            height: parent.height * 0.075
            color: Qt.rgba(0, 255, 0, 0.4)
            anchors {
                top: parent.top
                topMargin: parent.height * 0.45
                left: parent.left
                leftMargin: parent.width * 0.25

            }
        }
    }

    Rectangle {
        id: rect_clean
        width: parent.width * 0.3
        height: parent.height * 0.3
        color: "transparent"
        anchors {
            top: rect_water.bottom
            left: parent.left
            leftMargin: parent.width * 0.08
        }
        Image {
            id: img_clean
            width: parent.width
            height: parent.height
            source: "qrc:/res/ui/CenterBigBtn/clean.png"
            fillMode: Image.PreserveAspectFit

            property int task_width: img_clean.width * 0.58
            Connections {
                target: ros_message_manager
                onUpdateTaskProcessInfo: {
                    txt_clean_progress.text = "" + progress + " %";
                    img_clean_progress_bar.width = img_clean.task_width / 100 * progress
                }
            }

            Rectangle {
                id: img_clean_progress_bar
                visible: true
                width: parent.width * 0.58
                height: parent.height * 0.073
                color: Qt.rgba(0, 255, 0, 0.4)
                anchors {
                    top: parent.top
                    topMargin: parent.height * 0.54
                    left: parent.left
                    leftMargin: parent.width * 0.25

                }
            }
            Text {
                id: txt_clean_progress
                text: qsTr("0 %")
                width: parent.width * 0.58
                height: parent.height * 0.075
                font.pixelSize: height
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors {
                    top: parent.top
                    topMargin: parent.height * 0.55
                    left: parent.left
                    leftMargin: parent.width * 0.25
                }
            }
        }
    }

    Rectangle {
        id: rect_gear
        width: parent.width * 0.3
        height: parent.height * 0.5
        color: "transparent"
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: parent.width * 0.05
        }
        Image {
            id: img_gear
            width: parent.width
            height: parent.height
            source: "qrc:/res/ui/CenterBigBtn/gear_r.png"
            fillMode: Image.PreserveAspectFit
        }
        Connections {
            target: ros_message_manager
            onUpdateDrivingInfo: {
                var v_speed = speed
                var n_speed = Number(v_speed)

                if (drive_mode === 0) {
                    img_operate.source = "qrc:/res/ui/CenterBigBtn/operate_hand.png"
                } else if (drive_mode === 1) {
                    img_operate.source = "qrc:/res/ui/CenterBigBtn/operate_auto.png"
                }

                if(Math.abs(n_speed) <= 0.05) {
                    img_gear.source = "qrc:/res/ui/CenterBigBtn/gear_n.png"
                } else if(n_speed > 0.05) {
                    img_gear.source = "qrc:/res/ui/CenterBigBtn/gear_d.png"
                } else if (n_speed < -0.05) {
                    img_gear.source = "qrc:/res/ui/CenterBigBtn/gear_r.png"
                }

            }
        }
    }

    Rectangle {
        id: rect_operate
        width: parent.width * 0.3
        height: parent.height * 0.5
        color: "transparent"
        anchors {
            top: rect_gear.bottom
            right: parent.right
            rightMargin: parent.width * 0.1
        }

        Image {
            id: img_operate
            width: parent.width
            height: parent.height
            source: "qrc:/res/ui/CenterBigBtn/operate_hand.png"
            fillMode: Image.PreserveAspectFit
        }
    }

    Rectangle {
        id: rect_center_btn
        width: parent.height * 0.5
        height: width
        color: "transparent"
        anchors {

            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Image {
            id: img_center_btn
            anchors.fill: parent
            source: "qrc:/res/ui/background/start_task.png"
            fillMode: Image.PreserveAspectFit
            Image {
                id: img_start
                visible: false
                anchors.centerIn: parent
                width: parent.width * 0.45
                height: parent.height * 0.45
                source: "qrc:/res/ui/CenterBigBtn/btn_start.png"
            }
            Image {
                id: img_cleaning
                visible: false
                anchors.centerIn: parent
                width: parent.width * 0.45
                height: parent.height * 0.45
                source: "qrc:/res/ui/CenterBigBtn/btn_cleaning.png"
            }
            Image {
                id: img_finish
                visible: false
                anchors.centerIn: parent
                width: parent.width * 0.45
                height: parent.height * 0.45
                source: "qrc:/res/ui/CenterBigBtn/btn_finish.png"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.sigCenterBtnClicked()
                }
            }
            Rectangle {
                id: center_progress_bar
                anchors.fill: parent
                color: "transparent"
                Canvas {
                    id: canvas_background
                    anchors.fill: parent
                    property string arcColor: "rgba(100,149,237, 0.8)"
                    property color arcBackgroundColor: "#ffffff"
                    property int arcWidth: parent.width * 0.09
                    property real _progress: 20
                    property real radius: parent.width / 2 * 0.65
                    property bool anticlockwise: false

                    Connections {
                        target: ros_message_manager
                        onUpdateTaskProcessInfo: {
                            canvas_background._progress = progress;
                            canvas_background.requestPaint()
                        }
                    }
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                        var r = canvas_background._progress/100 * 2 * Math.PI
                        ctx.beginPath()
                        ctx.strokeStyle = arcColor
//                        ctx.lineCap = "round"
                        ctx.lineWidth = arcWidth

                        ctx.arc(width/2,height/2,radius,Math.PI / 2,Math.PI / 2  + r ,anticlockwise)
                        ctx.stroke()
                    }
                }
            }

            function changeVisible(status) {
                if (status >= status_manager.getNoneWorkID() && status < status_manager.getWorkingID()) {
                    img_start.visible = true
                    img_finish.visible = false
                    img_cleaning.visible = false
                } else if (status === status_manager.getWorkingID()) {
                    img_start.visible = false
                    img_finish.visible = false
                    img_cleaning.visible = true
                } else if (status === status_manager.getWorkDoneID()) {
                    img_start.visible = false
                    img_finish.visible = true
                    img_cleaning.visible = false
                }
            }

            Component.onCompleted: {
                var status = status_manager.getWorkStatus()
                img_center_btn.changeVisible(status)
            }

            Connections {
                target: status_manager
                onWorkStatusUpdate: {
                    img_center_btn.changeVisible(status)
                }
            }

        }
    }

}
