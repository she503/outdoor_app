import QtQuick 2.9
import QtQuick.Controls 2.2
//import QtQuick.Controls.Styles 1.4
import "CustomControl"

Rectangle {
    id: root

    Rectangle {
        id: title_user
        width: parent.width
        height: parent.height * 0.1
        color: "white"

        Text {
            id: title
            width: parent.width * 0.2
            height: parent.height
            font.pixelSize: height * 0.5
            font.bold: true
            text: qsTr("user list: ")
            anchors {
                left: parent.left
                leftMargin: width * 0.1
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        TLButton {
            id: btn_delete
            width: parent.width * 0.2
            height: parent.height * 0.8
            btn_text: qsTr("delete")
            font_size: height * 0.5

            anchors {
                right: parent.right
                rightMargin: width * 0.1
                verticalCenter: parent.verticalCenter
            }
        }

        TLButton {
            id: btn_update
            width: parent.width * 0.2
            height: parent.height * 0.8
            btn_text: qsTr("update")
            font_size: height * 0.5
            anchors {
                right: btn_delete.left
                rightMargin: width * 0.1
                verticalCenter: parent.verticalCenter
            }
        }

    }

    Rectangle {
        id: rect_user_line
        width: parent.width
        height: parent.height * 0.002
        color: "gray"
        anchors.top: title_user.bottom
    }

    Rectangle {
        id: rect_list
        width: parent.width
        height: parent.height * 0.5
        clip: true
        anchors {
            top: rect_user_line.bottom
            topMargin: 2
        }

        ListView {
            id: list_view_user
            width: parent.width
            height: parent.height
            currentIndex: -1
            spacing: height * 0.1
            delegate: ItemDelegate {
                width: list_view_user.width
                height: list_view_user.height * 0.1
                highlighted: ListView.isCurrentItem
                RadioButton {
                    id: btn_user
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    text: model.btn_text
                }
                onClicked: {
                    list_view_user.currentIndex = index
//                    btn_user.checked = true
                    console.info("1")
                }
            }
            model: ListModel {
                ListElement {
                    btn_text: "admin,admin"
                }
                ListElement {
                    btn_text: "admisn,admisrn"
                }
            }
        }
    }

    Rectangle {
        id: rect_add_user
        width: parent.width
        height: parent.height * 0.1
        anchors.top: rect_list.bottom
        Text {
            id: title_add
            width: parent.width * 0.2
            height: parent.height
            text: qsTr("add new user: ")
            font.pixelSize: height * 0.5
            font.bold: true
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        id: rect_add_user_line
        width: parent.width
        height: parent.height * 0.002
        color: "gray"
        anchors.top: rect_add_user.bottom
    }

    Rectangle {

        height: parent.height * 0.3
        width: parent.width
        anchors.top: rect_add_user_line.bottom
        TLTextField {
            id: btn_add_username
            width: parent.width * 0.5
            height: parent.height * 0.2
            anchors {
                top: parent.top
                topMargin: 2
                left: parent.left
            }
            placeholderText: qsTr("enter new user name.")
            pic_name: "qrc:/res/pictures/username.png"
        }
        TLTextField {
            id: btn_add_pwd
            width: parent.width * 0.5
            height: parent.height * 0.2
            anchors {
                top: btn_add_username.bottom
                topMargin: 2
                left: parent.left
            }
            placeholderText: qsTr("enter new password.")
            pic_name: "qrc:/res/pictures/password.png"
        }
        GroupBox {
            id: radio_box
            anchors.top: btn_add_pwd.bottom
            width: parent.width
            height: parent.height * 0.2
            Row {
                anchors.fill: parent
                RadioButton {
                    text: qsTr("operator")
                }
                RadioButton {
                    text: qsTr("admin")
                }
            }
        }


        TLButton {
            width: parent.width * 0.5
            height: parent.height * 0.2
            anchors.top: radio_box.bottom
            btn_text: qsTr("OK")
        }
    }
}
