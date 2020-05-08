import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"

Rectangle {
    id: root
    color: "transparent"
    signal sigChooseSuccess()
    Rectangle {
        id: choose_btns
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.4
        color: "transparent"
        Row {
            spacing: choose_btns.width * 0.1
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            TLButton {
                id: btn_indoor
                width: choose_btns.width * 0.4
                height: width
                btn_text: qsTr("indoor")
                font_size: parent.width * 0.1
                onClicked: {
                    mapping_manager.setIndoorOutdoor(1)
                    root.sigChooseSuccess()
                }
            }
            TLButton {
                id: btn_outdoor
                width: btn_indoor.width
                height: btn_indoor.width
                btn_text: qsTr("outdoor")
                font_size: parent.width * 0.1
                onClicked: {
                    mapping_manager.setIndoorOutdoor(2)
                    root.sigChooseSuccess()
                }
            }
        }
    }
}
