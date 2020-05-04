import QtQuick 2.9
import QtQuick.Controls 2.2
import "homemade_components"
Rectangle{
    id: root

    signal successToConnect()
    Text {
        id: faild_text
        text: qsTr("faild to connect server!!!")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        width: parent.width * 0.5
        height: parent.height * 0.3
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.1
        font.bold: true
        color: "red"
    }
    Rectangle {
        id: connect_agin
        width: parent.width * 0.8
        height: parent.height * 0.8
        anchors.centerIn: parent
        z: 2
        visible: false

        TLTextField {
            id: ip
            width: parent.width * 0.8
            height: parent.height * 0.2
            anchors {
                verticalCenter: parent.verticalCenter

                horizontalCenter: parent.horizontalCenter
            }
            text: "192.168.."
            placeholderText: qsTr("enter IP.")
            pic_name: "qrc:/res/pictures/username.png"
            btn_radius: height * 0.1
        }
        TLButton {
            width: parent.width * 0.8
            height: parent.height * 0.2
            anchors.top: ip.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            btn_text:"connect"
            onClicked: {
                if(socket_manager.connectToServer(ip.text)) {
                    root.successToConnect()
                } else {
                    faild.open()
                }
            }
        }
    }


    TLButton {
        width: parent.width * 0.2
        height: parent.height * 0.2
        anchors.top: faild_text.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        btn_text:"OK"
        onClicked: {
            Qt.quit()
        }
    }

    Rectangle {
//        id: connect_agin
        width: parent.width * 0.2
        height: parent.height * 0.2
        color: Qt.rgba(255,255,255,0)
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        property real time: 0
        MouseArea {
            anchors.fill: parent
            onClicked: {
                ++parent.time;
                if(parent.time >= 3) {
                    faild_text.visible = false
                    connect_agin.visible = true
                }
            }
        }
    }

    TLMessageBox {
        id: faild;
        dia_type: 0
        x: 200
        y: 100
        dia_title: qsTr("faild")
        dia_text: qsTr("faild to connect")
    }

}
