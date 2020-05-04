import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QtGraphicalEffects 1.0
Rectangle {
    id: root
    radius: root.btn_radius
    color: root.enabled ? "transparent" : "#F4F6F6"
    border.color: root.enabled ? root.checkedColor : "#D5DBDB"
    border.width: 2
    opacity: root.enabled ? 1 : 0.7

    property color checkedColor: "#2B99B9"
    property string pic_name: ""
    property real btn_radius: 0
    property real font_size: height * 0.5

    property alias placeholderText: text_field.placeholderText
    property alias text: text_field.text
    property alias validator: text_field.validator
    property alias echoMode: text_field.echoMode
    signal doubleClicked()

    layer.enabled: root.focus
    layer.effect: DropShadow {
        id: dropShadow
        transparentBorder: true
        color: root.checkedColor
        samples: parent.width * 0.01
    }
    Image {
        id: pic_login
        asynchronous: true
        smooth: true
        width: height
        height: parent.height * 0.6
        anchors {
            left: parent.left
            leftMargin: parent.width * 0.04
            verticalCenter: parent.verticalCenter
        }
        source: root.pic_name
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
    }
    TextField {
        id: text_field
        width: parent.width * 0.7
        height: parent.height
        font.family: "Arial"
        font.pixelSize: root.font_size
        anchors.left: pic_login.right
        style: TextFieldStyle {
            textColor: "black"
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
            passwordCharacter: "*"

        }
    }
}

