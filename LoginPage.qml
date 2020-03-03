import QtQuick 2.9
import QtQuick.Controls 2.2
import "CustomControl"
Item{
    id: root

    property real rate: Math.min(width, height) / 400
    property var user_level: ""
    property var user_name: ""

    signal successToLogin()
    //    Image {
    //        id: img_background
    //        source: "qrc:/res/pictures/login_background.jpg"
    //        width: parent.width
    //        height: parent.height
    //    }
    Rectangle {
        id: rect_logo
        width: parent.width
        height: parent.height * 0.5
        color: "transparent"
        Image {
            id: img_logo
            source: "qrc:/res/pictures/logo.png"
            width: 100 * root.rate
            height: 100 * root.rate
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 10
            }
        }
    }
    Rectangle {
        id: rect_login
        width: parent.width
        height: parent.height * 0.4
        color: "transparent"
        anchors {
            top: rect_logo.bottom
            topMargin: parent.height * 0.01
        }

        TLTextField {
            id: username
            width: rect_login.width * 0.4
            height: rect_login.height * 0.25
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            placeholderText: qsTr("enter your username.")
            pic_name: "qrc:/res/pictures/username.png"
            btn_radius: height * 0.1
            validator: RegExpValidator{regExp:/^.[A-Za-z0-9_]{0,11}$/}
        }

        TLTextField {
            id: password
            width: rect_login.width * 0.4
            height: rect_login.height * 0.25
            anchors {
                top: username.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
             btn_radius: height * 0.1
            placeholderText: qsTr("enter your password.")
            echoMode: TextInput.Password
            pic_name: "qrc:/res/pictures/password.png"
            validator: RegExpValidator{regExp:/^.[A-Za-z0-9]{0,16}$/}
        }

        TLButton {
            id: btn_ok
            width: rect_login.width * 0.4
            height: rect_login.height * 0.2
            btn_text: qsTr("OK")
            anchors {
                top: password.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            onClicked: {
                var emun_login_status = account_manager.checkLogin(username.text, password.text)
                if ( emun_login_status === 0) {
                    message_login_faild.title = qsTr("error")
                    login_label.text = qsTr("user name is not exit")
                    message_login_faild.open()
                } else if (emun_login_status === 1) {
                    message_login_faild.title = qsTr("error")
                    login_label.text = qsTr("error password")
                    message_login_faild.open()
                } else if (emun_login_status === 2) {
                    root.user_level = account_manager.getCurrentAccountLevel()
                    root.successToLogin()
                }
            }
//            onClicked: {
//                if (socket_manager.connectToHost("192.168.43.170", "32432")) {
//                    root.successToLogin()
//                } else {

//                }
//            }
        }
    }

    Dialog {
        id: message_login_faild
        width: root.width * 0.4
        height: root.height * 0.3
        x:(root.width - width) / 2
        y: (root.height - height) / 2

        title: qsTr("faild!")

        contentItem: TextArea {
            id: login_label
            text: qsTr("Please checkout username and password...")
        }
        standardButtons: Dialog.Yes
    }

}
