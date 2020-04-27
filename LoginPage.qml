import QtQuick 2.9
import QtQuick.Controls 2.2
import "CustomControl"
Item{
    id: root

    signal successToLogin()

    property real _login_faild_time: 0
    property string _default_test_user: "root"

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
                height: parent.height * 0.2
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
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: lab_user.right
                        leftMargin: parent.width * 0.05
                    }
                    text: root._default_test_user
                    placeholderText: qsTr("enter your username.")
                    pic_name: "qrc:/res/pictures/username.png"
                    btn_radius: height * 0.1
                    validator: RegExpValidator{regExp:/^.[A-Za-z0-9_]{0,11}$/}
                }
            }
            Rectangle {
                id: rect_pwd
                width: parent.width * 0.95
                height: parent.height * 0.2
                color:"transparent"
                anchors{
                    top: rect_username.bottom
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
                    anchors {
                        left: lab_pwd.right
                        leftMargin: parent.width * 0.05
                        verticalCenter: parent.verticalCenter

                    }
                    text: root._default_test_user
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
                    topMargin: parent.height * 0.08

                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width * 0.05

                }
                onClicked: {
                    if (root._login_faild_time < 3 ) {
                        account_manager.accountLogin(username.text, password.text)
                        ++ root._login_faild_time
                    } else {
                        message_login_faild.dia_title = qsTr("login failed!")
                        message_login_faild.dia_content = qsTr("Multiple login failures,please contact the administrator!")
                        message_login_faild.open()
                    }
                }
            }
        }
    }

    Connections {
        target: account_manager
        onEmitLoginRst: {
            if (status === 0) {
                message_login_faild.dia_title = qsTr("Error")
                message_login_faild.dia_content = qsTr("Account or password is wrong!")
                message_login_faild.open()
            } else if (status === 1) {
                root.successToLogin()
                root._login_faild_time = 0
            }
        }
    }

    TLDialog {
        id: message_login_faild
        height: parent.height * 0.5
        width: height * 1.5
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("login error!")
        status: 0
        cancel_text: qsTr("OK")

        onCancelClicked: {
            message_login_faild.close()
        }
    }

}
