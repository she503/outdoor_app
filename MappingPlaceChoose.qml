import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"

Rectangle {
    id: root
    color: "transparent"


    signal sigChooseBtnNumber(var num)
    Row {
        anchors.fill: parent
        spacing:  parent.width * 0.04
        topPadding: root.height * 0.05
        leftPadding: root.width * 0.08
        TLBtnWithPic {
            id: indoor
            width:  root.width * 0.4
            height:  root.height * 0.8
            is_top_bottom: true
            img_source: "qrc:/res/ui/mapping/indoor.png"
            backgroundDefaultColor: "white"
            btn_text: qsTr("indoor")
            font_color: "black"
            font_size: height * 0.2
            onClicked: {
                if (map_name.trim() === "") {
                    console.info("error map name")
                    return
                }
                mapping_manager.setIndoorOutdoor(1, root.map_name)
                root.sigChooseBtnNumber(1)
            }
        }
        TLBtnWithPic {
            id: outdoor
            width:  root.width * 0.4
            height:  root.height * 0.8
            is_top_bottom: true
            img_source: "qrc:/res/ui/mapping/outdoor.png"
            backgroundDefaultColor: "white"
            btn_text: qsTr("outdoor")
            font_color: "black"
            font_size: height * 0.2
            onClicked: {
                if (map_name.trim() === "") {
                    console.info("error map name")
                    return
                }
                mapping_manager.setIndoorOutdoor(2, root.map_name)
                root.sigChooseBtnNumber(2)
            }
        }

    }
}
