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
    signal sigWorkDown()
//    property Dialog work_done_widget: WorkDone {

//        x: (parent.parent.width - width ) /2;
//        y: (parent.parent.height - height) / 2
//    }
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
            onSigWorkDown: {
                root.sigWorkDown()//work_done_widget.open()
            }
        }

        TaskInfo {
            id: task_info
            width: parent.width
            height: parent.height * 0.49
        }
    }
}
