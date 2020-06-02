import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0


Popup {
    id: root
    width: parent.width
    height: parent.height
    modal: true
    focus: true
    dim: false
    closePolicy: Popup.CloseOnPressOutsideParent
    property string txt_context: ""
    background: Rectangle {
        anchors.fill: parent
        opacity: 0.3
        RadialGradient {
            anchors.fill: parent
            gradient: Gradient
            {
                GradientStop{position: 0.3; color:"gray"}
                GradientStop{position: 0.7; color:"black"}
            }
        }
    }
    contentItem: Item {
        anchors.fill: parent


        Column {
            anchors.fill: parent


            Rectangle {
                id: rect_busy
                width: parent.width
                height: parent.height * 0.5
                color: "transparent"

                BusyIndicator {
                    id: busyIndication
                    width: parent.width
                    height: parent.height * 0.5
                    anchors.bottom: parent.bottom
                }
            }

            Text {
                id: txt_info
                width: parent.width
                height: parent.height * 0.5
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height * 0.1
                text: root.txt_context
                color: "blue"
                font.bold: true
            }
        }
    }
}
