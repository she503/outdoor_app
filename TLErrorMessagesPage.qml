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
    property string txt_color: "red"
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.close()
        }
    }

    Component.onCompleted: {
        root.close()
    }

    background: Rectangle {
        anchors.fill: parent
        opacity: 0.5
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
        Text {
            id: txt_info
            width: parent.width
            height: parent.height * 0.9
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: height * 0.1
            text: root.txt_context
            color: root.txt_color
            font.bold: true
            wrapMode: Text.Wrap
        }


        Text {
            id: txt_close
            width: parent.width
            height: parent.height * 0.3
            anchors {
                left: parent.left
                bottom: parent.bottom
            }

            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignRight
            font.pixelSize: height * 0.1
            text: qsTr("click anywhere to close this message...")
            color: "white"
            font.bold: true
        }
    }
}
