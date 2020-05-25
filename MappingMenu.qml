import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"

Rectangle {
    id: root

    color: "transparent"

    signal sigChooseBtnNumber(var num)  // 0:nomaml 1:indoor 2:outdoor 3:to_usb 4:to_computer
    property alias map_name: txt_edit_map_name.text
    Rectangle {
        id: rect_map_name
        width: parent.width
        height: parent.height * 0.1
        color: "transparent"
        Row {
            anchors.fill: parent
            Text {
                width: parent.width * 0.3
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: qsTr("map name: ")
                font.bold: true
                font.pixelSize: height * 0.5
                color: "yellow"
            }
            TextField {
                id: txt_edit_map_name
                width: parent.width * 0.5
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: "white"
                placeholderText: qsTr("please inter the map name")
                font.pixelSize: height * 0.5
                background:  Rectangle{
                    color: "red"
                    width: parent.width
                    height: parent.height * 0.01
                    anchors.bottom: parent.bottom
                }
                validator: RegExpValidator{regExp:/^.[A-Za-z0-9_]{0,11}$/}
            }
        }
    }

    MappingPlaceChoose {
        id: map_choose
        width: root.width
        height: ( parent.height  - rect_map_name.height ) / 2 + root.height * 0.05
        anchors.top: rect_map_name.bottom

        onSigChooseBtnNumber: {
            root.sigChooseBtnNumber(num)
        }
    }

    Grid {
        width: parent.width
        height: parent.height - rect_map_name.height - map_choose.height
        anchors.top: map_choose.bottom
        rows: 1
        columns: 2
        columnSpacing: root.height * 0.05
        rowSpacing: root.width * 0.05
//        topPadding: root.height * 0.05
        leftPadding: root.width * 0.08

        TLBtnWithPic {
            id: to_usb
            width:  root.width * 0.4
            height:  root.height * 0.4
            is_top_bottom: true
            img_source: "qrc:/res/ui/mapping/data_to_USB.png"
            backgroundDefaultColor: "white"
            btn_text: qsTr("to_usb")
            font_color: "black"
            font_size: height * 0.2
            onClicked: {
                if (map_name.trim() === "") {
                    console.info("error map name")
                    return
                }
                root.sigChooseBtnNumber(3)
                mapping_manager.transferMappingData(1, root.map_name)
            }
        }
        TLBtnWithPic {
            id: to_computer
            width:  root.width * 0.4
            height:  root.height * 0.4
            is_top_bottom: true
            img_source: "qrc:/res/ui/mapping/data_to_computer.png"
            backgroundDefaultColor: "white"
            btn_text: qsTr("to_computer")
            font_color: "black"
            font_size: height * 0.2
            onClicked: {
                if (map_name.trim() === "") {
                    console.info("error map name")
                    return
                }
                root.sigChooseBtnNumber(4)
                mapping_manager.transferMappingData(2, root.map_name)
            }
        }
    }
}
