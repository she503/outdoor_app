import QtQuick 2.9
import QtQuick.Controls 2.2
//import QtQuick.Controls.Styles 1.4
import "CustomControl"

Rectangle {
    id: root

    property var v_accounts_info

    property string checked_user_name: ""
    property int checked_user_level: 0
    property real rate: Math.min(width, height) / 400

    Component.onCompleted: {
        account_manager.getAllAcountInfo()
    }

    Connections {
        target: account_manager
        onEmitAllAccountInfo: {
            root.v_accounts_info = accounts_info

            var nomal_level = qsTr("nomal_level")
            var admin_level = qsTr("admin_level")

            for (var key in root.v_accounts_info) {
                if (accounts_info[key] === 0) {
                    console.info("error user level")
                } else if (accounts_info[key] === 1) {
                    user_list_model.append({"user_name": key, "level": nomal_level, "user_level": accounts_info[key]})
                } else if (accounts_info[key] === 2) {
                    user_list_model.append({"user_name": key, "level": admin_level, "user_level": accounts_info[key]})
                }
            }
        }
    }

    Dialog {
        id: message_update_uer
        width: root.width * 0.7
        height: root.height * 0.5
        x:(root.width - width) / 2
        y: (root.height - height) / 2

        title: qsTr("update user pwd")

        Column {
            width: parent.width
            height: parent.height
            anchors.centerIn: message_update_uer.Center
            spacing: height * 0.05
            TextField {
                id: field_old_pwd
                width: parent.width * 0.9
                height: parent.height * 0.3
                placeholderText: qsTr("Please enter old pwd")
                font.pixelSize: height * 0.2
                validator: RegExpValidator{regExp:/^.[A-Za-z0-9_]{0,11}$/}
            }
            TextField {
                id: field_new_pwd
                width: parent.width * 0.9
                height: parent.height * 0.3
                placeholderText: qsTr("Please enter new pwd")
                font.pixelSize: height * 0.2
                validator: RegExpValidator{regExp:/^.[A-Za-z0-9]{0,6}$/}
            }
            Rectangle {
                id: rect_update_btns
                width: parent.width * 0.9
                height: parent.height * 0.2
                Button {
                    id: btn_update_pwd
                    width: parent.width * 0.45
                    height: parent.height
                    text: qsTr("OK")
                    onClicked: {
                        if (field_old_pwd.text === "" || field_new_pwd.text === "") {
                            message_account.title = qsTr("password formart error")
                            message_account.message_level = 0
                            message_text.text = qsTr("password cannot be empty!!!")
                            message_account.open()
                        } else {
                            account_manager.updateUser(root.checked_user_name, field_new_pwd.text, root.checked_user_level)
                            message_account.title = qsTr("Success")
                            message_account.message_level = 1
                            message_text.text = qsTr("password had be changed!!!")
                            message_account.open()
                        }
                    }
                }
                Button {
                    id: btn_update_cancel
                    anchors.left: btn_update_pwd.right
                    anchors.leftMargin: parent.width * 0.1
                    width: parent.width * 0.45
                    height: parent.height
                    text: qsTr("cancel")
                    onClicked: {
                        field_old_pwd.text = ""
                        field_new_pwd.text = ""
                        message_update_uer.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: message_account
        width: root.width * 0.7
        height: root.height * 0.5
        x:(root.width - width) / 2
        y: (root.height - height) / 2
        title: qsTr("")
        /*
          @param
                0: error
                1: success
                2: infomation
          */
        property int message_level: 0
        onMessage_levelChanged: {
            if (message_account.message_level === 0) {
               back_color.color = "#DB7093"
            } else if (message_account.message_level === 1) {
                back_color.color = "#00FA9A"
            }
        }

        background: Rectangle {
            id: back_color
            anchors.fill: parent
            color: {
                if (message_account.message_level === 0) {
                    color = "#DB7093"
                } else if (message_account.message_level === 1) {
                    color = "#00FA9A"
                }
            }
        }

        TextArea {
            id: message_text
            width: parent.contentWidth * 0.8
            height: parent.contentHeight * 0.8
            text: ""
        }

        Button {
            id: btn_ok
            width: parent.contentWidth * 0.8
            height: parent.contentHeight * 0.2
            anchors{
                right: parent.right
                bottom: parent.bottom
            }
            text: "OK"
            onClicked: {
                message_account.close()
                message_text.text = ""
                message_account.title = ""
            }
        }

    }

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
            horizontalAlignment: Text.AlignLeft
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
            backgroundDefaultColor: list_view_user.currentIndex == -1 ? "gray" : "#3498DB"
            enabled: list_view_user.currentIndex == -1 ? false : true

            onClicked: {
                if (list_view_user.count === 1) {
                    message_account.title = qsTr("error")
                    message_account.message_level = 0
                    message_text.text = qsTr("This one user is last user, you forbidden to delete it!")
                    message_account.open()
                } else {
                    account_manager.deleteUser(root.checked_user_name)
                    user_list_model.remove(list_view_user.currentIndex)
                    list_view_user.currentIndex = -1
                    message_account.title = qsTr("Success")
                    message_account.message_level = 1
                    message_text.text = "( " + root.checked_user_name + qsTr(" )user was deleted !")
                    message_account.open()
                }
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
            enabled: list_view_user.currentIndex == -1 ? false : true
            backgroundDefaultColor: list_view_user.currentIndex == -1 ? "gray" : "#3498DB"

            onClicked: message_update_uer.open()
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
        height: parent.height * 0.4
        clip: true
        anchors.top: rect_user_line.bottom
        ListView {
            id: list_view_user
            width: parent.width
            height: parent.height
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height * 0.02
                leftMargin: parent.height * 0.015
            }
            currentIndex: -1
            spacing: 12 * rate
            delegate: ItemDelegate {
                id: item_de
                width: list_view_user.width
                height: list_view_user.height * 0.1
                highlighted: ListView.isCurrentItem

                Rectangle {
                    id: rect_circle
                    width: 19 * rate
                    height: width
                    radius: height / 2
                    border.width: 1
                    border.color: "#87CEFA"
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle {
                        anchors.centerIn: rect_circle
                        width: parent.width * 0.5
                        height: width
                        radius: width / 2
                        color: "#00BFFF"
                        visible: item_de.highlighted
                    }
                }
                Text {
                    id: text_username
                    anchors {
                        left: rect_circle.right
                        leftMargin: item_de.height * 0.2
                        verticalCenter: item_de.verticalCenter
                    }
                    text: model.user_name + ", "
                    font.pixelSize: item_de.height * 0.8
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: text_level
                    anchors {
                        left: text_username.right
                        leftMargin: item_de.height * 0.2
                        verticalCenter: item_de.verticalCenter
                    }
                    text: model.level
                    font.pixelSize: item_de.height * 0.8
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    property int user_level: model.user_level
                }
                onClicked: {
                    list_view_user.currentIndex = index
                    root.checked_user_name = model.user_name
                    root.checked_user_level = text_level.user_level
                }
            }
            model: ListModel {
                id: user_list_model
            }
        }
    }

    Rectangle {
        id: rect_add_user_linee
        width: parent.width
        height: parent.height * 0.002
        color: "gray"
        anchors.top: rect_list.bottom
    }

    Rectangle {
        id: rect_add_user
        width: parent.width
        height: parent.height * 0.1
        anchors.top: rect_add_user_linee.bottom
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
        height: parent.height * 0.4
        width: parent.width * 0.5
        anchors.top: rect_add_user_line.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        TLTextField {
            id: btn_add_username
            width: parent.width
            height: parent.height * 0.2
            anchors {
                top: parent.top
                topMargin: 5 * rate
                left: parent.left
            }
            btn_radius:  height * 0.1
            placeholderText: qsTr("enter new user name.")
            pic_name: "qrc:/res/pictures/username.png"
        }
        TLTextField {
            id: btn_add_pwd
            width: parent.width
            height: parent.height * 0.2
            anchors {
                top: btn_add_username.bottom
                topMargin: 5 * rate
                left: parent.left
            }
            btn_radius:  height * 0.1
            placeholderText: qsTr("enter new password.")
            pic_name: "qrc:/res/pictures/password.png"
        }
        GroupBox {
            id: radio_box
            anchors.top: btn_add_pwd.bottom
            anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.8
            height: parent.height * 0.2
            background: Rectangle {
                border.width: 0
            }
            Row {
                anchors.centerIn: parent

                spacing: 70 * rate

                TLRadioButton {
                    id: radio_btn_operator
                    width: 25 * rate
                    height: 25 * rate
                    text_name: qsTr("operator")

                }
                TLRadioButton {
                    id: radio_btn_admin
                    width: 25 * rate
                    height: 25 * rate
                    text_name: qsTr("admin")
                }
            }
        }
        TLButton {
            id: btn_registered
            width: parent.width
            height: parent.height * 0.2
            anchors.top: radio_box.bottom
            anchors.topMargin: 5
            btn_text: qsTr("OK")
            onClicked: {
                if (btn_add_pwd.text === "" || btn_add_username.text === "" ||
                        (!radio_btn_admin.checked && !radio_btn_operator.checked)) {
                    message_account.title = qsTr("empty error")
                    message_account.message_level = 0
                    message_text.text = qsTr("some information is empty!!!")
                    message_account.open()
                    return
                } else {
                    var level = radio_btn_admin.checked ? 2 : 1
                    var states = account_manager.addUser(btn_add_username.text, btn_add_pwd.text, level)
                    switch (states) {
                    case 0:
                        message_account.title = qsTr("error")
                        message_account.message_level = 0
                        message_text.text = qsTr("user name has exited !")
                        message_account.open()
                        break;
                    case 1:
                        var leve_name = ""
                        if (level === 1) {
                            leve_name = qsTr("nomal_user")
                        } else if (level === 2) {
                            leve_name = qsTr("admin_user")
                        }
                       user_list_model.append({"user_name": btn_add_username.text, "level": leve_name, "user_level": level})
                        message_account.title = qsTr("Success")
                        message_account.message_level = 1
                        message_text.text = qsTr("a new user was added")
                        message_account.open()
                        break;
                    case 2:
                        break;
                    case 3:
                        break;
                    case 4:
                        break;
                    }
                }
            }
        }
    }
}
