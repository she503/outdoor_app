import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root
    color: "transparent"
    property real pos_x: 0
    property real pos_y: 0
    property real pos_theta: 0
    Image {
        id: img
        anchors.fill: parent
        source: "qrc:/res/ui/task/qidian_no.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        MouseArea {
            anchors.fill: parent

        }
    }
}
