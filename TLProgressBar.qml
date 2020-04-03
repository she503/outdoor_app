import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

ProgressBar {
    id: root

    property color color: "#3498DB"

    value: 0.5

    Connections {
        target: ros_message_manager
        onUpdateTaskProcessInfo: {
            root.value = progress
        }
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 12
        color: "#EBEDEF"
        radius: height / 2
    }
    contentItem: Item {
        implicitWidth: root.background.implicitWidth
        implicitHeight: root.background.implicitHeight

        Rectangle {
            width: root.visualPosition  * parent.width
            height: parent.height
            radius: height / 2
            smooth:true

            gradient: Gradient {
                GradientStop{position:1.0;color:"#0025d7"}
                GradientStop{position:0.6;color:"#00a3f3"}
                GradientStop{position:0.3;color:"#00d4f9"}
                GradientStop{position:0.0;color:"#00b9f5"}
            }
        }
    }
}
