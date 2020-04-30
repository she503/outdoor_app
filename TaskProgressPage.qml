import QtQuick 2.0
import QtQuick.Controls 2.2
import "../homemade_components"

Rectangle {
    id: root

    color: "transparent"

    property string map_name: ""
    property string work_time: ""
    property string title_color: "black"
    property string font_color: "blue"

    signal sigBackBtnPress()
    Column{
        anchors.fill: parent
        TLInfoDisplayPage {
            id: rect_info
            width: parent.width
            height: parent.height * 0.4
        }
        WorkingBtns {
            id: working_btns
            width: parent.width
            height: parent.height * 0.1
            onSigBackBtnPress: {
                root.sigBackBtnPress()
            }
        }

        TaskInfo {
            id: task_info
            width: parent.width
            height: parent.height * 0.49
        }
    }
}
