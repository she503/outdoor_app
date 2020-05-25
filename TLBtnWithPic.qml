import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    property color backgroundDefaultColor: "#3498DB"
    property color backgroundPressedColor: Qt.darker(backgroundDefaultColor, 1.2)
    property string btn_text: ""
    property real font_size: root.height * 0.8
    property string font_color: "white"
    property string img_source: ""
    property bool btn_enable: true
    property bool is_top_bottom: false

    signal clicked()
    Image {
        id: img_top
        visible: !root.is_top_bottom
        source: root.img_source
        width: parent.width * 0.4
        height: parent.height * 0.8
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: btn_text
        visible: !root.is_top_bottom
        color: root.font_color
        width: parent.width * 0.59
        height: parent.height
        font{
            pixelSize: font_size
            family: "Arial"
            weight: Font.Thin
        }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        anchors {
            left: img_top.right
            leftMargin: parent.width * 0.05
        }
    }

    Image {
        id: img_bottom
        visible: root.is_top_bottom
        source: root.img_source
        width: parent.width
        height: parent.height * 0.7
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }

    Text {
        text: btn_text
        visible: root.is_top_bottom
        color: root.font_color
        width: parent.width
        height: parent.height * 0.3
        font{
            pixelSize: font_size
            family: "Arial"
            weight: Font.Thin
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        elide: Text.ElideRight
        anchors {
            top: img_bottom.bottom
            left: parent.left
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (root.btn_enable) {
            root.clicked();
            }
        }
    }

    implicitWidth: 83
    implicitHeight: 37
    color: root.down ? root.backgroundPressedColor : root.backgroundDefaultColor
    radius: 3
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        color: root.down ? root.backgroundPressedColor : root.backgroundDefaultColor
        samples: 20
    }

}

