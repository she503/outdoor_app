import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import "./CustomControl"

Rectangle {
    id: root
    color: "transparent"
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
            id: rect_look
            width: parent.width * 0.3
            height: parent.height
            color: "transparent"
            Image {
                id: btn_eye
                width: parent.width * 0.3
                height: width * 0.628
                source: "qrc:/res/pictures/eye.png"
                anchors{
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: parent.height * 0.1
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stack_view.replace(task_settings_page)
                    }
                }
            }
        }

        Image {
            id: btn_start_stop
            width: parent.width * 0.4 > parent.height * 0.8 ? parent.height * 0.8 : parent.width * 0.4
            height: width
            anchors.centerIn: parent
            source: "qrc:/res/pictures/start.png"
        }

        Rectangle {
            id: rect_progress
            width: parent.width * 0.3
            height: parent.height
            anchors {
                right: parent.right
            }
            color: "transparent"
            Image {
                id: image_progress
                width: parent.width * 0.6
                height: width * 0.383
                source: "qrc:/res/pictures/task_progress.png"
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    bottomMargin: parent.height * 0.1
                }
             TLProgressBar {
                 width: parent.width * 0.7
                 height: parent.height * 0.1
                 anchors {
                     horizontalCenter: parent.horizontalCenter
                     top: parent.top
                     topMargin: parent.height * 0.7
                 }
             }
            }
        }
    }
    TLDialog {
        id: dialog_machine_warn
        width: root.width * 0.6
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Warn!")
        dia_image_source: "qrc:/res/pictures/sad.png"
        is_single_btn: true
        onOkClicked: {
            dialog_machine_warn.close()
        }
    }
}
