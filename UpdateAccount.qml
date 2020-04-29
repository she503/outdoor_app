import QtQuick 2.0
import QtQuick.Controls 2.2
import "../homemade_components"

Dialog {
    id: message_update_uer
    height: parent.height * 0.5
    width: height * 1.5

    property string p_checked_user_name: ""
    property int p_checked_user_level: 0
    property int p_current_user_level: account_manager.getCurrentUserLevel()
    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
    }
    contentItem: Item {
        anchors.fill: parent
        Rectangle {
            id: rect_update_user_input
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
                        text: qsTr("update user pwd")
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
                                message_update_uer.close()
                            }
                        }
                    }
                }
                Rectangle {
                    id: rect_update_user
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
                            id: field_old_pwd
                            visible: message_update_uer.p_current_user_level >
                                     message_update_uer.p_checked_user_level ? false : true
                            width: parent.width
                            height: parent.height * 0.2
                            btn_radius:  height * 0.2
                            placeholderText: qsTr("Please enter old pwd")
                            pic_name: "qrc:/res/pictures/password.png"
                        }
                        TLTextField {
                            id: field_new_pwd
                            width: parent.width
                            height: parent.height * 0.2
                            btn_radius:  height * 0.2
                            placeholderText: qsTr("Please enter new pwd")
                            font_size: height * 0.4
                            pic_name: "qrc:/res/pictures/password.png"
                        }
                        Rectangle {
                            id: rect_update_btns
                            width: parent.width
                            height: parent.height * 0.2
                            color: "transparent"
                            TLButton {
                                id: btn_update_pwd
                                width: parent.width * 0.4
                                height: parent.height * 0.7
                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    right: parent.horizontalCenter
                                    rightMargin: height * 0.4
                                }

                                btn_text: qsTr("OK")
                                onClicked: {
                                    if (field_new_pwd.text.trim() === "") {
                                        message_account.dia_title = qsTr("Error")
                                        message_account.dia_text = qsTr("password cannot be empty!!!")
                                        message_account.dia_type = 0
                                        message_account.open()
                                    } else {
                                        if(message_update_uer.p_current_user_level <= message_update_uer.p_checked_user_level) {
                                            account_manager.accountUpdate(message_update_uer.p_checked_user_name,
                                                                          field_new_pwd.text, message_update_uer.p_checked_user_level,
                                                                          field_old_pwd.text, true)
                                        } else {
                                            account_manager.accountUpdate(message_update_uer.p_checked_user_name,
                                                                          field_new_pwd.text, message_update_uer.p_checked_user_level)
                                        }
                                        field_old_pwd.text = ""
                                        field_new_pwd.text = ""
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
                                    field_old_pwd.text = ""
                                    field_new_pwd.text = ""
                                    message_update_uer.close()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: account_manager
        onEmitUpdateAccountRst: {
            if (status === 1) {
                message_update_uer.close()
            }
        }
    }
    TLMessageBox {
        id: message_account
        height: parent.height * 1
        width: height * 1.5

    }

}
