import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Button {
    id: btn_ok
    property color backgroundDefaultColor: "#3498DB"
    property color backgroundPressedColor: Qt.darker(backgroundDefaultColor, 1.2)
    property string btn_text: ""
    property real font_size: btn_ok.height * 0.8

    contentItem: Text {
        text: btn_text
        color: "white"
        font.pixelSize: font_size
        font.family: "Arial"
        font.weight: Font.Thin
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 83
        implicitHeight: 37
        color: btn_ok.down ? btn_ok.backgroundPressedColor : btn_ok.backgroundDefaultColor
        radius: 3
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color: btn_ok.down ? btn_ok.backgroundPressedColor : btn_ok.backgroundDefaultColor
            samples: 20
        }
    }
}

