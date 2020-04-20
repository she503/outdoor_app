import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import "./CustomControl"

Rectangle {
    property bool text_visible: false
    onText_visibleChanged: {
        rect_progress.visible = text_visible
        pic_start.visible = !text_visible
    }

    id: root
    color: "transparent"
    signal centerBtnPress(var status)

    Component.onCompleted: {
        var status = map_task_manager.getWorkStatus()
        if (status <= 2) {
            root.text_visible = false
        } else if (status >= 3) {
            root.text_visible = true
        }
    }

    TLInfoDisplayPage {
        id: rect_info_display
        width: parent.width
        height: parent.height * 0.65

    }


    Rectangle {
        id: rect_bottom
        width: parent.width
        height: parent.height * 0.35
        color: "transparent"
        anchors {
            top: rect_info_display.bottom
        }
        Rectangle {
            id: btn_start_stop
            width: parent.width * 0.4 > parent.height * 0.8 ? parent.height * 0.8 : parent.width * 0.4
            height: width
            anchors.centerIn: parent
            color: "transparent"

            Rectangle {
                id: rect_progress
                z: 3
                width: parent.width
                height: parent.height * 0.6
                anchors.centerIn: parent
                color: "transparent"
                visible: root.text_visible
                Text{
                    id: text_progress
                    width: parent.width
                    height: parent.height * 0.58
                    font.pointSize: parent.height > 0 ?  parent.height * 0.3 : 1
                    font.bold: true
                    text: canvas._progress + "%"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "green"
                }
                Text{
                    id: text_describe
                    anchors.top: text_progress.bottom
                    width: parent.width
                    height: parent.height * 0.4
                    font.pointSize: parent.height > 0 ? parent.height * 0.2 : 1
                    text: qsTr("Task Progress")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop
                    color: "blue"
                }
            }
            Canvas {
                Connections {
                    target: ros_message_manager
                    onUpdateTaskProcessInfo: {
                        canvas._progress = progress;
                        canvas.requestPaint()
                    }
                }
                property string arcColor: "rgba(0,255,127, 0.8)"
                property color arcBackgroundColor: "#ffffff"
                property int arcWidth: parent.width * 0.07
                property real _progress: 0
                property real radius: parent.width / 2 * 0.8
                property bool anticlockwise: false

                id: canvas
                z: 3
                width: 2*radius + arcWidth + 1
                height: 2*radius + arcWidth + 1
                anchors{
                    left: parent.left
                    leftMargin: parent.width * 0.076
                    top: parent.top
                    topMargin: parent.height * 0.02
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,width,height)
//                    ctx.beginPath()
//                    ctx.strokeStyle = arcBackgroundColor
//                    ctx.lineCap = "round"
//                    ctx.lineWidth = arcWidth
//                    ctx.arc(width/2,height/2,radius,0,Math.PI*2,anticlockwise)
//                    ctx.stroke()

                    var r = _progress* 2 * Math.PI/100
                    ctx.beginPath()
                    ctx.strokeStyle = arcColor
                    ctx.lineCap = "round"
                    ctx.lineWidth = arcWidth

                    ctx.arc(width/2,height/2,radius,Math.PI / 2 - r / 2,Math.PI / 2 + r / 2,anticlockwise)
                    ctx.stroke()
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var status = map_task_manager.getWorkStatus()
                        root.centerBtnPress(status)
                    }
                }
            }

            Image {
                z: 1
                anchors.fill: parent
                source: "qrc:/res/pictures/start_5.png"
            }
            Image {
                z: 1
                id: pic_start
                anchors.fill: parent
                source: "qrc:/res/pictures/start_3.png"
            }

            MouseArea {
                z: 10
                width: parent.width * 0.8
                height: parent.height * 0.8
                anchors.centerIn: parent
                onClicked: {
                    var status = map_task_manager.getWorkStatus()
                    root.centerBtnPress(status)
                }
            }

        }
    }
}
