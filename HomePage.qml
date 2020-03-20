import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import "CustomControl"

Rectangle {
    id: root
//    property real ratio: Math.sqrt(Math.min(rect_bottom.width / 5, rect_bottom.height)) * 0.1

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

    //    Rectangle {
//        id: rect_bottom
//        width: parent.width
//        height: parent.height * 0.35
//        anchors.top: rect_info_display.bottom
//        color: "transparent"
//        Rectangle {
//            id: rec_machine_state
//            width: rect_bottom.width * 0.3
//            height: rect_bottom.height / 2
//            color: "transparent"
//            Image {
//                id: pic_ok
//                width: 50 * rate * ratio
//                height: 50 * rate * ratio
//                visible: !has_error
//                source: "qrc:/res/pictures/finish.png"
//                anchors.centerIn: parent
//                fillMode: Image.PreserveAspectFit
//            }
//            Image {
//                id: pic_warn
//                width: 50 * rate * ratio
//                height: 50 * rate * ratio
//                visible: has_error
//                source: "qrc:/res/pictures/warn.png"
//                anchors.centerIn: parent
//                fillMode: Image.PreserveAspectFit
//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
//                        dialog_machine_warn.open()
//                    }
//                }
//            }
//        }
//        DelayButton {
//            id: delayButton
//            width:Math.min(parent.height, Math.min(parent.width, parent.height) * rate * ratio)
//            height: width
//            x: (parent.width - width) / 2
//            y: (parent.height - height) / 2
//            delay: 1000
//            text: qsTr("start")
//            enabled: !has_error
//            style: DelayButtonStyle {

//                progressBarGradient: Gradient {
//                    GradientStop { position: 0.0; color: "green" }
//                    GradientStop { position: 0.99; color: "green" }
//                    GradientStop { position: 1.0; color: "green" }
//                }
//                progressBarDropShadowColor: "green"
//            }
//        }
//        Rectangle {
//            width: rect_bottom.width * 0.3
//            height: rect_bottom.height / 2
//            color: "transparent"
//            anchors {
//                left: parent.left
//                bottom: parent.bottom
//            }
//            Image {
//                width: 50 * rate * ratio
//                height: 50 * rate * ratio
//                anchors.centerIn: parent
//                source: "qrc:/res/pictures/eye.png"
//                fillMode: Image.PreserveAspectFit
//                horizontalAlignment: Image.AlignHCenter
//                verticalAlignment: Image.AlignVCenter
//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
////                        turn_task_page = true
//                    }
//                }
//            }
//        }
//    }
//    TLDialog {
//        id: dialog_machine_warn
//        width: root.width * 0.6
//        height: root.height * 0.3
//        x: (root.width - width) / 2
//        y: (root.height - height) / 2
//        dia_title: qsTr("Warn!")
//        dia_info_text: qsTr("Machine malfunction")
//        is_single_btn: true
//        onOkClicked: {
//            dialog_machine_warn.close()
//        }
//    }


}
