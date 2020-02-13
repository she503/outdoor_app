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
        height: parent.height * 0.3
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
    }
}
