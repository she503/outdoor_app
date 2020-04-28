import QtQuick 2.0
import QtQuick.Controls 2.2
import "../customControl"

Dialog {
    id: dialog_add_user
    height: parent.height * 0.5
    width: height * 1.5
    x:(root.width - width) / 2
    y: (root.height - height) / 2
    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
    }
    contentItem: Item {
        anchors.fill: parent
        Rectangle {
            id: rect_password_input
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
                    id: rect_unlock_title
                    width: parent.width
                    height: parent.height * 0.3
                    color: "transparent"
                    Text {
                        color: "#4876FF"
                        text: qsTr("add user")
                        font.pixelSize: parent.height * 0.3
                        font.bold: true
                        anchors.centerIn: parent
                    }
                    Image {
                        id: img_exit
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
                                dialog_add_user.close()
                            }
                        }
                    }
                }
                Rectangle {
                    id: rect_add_user
                    width: parent.width * 0.8
                    height: parent.height * 0.7
                    anchors{
                        top: rect_unlock_title.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    color: "transparent"

                    Rectangle {
                        id: user_rect
                        width: parent.width
                        height: parent.height * 0.2
                        anchors {
                            top: parent.top
                        }
                        color: "transparent"
                        Text {
                            id: text_use
                            text: qsTr("username:")
                            width: parent.width * 0.3
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            color: "#1a7ec0"
                            font.pixelSize: height * 0.5
                            anchors{
                                top: parent.top
                                left: parent.left
                            }
                        }

                        TLTextField {
                            id: btn_add_username
                            width: parent.width * 0.6
                            height: parent.height
                            anchors {
                                top: parent.top
                                topMargin: parent.height * 0.1
                                left: text_use.right
                                leftMargin: parent.width * 0.05
                            }
                            btn_radius:  height * 0.2
                            placeholderText: qsTr("enter new user name.")
                            pic_name: "qrc:/res/pictures/username.png"
                        }
                    }

                    Rectangle {
                        id: pwd_rect
                        width: parent.width
                        height: parent.height * 0.2
                        anchors {
                            top: user_rect.bottom
                            topMargin: parent.height * 0.1
                        }
                        color: "transparent"
                        Text {
                            id: text_pwd
                            text: qsTr("password:")
                            width: parent.width * 0.3
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            color: "#1a7ec0"
                            font.pixelSize: height * 0.5
                            anchors{
                                top: parent.top
                                left: parent.left
                            }
                        }
                        TLTextField {
                            id: btn_add_pwd
                            width: parent.width * 0.6
                            height: parent.height
                            anchors {
                                top: parent.top
                                topMargin: parent.height * 0.1
                                left: text_pwd.right
                                leftMargin: parent.width * 0.05

                            }
                            btn_radius:  height * 0.2
                            placeholderText: qsTr("enter new password.")
                            pic_name: "qrc:/res/pictures/password.png"
                        }

                    }

                    TLRadioButton {
                        id: radio_btn
                        width: parent.width
                        height: parent.height * 0.1
                        anchors{
                            top: pwd_rect.bottom
                            topMargin: parent.height * 0.08
                            horizontalCenter: parent.horizontalCenter
                        }
                    }

                    TLButton {
                        id: btn_registered
                        width: parent.width * 0.4
                        height: parent.height * 0.15
                        anchors{
                            top: radio_btn.bottom
                            topMargin: parent.height * 0.08
                            horizontalCenter: parent.horizontalCenter
                        }
                        btn_text: qsTr("OK")
                        onClicked: {
                            if (btn_add_pwd.text === "" || btn_add_username.text === "" ||
                                    radio_btn.checked_num === -1) {
                                message_account.dia_title = qsTr("add error")
                                message_account.dia_text = qsTr("some information is empty!!!")
                                message_account.dia_type = 0
                                message_account.open()
                                return
                            } else {
                                var level = radio_btn.checked_num
                                account_manager.accountAdd(btn_add_username.text, btn_add_pwd.text, level)
                            }
                        }
                    }
                }


            }
        }
    }
    TLMessageBox {
        id: message_account
        height: parent.height * 1
        width: height * 1.5

    }


    Connections {
        target: account_manager
        onEmitAddAccountRst: {
            if (status === 1) {
                dialog_add_user.close()
                btn_add_username.text = ""
                btn_add_pwd.text = ""
                radio_btn.checked_num = -1
            }
        }
    }
}
