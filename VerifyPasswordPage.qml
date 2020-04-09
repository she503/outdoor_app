import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "CustomControl"

Item {
    id: root
    width: parent.width
    height: parent.height
    property alias pop_lock: pop_lock
    Popup {
        id: pop_lock
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        dim: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        background: Rectangle {
            anchors.fill: parent
            opacity: 0.5
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient
                {
                    GradientStop{position: 0.3; color:"grey"}
                    GradientStop{position: 1; color:"black"}
                }
            }
        }
        contentItem: Item {
            anchors.fill: parent
            Rectangle {
                anchors.centerIn: parent
                color: "transparent"
                height: parent.height * 0.1
                width: height
                Image {
                    anchors.fill: parent
                    source: "qrc:/res/pictures/password.png"
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        message_view.is_locked = false
                        dialog_unlock.open()
                    }
                }
            }
        }
    }
    Dialog {
        id: dialog_unlock
        width: root.width * 0.45
        height: root.height * 0.4
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
                    color: "white"
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    height: parent.height * 0.75
                    Rectangle {
                        id: rect_unlock_title
                        width: parent.width
                        height: parent.height * 0.3
                        color: "transparent"
                        Text {
                            color: "red"
                            text: qsTr("Enter password to unlock")
                            font.pixelSize: parent.height * 0.4
                        }
                    }

                    Rectangle {
                        id: rect_pwd
                        width: parent.width * 0.95
                        height: parent.height * 0.25
                        color:"transparent"
                        anchors {
                            top: rect_unlock_title.bottom
                            topMargin: height * 0.4
                            horizontalCenter: parent.horizontalCenter
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
                            text: qsTr("")
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
                        width: parent.width * 0.3
                        height: parent.height * 0.2
                        btn_text: qsTr("unclock")
                        font_size: height * 0.5
                        anchors {
                            top: rect_pwd.bottom
                            topMargin: parent.height * 0.04

                            horizontalCenter: parent.horizontalCenter
                            horizontalCenterOffset: parent.width * 0.03

                        }
                        onClicked: {
                            if (password.text === login_page.current_login_password) {
                                message_unclock_faild.close()
                                dialog_unlock.close()
                                pop_lock.close()
                            } else {
                                dialog_unlock.close()
                                message_unclock_faild.open()
                            }
                        }
                    }
                }
            }
        }
    }
    TLDialog {
        id: message_unclock_faild
        width: root.width * 0.45
        height: root.height * 0.4
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("error!")
        status: 0
        cancel_text: qsTr("OK")
        dia_content: qsTr("Password input error, please re-enter!")
        onCancelClicked: {
            if (password.text === login_page.current_login_password) {
                message_unclock_faild.close()
                dialog_unlock.close()
                pop_lock.close()
            } else {
                message_unclock_faild.close()
                dialog_unlock.open()
            }
        }
    }

}
