import QtQuick 2.6
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
Page {
    id:login_page

    property real side: Math.min(width,height) / 480
    property alias ip: edit_ip.text

    LinearGradient {
        anchors.fill:parent
        gradient: Gradient {
            GradientStop{ position: 0.0; color: "#4cb4e7";}
            GradientStop{ position: 0.3; color: "#91dbff";}
            GradientStop{ position: 0.6; color: "#b8e6fc";}
            GradientStop{ position: 0.8; color: "#fdf3c0";}
            GradientStop{ position: 1.0; color: "#ffee93";}
        }
    }

    //login Rectangle
    Rectangle {
        id: rec_login
        width: parent.width / 2
        height: parent.height / 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: side * 60
        radius: 20 * side
        color: "transparent"

        Column {
            anchors.centerIn: parent
            spacing: parent.height * 0.05

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/images/logo.png"
                    sourceSize { width: 100 * side; height: 100 * side;}
                }
            }

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter

                TextField {
                    id: edit_ip
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: ""
                    implicitWidth: 200 * side
                    implicitHeight: 40 * side
                    selectByMouse:true;
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: side * 18
                    placeholderText: qsTr("user name")//用户名
                    background: Rectangle {
                        anchors.fill: parent
                        id: rec_ip
                        radius: 8 * side
                        width: 200 * side
                        height: 40 * side
                        border.color: "#333"
                        border.width: 1
                        color: "white"
                    }
                }
            }

            RowLayout {
                id:row_port
                anchors.horizontalCenter: parent.horizontalCenter

                TextField {
                    id: edit_port
                    anchors.horizontalCenter: parent.horizontalCenter
                    selectByMouse:true
                    text: ""
                    implicitWidth: 200 * side
                    implicitHeight: 40 * side
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: side * 18
                    placeholderText: qsTr("password")//密码
                    background: Rectangle {
                        anchors.fill: parent
                        id: rec_port
                        radius: 8 * side
                        width: 200 * side
                        height: 40 * side
                        border.color: "#333"
                        border.width: 1
                        color: "white"
                    }
                }
            }

            Row{
                id:row_btn
                spacing: side * 20

                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id:btn_connect
                    flat: true
                    Text {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14 * side
                        text: qsTr("login")//登录
                    }
                    implicitWidth:side * 200
                    implicitHeight: side * 35
                    background: Rectangle{
                        border.width: btn_connect.activeFocus ? 2 * side : 1 * side
                        border.color: "#4cb4e7"
                        radius: 5 * side
                        color: "orange"
                    }
                    onClicked: {
                        is_link = true
                    }
                }
            }
        }
    }

}
