import QtQuick 2.9
import QtQuick.Controls 2.2
import "CustomControl"
Item{
    id: root

    property real rate: Math.min(width, height) / 400
    property var user_level: 0
    property var user_name: ""

    signal successToLogin()

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
            width: 200 * root.rate
            height: 75 * root.rate
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
            text: qsTr("中振同辂")
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
                    topMargin: height * 0.01
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
                btn_text: qsTr("OK")
                anchors {
                    top: rect_pwd.bottom
                    topMargin: parent.height * 0.08

                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width * 0.03

                }
                onClicked: {
                    var emun_login_status = account_manager.checkLogin(username.text, password.text)
                    if ( emun_login_status === 0) {
//                        message_login_faild.title = qsTr("error")
//                        login_label.text = qsTr("user name is not exit")
                        message_login_faild.dia_title = qsTr("user name is not exit")
                        message_login_faild.open()
                    } else if (emun_login_status === 1) {
//                        message_login_faild.title = qsTr("error")
//                        login_label.text = qsTr("error password")
                        message_login_faild.dia_title = qsTr("error password")
                        message_login_faild.open()
                    } else if (emun_login_status === 2) {
                        root.user_level = account_manager.getCurrentAccountLevel()
                        root.successToLogin()
                    }
                }
            }
        }
    }

//    Dialog {
//        id: message_login_faild
//        width: root.width * 0.4
//        height: root.height * 0.3
//        x:(root.width - width) / 2
//        y: (root.height - height) / 2

//        title: qsTr("faild!")

//        contentItem: TextArea {
//            id: login_label
//            text: qsTr("Please checkout username and password...")
//        }
//        standardButtons: Dialog.Yes
//    }
    TLDialog {
        id: message_login_faild
        width: root.width * 0.4
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("error!")
        dia_image_source: "qrc:/res/pictures/sad.png"
        is_single_btn: true
        onOkClicked: {
            message_login_faild.close()
        }
    }

}
