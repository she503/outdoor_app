import QtQuick 2.9
import QtQuick.Controls 2.2
import "CustomControl"
Item{
    id: root

//    property real rate: Math.min(width, height) / 400
    property var current_login_password: password.text
    property var user_level: 0
    property string test_text: "root"
    signal successToLogin()
    property alias connect_fail_view: connect_fail_view

    Rectangle {
        id: connect_fail_view
        color: "white"
        visible: false
        Rectangle {
            width: 330
            height: 220
            anchors.centerIn: parent
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/error_background.png"
                fillMode: Image.PreserveAspectFit
                Text {
                    width: parent.width * 0.5
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("app cannot to connect server, please check your wifi and IP!")
                    color: "black"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height * 0.1
                    wrapMode: Text.Wrap
                }
                TLButton {
                    width: parent.width * 0.2
                    height: parent.height * 0.1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.08
                    btn_text: qsTr("OK")
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                Qt.quit()
            }
        }
    }
    Rectangle {
        id: rec_disconnect
        color: "white"
        visible: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                Qt.quit()
            }
        }

    }

    FontLoader {
        id: font_hanzhen;
        source: "qrc:/res/font/hanzhen.ttf"
    }
    Image {
        id: img_background
        source: "qrc:/res/pictures/login_background.png"
        width: parent.width
        height: parent.height
    }
    Rectangle {
        id: rect_logo
        width: parent.width
        height: parent.height * 0.25
        color: "transparent"
        Image {
            id: img_logo
            source: "qrc:/res/pictures/logo.png"
            width: parent.width
            height: parent.height * 0.5
            fillMode: Image.PreserveAspectFit
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
        }
    }
    Rectangle {
        id: rect_login
        width: parent.width * 0.4
        height: parent.height * 0.4
        color: "transparent"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        Label {
            id: lab_name
            width: rect_login.width
            height: rect_login.height * 0.15
            text: qsTr("tonglu")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pixelSize: height * 0.5
            font.family: font_hanzhen.name
            anchors{
                top: parent.top
                topMargin: parent.height * 0.18
            }
            color: "#004e8c"
        }

        Rectangle {
            id: rect_main
            width: parent.width * 0.8
            height: parent.height * 0.8
            anchors{
                top:parent.top
                topMargin: height * 0.5
                horizontalCenter: parent.horizontalCenter
            }
            color: "transparent"


            Rectangle {
                id: rect_username
                width: parent.width * 0.95
                height: parent.height * 0.25
                color:"transparent"
                anchors{
                    left: parent.left
                    leftMargin: width * 0.05
                }
                Label {
                    id: lab_user
                    width: parent.width * 0.3
                    height: parent.height
                    text: qsTr("username")
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height * 0.4
                    anchors{
                        top: parent.top
                    }
                    color: "#006abe"
                }
                TLTextField {
                    id: username
                    width: parent.width * 0.55
                    height: parent.height * 0.8
                    text: root.test_text
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: lab_user.right
                        leftMargin: parent.width * 0.05
                    }
                    placeholderText: qsTr("enter your username.")
                    pic_name: "qrc:/res/pictures/username.png"
                    btn_radius: height * 0.1
                    validator: RegExpValidator{regExp:/^.[A-Za-z0-9_]{0,11}$/}
                }
            }
            Rectangle {
                id: rect_pwd
                width: parent.width * 0.95
                height: parent.height * 0.25
                color:"transparent"
                anchors{
                    top: rect_username.bottom
//                    topMargin: height * 0.01
                    left: parent.left
                    leftMargin: width * 0.05
                }
                Label {
                    id: lab_pwd
                    width: parent.width * 0.3
                    height: parent.height
                    text: qsTr("PWD")
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height * 0.4
                    anchors{
                        top: parent.top
                    }
                    color: "#006abe"
                }
                TLTextField {
                    id: password
                    width: parent.width * 0.55
                    height: parent.height * 0.8
                    text: root.test_text
                    anchors {
                        left: lab_pwd.right
                        leftMargin: parent.width * 0.05
                        verticalCenter: parent.verticalCenter

                    }
                    btn_radius: height * 0.1
                    placeholderText: qsTr("enter your password.")
                    echoMode: TextInput.Password
                    pic_name: "qrc:/res/pictures/password.png"
                    validator: RegExpValidator{regExp:/^.[A-Za-z0-9]{0,16}$/}
                }
            }

            TLButton {
                id: btn_ok
                width: rect_login.width * 0.3
                height: rect_login.height * 0.1
                btn_text: qsTr("login")//登录
                anchors {
                    top: rect_pwd.bottom
                    topMargin: parent.height * 0.04

                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width * 0.03

                }
                onClicked: {
                        account_manager.accountLogin(username.text, password.text)
                }
            }
        }
    }

    Connections {
        target: account_manager
        onEmitCheckOutLogin: {
            if (status === 0) {
                message_login_faild.dia_title = qsTr("Error")
                message_login_faild.dia_content = message
                message_login_faild.open()
            } else if (status === 1) {
                root.successToLogin()
            }
        }

    }

    Connections {
        target: socket_manager
        onEmitFaildToLogin: {
//            message_login_faild.dia_content = message
//            message_login_faild.open()
        }
        onAppDisconnected: {
            message_login_faild.dia_content = message
            message_login_faild.open()
            stack_view_main.replace(rec_disconnect)
        }
    }

//    Connections {
//        target: socket_manager

//    }

    TLDialog {
        id: message_login_faild
        width: 300
        height: 200
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("connect error!")
        status: 0
        cancel_text: qsTr("OK")

        onCancelClicked: {
            Qt.quit()
        }
    }

}
