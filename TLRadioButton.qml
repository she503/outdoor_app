import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

RadioButton {
    id: root
    width: parent.width * 0.4
    height: parent.height

    property string text_name: qsTr("admin")
    property string bord_color: "#87CEFA"
    property string center_color: "#00BFFF"

    indicator:  Rectangle {
        id: rect_radio_btn
        width: parent.height * 0.8
        height: width
        radius: height / 2
        border.width: 1
        border.color: root.bord_color
        anchors.verticalCenter: parent.verticalCenter
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color: root.bord_color
            samples: 20
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: width
            radius: width / 2
            color: center_color
            visible: root.checked
        }
    }
    contentItem: Text {
        anchors.left: rect_radio_btn.right
        anchors.leftMargin: 2
        font.pixelSize: parent.height * 0.8
        text: root.text_name
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
}
