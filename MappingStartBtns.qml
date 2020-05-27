import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"

Rectangle {
    id: root
    Rectangle {
        id: rect_btns
        anchors.fill: parent

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
                mapping_manager.setMappingCommand(1)
            }
        }
        Rectangle {
            id: rect_btns_2
            visible: !btn_start.visible
            width: parent.width * 0.9
            height: parent.height * 0.8
            anchors.centerIn: parent
            color: "transparent"

            Connections {
                target: mapping_manager
                onEmitmappingProgressInfo: {
                    if(status === 4) {
                        txt_mapping.visible = true
                        btns.visible = false
                    } else {
                        txt_mapping.visible = false

                    }
                }
            }

            Text {
                id: txt_mapping
                visible: false
                width: parent.width
                height: parent.height
                font.pixelSize: height * 0.2
                color: "green"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Please waite for a minute...")
            }


            property int command_id: 1
            function setVisible(flag) {
                btn_save_key.visible = flag
                btn_reset.visible = flag
                btn_stop.visible = flag
                btn_back.visible = !flag
                btn_mapping.visible = flag
            }

            function setBtnDisableStyle() {
                btn_reset.backgroundDefaultColor = "#778899"
                btn_reset.btn_enable = false

                btn_save_key.backgroundDefaultColor = "#778899"
                btn_save_key.btn_enable = false

                btn_stop.backgroundDefaultColor = "#778899"
                btn_stop.btn_enable = false

            }


            Row {
                id: btns
                spacing: parent.width * 0.1 / 4
                anchors.centerIn: parent
                TLBtnWithPic {
                    id: btn_back
                    enabled: true
                    width: rect_btns_2.width * 0.2
                    height: rect_btns_2.height * 0.5
                    visible: false
                    btn_text: qsTr("BACK")
                    font_size: width * 0.1
                    img_source: "qrc:/res/pictures/back_style2.png"
                    onClicked: {
                        rect_btns_2.setVisible(true)
                    }
                }
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
                        rect_btns_2.command_id = 3
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
                        mapping_manager.setMappingCommand(2)
                        rect_btns_2.command_id = 2
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
                        mapping_manager.setMappingCommand(4)
                        rect_btns_2.command_id = 4
//                        rect_btns_2.setBtnDisableStyle()
                    }
                }
            }

        }
    }
    Connections {
        target: mapping_manager
        onEmitMappingCommandInfo: {
            if (success) {
                btn_start.visible = false
                rect_btns_2.visible = true
            } else {

            }
            mapping_message.setMessage(success, rect_btns_2.command_id, message)
        }
    }


}
