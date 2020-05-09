import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"
Rectangle {

    id: root
    color: "transparent"
    Image {
        anchors.fill: parent
        source: "qrc:/res/pictures/background_glow1.png"
    }
    Rectangle {
        id: rect_message_show
        width: parent.width * 0.9
        height: parent.height * 0.6
        anchors {
            top: parent.top
            topMargin: parent.height * 0.05
            left: parent.left
            leftMargin: parent.width * 0.05
        }
        border {
            width: 2
            color: "green"
        }
        radius: 10
        color: Qt.rgba(255, 255, 255, 0.5)
    }
    Rectangle {
        id: rect_btns
        width: parent.width * 0.9
        height: parent.height * 0.3
        anchors.top: rect_message_show.bottom
        anchors.topMargin: parent.height * 0.01
        anchors {
            top: rect_message_show.bottom
            topMargin: parent.height * 0.01
            left: parent.left
            leftMargin: parent.width * 0.05
        }
        color: Qt.rgba(255, 255, 255, 0.5)
        border {
            width: 2
            color: "yellow"
        }
        radius: 10

        TLBtnWithPic {
            id: btn_start
            enabled: true
            width: parent.width * 0.4
            height: parent.height * 0.5
            anchors.right: parent.right
            anchors.rightMargin: 5
            visible: true
            btn_text: qsTr("START")
            img_source: "qrc:/res/pictures/mapping_start.png"
            onClicked: {
                console.info("11111111")
            }
        }
        Button {
            id: btn_stop
            width: parent.width * 0.3
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin: 5
            visible: false
            Text{
                id: text_stop
                anchors.fill: parent
                font.pixelSize: height * 0.5
                text: "\uf04d" + qsTr("stop")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "red"
            }
            onClicked: {

            }
        }
    }
}
