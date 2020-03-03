import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import "CustomControl"

Rectangle {
    id: root
    TLInfoDisplayPage {
        id: rect_info_display
        width: parent.width
        height: parent.height * 0.65
    }
    Rectangle {
        id: rect_bottom
        width: parent.width
        height: parent.height * 0.35
        anchors.top: rect_info_display.bottom
        DelayButton {
            id: delayButton
            width: Math.min(parent.width, parent.height)
            height: width
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            delay: 1000
            text: qsTr("start")

            style: DelayButtonStyle {

                progressBarGradient: Gradient {
                    GradientStop { position: 0.0; color: "green" }
                    GradientStop { position: 0.99; color: "green" }
                    GradientStop { position: 1.0; color: "green" }
                }
                progressBarDropShadowColor: "green"
            }
        }
        TLButton {
            id: btn_task_progress
            width: 60 * rate
            height: 30 * rate
            font_size: 7 * rate
            btn_text: qsTr("Progress")
            anchors {
                right: parent.right
                bottom: parent.bottom
            }
            onClicked: {
                turn_task_page = true
            }
        }
        Rectangle {
            width: 60 * rate
            height: 30 * rate
            anchors {
                left: parent.left
                bottom: parent.bottom
            }
            Image {
                id: name
                anchors.fill: parent
                source: "qrc:/res/pictures/eye.png"
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        turn_task_page = true
                    }
                }
            }
        }
    }
}
