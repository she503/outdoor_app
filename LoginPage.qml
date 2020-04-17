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
    signal connectFail()
    property alias connect_fail_item: connect_fail_item
    property alias rec_disconnect: rec_disconnect

    Rectangle {
        id: connect_fail_item
        color: Qt.rgba(255, 255, 255, 0.5)
        visible: false
        Rectangle {
            width: 360
            height: 240
            visible: !dialog_connect_apply.visible
            anchors.centerIn: parent
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/error_background.png"
                fillMode: Image.PreserveAspectFit
                Text {
                    id: title_connect_fail
                    text: qsTr("error!")
                    width: parent.width * 0.7
                    height: parent.height * 0.2
                    color: "red"
                    font.pixelSize: height * 0.4
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Rectangle {
                    id: rect_split
                    width: parent.width * 0.8
                    height: parent.height * 0.01
                    anchors.top: title_connect_fail.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color:"#B0E0E6"
                    opacity: 0.5
                }
                Text {
                    width: parent.width * 0.5
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: rect_split.bottom
                    anchors.topMargin: height * 0.1
                    text: qsTr("app cannot to connect server, please check your wifi and IP!")
                    color: "black"
                    horizontalAlignment: Text.AlignLeft
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
                    onClicked: {
                        Qt.quit()
                    }
                }
            }
        }
        Rectangle {
            id: rec_connect_apply
            visible: false
            height: parent.height * 0.1
            width: height
            color: Qt.rgba(255, 0, 0, 0.15)
            radius: width / 2
            anchors {
                left: parent.left
                leftMargin: height * 0.1
                bottomMargin: height * 0.1
                bottom: parent.bottom
            }
            Image {
                source: "qrc:/res/pictures/connect_apply.png"
                height: parent.height * 0.8
                width: parent.height
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        dialog_connect_apply.open()
                    }
                }
            }
        }
        Dialog {
            id: dialog_connect_apply
            height: parent.height * 0.5
            width: height * 1.5
            x:(root.width - width) / 2
            y: (root.height - height) / 2
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
            contentItem: Item {
                anchors.fill: parent
                Rectangle {
                    id: rect_update_ip_input
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/pictures/background_glow2.png"
                    }
                    Rectangle {
                        color: Qt.rgba(255, 255, 255, 1)
                        anchors.centerIn: parent
                        width: parent.width * 0.8
                        height: parent.height * 0.75
                        Rectangle {
                            id: rect_update_title
                            width: parent.width
                            height: parent.height * 0.3
                            color: "transparent"
                            Text {
                                color: "#4876FF"
                                text: qsTr("Request to reconnect")
                                font.pixelSize: parent.height * 0.3
                                font.bold: true
                                anchors.centerIn: parent
                            }
                            Image {
                                height: parent.height * 0.4
                                width: height
                                anchors {
                                    right: parent.right
                                    top:parent.top
                                    rightMargin: parent.height * 0.1
                                    topMargin: parent.height * 0.1
                                }
                                source: "qrc:/res/pictures/exit.png"
                                fillMode: Image.PreserveAspectFit
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        dialog_connect_apply.close()
                                    }
                                }
                            }
                        }
                        Rectangle {
                            id: rect_update_ip
                            width: parent.width
                            height: parent.height * 0.8
                            color: "transparent"
                            anchors {
                                top: rect_update_title.bottom
                            }
                            Column {
                                width: parent.width * 0.6
                                height: parent.height
                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    top: parent.top
                                    topMargin: height * 0.1
                                }
                                spacing: height * 0.05
                                TLTextField {
                                    id: field_new_ip
                                    width: parent.width
                                    height: parent.height * 0.2
                                    btn_radius:  height * 0.2
                                    placeholderText: qsTr("Please enter new IP")
                                    font_size: height * 0.4
                                    pic_name: "qrc:/res/pictures/connect_apply.png"
                                }
                                Rectangle {
                                    id: rect_update_btns
                                    width: parent.width
                                    height: parent.height * 0.2
                                    color: "transparent"
                                    TLButton {
                                        id: btn_update_ip
                                        width: parent.width * 0.4
                                        height: parent.height * 0.7
                                        anchors {
                                            verticalCenter: parent.verticalCenter
                                            right: parent.horizontalCenter
                                            rightMargin: height * 0.4
                                        }

                                        btn_text: qsTr("OK")
                                        onClicked: {
                                            if (field_new_ip.text.trim() === "") {
                                                message_account.dia_title = qsTr("Error")
                                                message_account.dia_content = qsTr("ip cannot be empty!!!")
                                                message_account.status = 0
                                                message_account.open()
                                                connect_fail_item.visible = false
                                                dialog_connect_apply.close()
                                            } else {
                                                socket_manager.connectToHost(field_new_ip.text, "32432")
                                                dialog_connect_apply.close()
                                            }
                                        }
                                    }
                                    TLButton {
                                        id: btn_update_cancel
                                        width: parent.width * 0.4
                                        height: parent.height * 0.7
                                        anchors {
                                            verticalCenter: parent.verticalCenter
                                            left: parent.horizontalCenter
                                            leftMargin: height * 0.4
                                        }
                                        btn_text: qsTr("cancel")
                                        onClicked: {
                                            field_new_ip.text = ""
                                            dialog_connect_apply.close()

                                        }
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
        TLDialog {
            id: message_account
            height: parent.height * 0.5
            width: height * 1.5
            x: (root.width - width) / 2
            y: (root.height - height) / 2
            ok: false
            onCancelClicked: {
                dialog_connect_apply.open()
                message_account.close()
                connect_fail_item.visible = true
            }
        }

        Rectangle {
            id: rec_disconnect
            color: Qt.rgba(255, 255, 255, 0.5)
            visible: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Qt.quit()
                }
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
                height: parent.height * 0.2
                color:"transparent"
                property real login_count: 0
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
                    topMargin: parent.height * 0.08

                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width * 0.05

                }
                onClicked: {
                    if (rect_pwd.login_count < 3 ) {
                        account_manager.accountLogin(username.text, password.text)
                        rect_pwd.login_count++
                    } else {
                        message_connect_faild.dia_title = qsTr("login failed!")
                        message_connect_faild.dia_content = qsTr("Multiple login failures,please contact the administrator!")
                        message_connect_faild.open()
                    }


                }
            }
        }
    }

    Connections {
        target: account_manager
        onEmitCheckOutLogin: {
            if (status === 0) {
                message_login_faild.dia_title = qsTr("Error")
//                message_login_faild.dia_content = message
                message_login_faild.dia_content = qsTr("Account or password is wrong!")
                message_login_faild.open()
            } else if (status === 1) {
                root.successToLogin()
            }
        }

    }

    Connections {
        target: socket_manager
        onEmitFaildToLogin: {
            message_connect_faild.dia_content = message
            message_connect_faild.open()
            root.connectFail()

        }
        onAppDisconnected: {
            message_connect_faild.dia_content = message
            message_connect_faild.open()
            root.connectFail()
        }
    }

    TLDialog {
        id: message_connect_faild
        height: parent.height * 0.5
        width: height * 1.5
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("connect error!")
        status: 0
        cancel_text: qsTr("OK")

        onCancelClicked: {
            Qt.quit()
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
