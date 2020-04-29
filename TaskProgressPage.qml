import QtQuick 2.0
import QtQuick.Controls 2.2
import "homemade_components"

Rectangle {
    id: root

    color: "transparent"

    property string map_name: ""
    property string work_time: ""
    property string title_color: "black"
    property string font_color: "blue"

    signal sigBackBtnPress()

    Connections {
        target: ros_message_manager
        onUpdateTaskProcessInfo: {
            text_progress.text = "" + progress + " %";
            if (progress >= 100) {
                task_auto_achived.open()
            }
        }
    }

    Column{
        anchors.fill: parent
        Rectangle {
            id: rect_info
            width: parent.width
            height: parent.height * 0.4
            color: "transparent"
            TLInfoDisplayPage {
                id: tl_info_display
                anchors.fill: parent
            }
        }
    }

    TLDialog {
        id: pause_stop_message
        height: parent.height * 0.5
        width: height * 1.5
        cancel: true
    }
}
