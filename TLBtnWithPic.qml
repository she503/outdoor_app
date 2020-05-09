import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    property color backgroundDefaultColor: "#3498DB"
    property color backgroundPressedColor: Qt.darker(backgroundDefaultColor, 1.2)
    property string btn_text: ""
    property real font_size: root.height * 0.8
    property string img_source: ""

    signal clicked()
    Image {
        id: img
        source: root.img_source
        width: parent.width * 0.4
        height: parent.height
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }

    Text {
        text: btn_text
        color: "white"
        font{
            pixelSize: font_size
            family: "Arial"
            weight: Font.Thin
        }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        anchors {
            left: img.right
            leftMargin: parent.width * 0.01
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked();
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

