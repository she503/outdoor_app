import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"
Rectangle {

    id: root
    color: "transparent"
//    Image {
//        anchors.fill: parent
//        source: "qrc:/res/pictures/background_glow1.png"
//    }
//    Image {
//        anchors.fill: parent
//        source: "qrc:/res/ui/background/map.png"
//    }
    clip: true
    Rectangle {
        id: back_mappping
        anchors.fill: parent
        color: "transparent"
        radius:  height * 0.02
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width * 0.077
            topMargin: parent.height * 0.115
        }
        Rectangle {
            id: rect_message_show
            width: parent.width
            height: parent.height * 0.6
//            anchors {
//                top: parent.top
//                topMargin: parent.height * 0.05
//                left: parent.left
//                leftMargin: parent.width * 0.05
//            }
            border {
                width: 2
                color: "green"
            }
            radius: 10
            clip: true
            color: Qt.rgba(255, 255, 255, 0.5)
            MappingMessage {
                id: mapping_message
                anchors.fill: parent
                clip: true
            }
        }

    }

    Connections {
        target: mapping_manager
        onEmitMappingCommandInfo: {
            if (success) {
                btn_start.visible = false
                rect_btns_2.visible = true
//                if (rect_btns_2.command_id === 5 && message === "Have no data") {
//                } else {
//                    rect_btns_2.setVisible(true)
//                }
            } else {

            }
            mapping_message.setMessage(success, rect_btns_2.command_id, message)
        }
    }
}
