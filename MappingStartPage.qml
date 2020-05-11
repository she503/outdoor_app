import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"
Rectangle {

    id: root
    color: "transparent"
    Image {
        anchors.fill: parent
        source: "qrc:/res/pictures/background_glow1.png"
    }
    Rectangle {
        id: rect_message_show
        width: parent.width * 0.9
        height: parent.height * 0.6
        anchors {
            top: parent.top
            topMargin: parent.height * 0.05
            left: parent.left
            leftMargin: parent.width * 0.05
        }
        border {
            width: 2
            color: "green"
        }
        radius: 10
        color: Qt.rgba(255, 255, 255, 0.5)
    }
    Rectangle {
        id: rect_btns
        width: parent.width * 0.9
        height: parent.height * 0.3
        anchors.top: rect_message_show.bottom
        anchors.topMargin: parent.height * 0.01
        anchors {
            top: rect_message_show.bottom
            topMargin: parent.height * 0.01
            left: parent.left
            leftMargin: parent.width * 0.05
        }
        color: Qt.rgba(255, 255, 255, 0.5)
        border {
            width: 2
            color: "yellow"
        }
        radius: 10

        TLBtnWithPic {
            id: btn_start
            enabled: true
            width: parent.width * 0.4
            height: parent.height * 0.5

            visible: true
            btn_text: qsTr("START")
            font_size: width * 0.1
            img_source: "qrc:/res/pictures/mapping_start.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                mapping_manager.setMappingCommand(2)
            }
        }
        Rectangle {
            id: rect_btns_2
            visible: !btn_start.visible
            width: parent.width * 0.9
            height: parent.height * 0.8
            anchors.centerIn: parent
            color: "transparent"
            Row {
                spacing: parent.width * 0.1 / 4
                anchors.centerIn: parent
                TLBtnWithPic {
                    id: btn_stop
                    enabled: true
                    width: rect_btns_2.width * 0.2
                    height: rect_btns_2.height * 0.5
                    visible: true
                    btn_text: qsTr("STOP")
                    font_size: width * 0.1
                    img_source: "qrc:/res/pictures/mapping_stop.png"
                    onClicked: {
                        mapping_manager.setMappingCommand(3)
                    }
                }
                TLBtnWithPic {
                    id: btn_reset
                    enabled: true
                    width: rect_btns_2.width * 0.2
                    height: rect_btns_2.height * 0.5
                    visible: true
                    btn_text: qsTr("RESET")
                    font_size: width * 0.1
                    img_source: "qrc:/res/pictures/reset.png"
                    onClicked: {
                        mapping_manager.setMappingCommand(1)
                    }
                }
                TLBtnWithPic {
                    id: btn_save_key
                    enabled: true
                    width: rect_btns_2.width * 0.2
                    height: rect_btns_2.height * 0.5
                    visible: true
                    btn_text: qsTr("KEY")
                    font_size: width * 0.1
                    img_source: "qrc:/res/pictures/key.png"
                    onClicked: {
                        mapping_manager.setMappingCommand(4)
                    }
                }
                TLBtnWithPic {
                    id: btn_mapping
                    enabled: true
                    width: rect_btns_2.width * 0.2
                    height: rect_btns_2.height * 0.5
                    visible: true
                    btn_text: qsTr("MAPPING")
                    font_size: width * 0.1
                    img_source: "qrc:/res/pictures/mapping.png"
                    onClicked: {
                        mapping_manager.setMappingCommand(5)
                    }
                }
            }
        }
    }
    Connections {
        target: mapping_manager
        onEmitMappingCommandInfo: {
            if (success) {
                console.info(message)
                btn_start.visible = false
                rect_btns_2.visible = true
            }
        }
    }
}
