import QtQuick 2.9
import QtQuick.Controls 2.2
import "CustomControl"
Item{
    id: root

    property var user_nomal
    property var user_admin
    property real rate: Math.min(width, height) / 400
    property var user_level: ""
    property var user_name: ""
    signal sendAccountInfo(var user_level, var user_name)

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

        Connections {
            target: user_manage
            onEmitALLUserAccount: {
                root.user_nomal = nomal
                root.user_admin = admin

//                for(var key in nomal)
            }
        }

        function judgeLogin() {
            var normal_user = root.user_nomal

            var admin = root.user_admin

            var user = username.text
            var pwd = password.text

            for (var key in normal_user) {
                if (key === user && pwd === normal_user[key]) {
                    root.user_level = "normal"
                    root.user_name = key
                    return true
                } else {
                    continue
                }
            }

            for (var key in admin) {
                if (key === user && pwd === admin[key]) {
                    root.user_level = "admin"
                    root.user_name = key
                    return true
                } else {
                    continue
                }
            }
            message_login_faild.open()
            return false
        }
        TLTextField {
            id: username
            width: rect_login.width * 0.4
            height: rect_login.height * 0.2
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            placeholderText: qsTr("enter your username.")
            pic_name: "qrc:/res/pictures/username.png"
            btn_radius: height * 0.1
        }

        TLTextField {
            id: password
            width: rect_login.width * 0.4
            height: rect_login.height * 0.2
            anchors {
                top: username.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
             btn_radius: height * 0.1
            placeholderText: qsTr("enter your password.")
            echoMode: TextInput.Password
            pic_name: "qrc:/res/pictures/password.png"
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
                if (rect_login.judgeLogin()) {
                    root.sendAccountInfo(root.user_level, root.user_name)
                }
            }
        }
    }

    Dialog {
        id: message_login_faild
        width: root.width * 0.4
        height: root.height * 0.3
        x:(root.width - width) / 2
        y: (root.height - height) / 2

        title: qsTr("faild!")

        contentItem: Label {
            text: qsTr("Please checkout username and password...")
        }
        standardButtons: Dialog.Yes
    }

}
