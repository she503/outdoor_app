import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"

Rectangle {
    id: root

    signal sigQuite()
    Rectangle {
        id: rect_btns
        width: parent.width
        height: parent.height
        visible: true
        Row {
            width: parent.width * 0.8
            anchors.centerIn: parent
            spacing: parent.width * 0.1 / 5
            anchors.horizontalCenter: parent.horizontalCenter
            TLBtnWithPic {
                id: btn_start
                enabled: true
                width: rect_btns.width * 0.2
                height: rect_btns.height * 0.8

                visible: true
                btn_text: qsTr("START")
                font_size: width * 0.1
                img_source: "qrc:/res/pictures/mapping_start.png"

                onClicked: {
                    mapping_manager.setMappingCommand(1)
                    mapping_manager.recordMappingBag(1)
                    btn_start.visible = false
                    btn_stop.visible = true
                }
            }

            TLBtnWithPic {
                id: btn_stop
                enabled: true
                visible: false
                width: rect_btns.width * 0.2
                height: rect_btns.height * 0.8

                btn_text: qsTr("STOP")
                font_size: width * 0.1
                img_source: "qrc:/res/pictures/mapping_stop.png"

                onClicked: {
                    mapping_manager.setMappingCommand(3)
                    mapping_manager.recordMappingBag(2)

                    btn_start.visible = true
                    btn_stop.visible = false
                }
            }

            TLBtnWithPic {
                id: btn_reset
                enabled: true
                width: rect_btns.width * 0.2
                height: rect_btns.height * 0.8

                visible: true
                btn_text: qsTr("RESET")
                font_size: width * 0.1
                img_source: "qrc:/res/pictures/reset.png"

                onClicked: {
                    mapping_manager.setMappingCommand(2)
                }
            }

            TLBtnWithPic {
                id: btn_mapping
                enabled: true
                width: rect_btns.width * 0.2
                height: rect_btns.height * 0.8

                visible: true
                btn_text: qsTr("MAPPING")
                font_size: width * 0.1
                img_source: "qrc:/res/pictures/mapping.png"

                onClicked: {
                    mapping_manager.setMappingCommand(4)
                }
            }

            TLBtnWithPic {
                id: btn_quite
                enabled: true
                width: rect_btns.width * 0.2
                height: rect_btns.height * 0.8

                visible: true
                btn_text: qsTr("QUITE")
                font_size: width * 0.1
                img_source: "qrc:/res/ui/mapping/quite.png"

                onClicked: {
                    mapping_manager.setMappingCommand(2)
                    root.sigQuite()
                }
            }
        }
    }
    Rectangle {
        id: rect_messages
        width: parent.width
        height: parent.height
        visible: !rect_btns.visible
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
        Connections {
            target: mapping_manager
            onEmitmappingProgressInfo: {
                if(status === 4) {
                    txt_mapping.visible = true
                    rect_btns.visible = false
                } else {
                    txt_mapping.visible = false
                }
            }
            onEmitMappingFinish: {
                rect_messages.visible = false
                rect_btns.visible = true
            }
        }
    }
}
