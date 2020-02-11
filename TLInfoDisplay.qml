import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: root

    property alias img_source: img.source
    property alias model_name_text: model_name.text

    property alias info_text_color: info.color
    property alias info_text: info.text

    property bool isImage: false

    color: "transparent"

    Column {
        anchors.fill: parent
        Image {
            id: img
            height: parent.height * 0.7
            width: parent.width
            source: ""
            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            visible: root.isImage
        }
        Text {
            id: info
            text: "info"
            width: parent.width
            height: parent.height * 0.7
            visible: !root.isImage
            color: "black"
            font.pixelSize: height * 0.3
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: model_name
            text: "model_name"
            width: parent.width
            height: parent.height * 0.3
            visible: true
            color: "black"
            font.bold: true
            font.pixelSize: height * 0.5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

}
