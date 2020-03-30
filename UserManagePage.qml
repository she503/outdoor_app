import QtQuick 2.9
import QtQuick.Controls 2.2
//import QtQuick.Controls.Styles 1.4
import "CustomControl"

Rectangle {
    id: root

    property var v_accounts_info

    property string checked_user_name: ""
    property int checked_user_level: 0
    property int user_level: 0
    property int admin_num: 0
    property real rate: Math.min(width, height) / 400

    color: "transparent"


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

                            message_account.dia_title = qsTr("password cannot be empty!!!")
                            message_account.dia_title_color = "red"
                            message_account.dia_image_source = "qrc:/res/pictures/sad.png"
                            message_account.open()
                        } else {
                            socket_manager.accountUpdate(root.checked_user_name, field_new_pwd.text, root.checked_user_level)
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

    TLDialog {
        id: message_account
        width: root.width * 0.7
        height: root.height * 0.5
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Warn!")
        dia_image_source: ""
        is_single_btn: true
        onOkClicked: {
            message_account.close()
        }
    }


    Rectangle {
        id: bg
        height: parent.width > parent.height ? parent.height * 0.9 : parent.width * 0.9 * 0.787
        width: parent.width > parent.height ? parent.height * 0.9 * 1.27 : parent.width * 0.9
        anchors.centerIn: parent
        color: "transparent"
        visible: root.user_level === 1 ? false : true
        Image {
            id: im
            anchors.fill: parent
            source: "qrc:/res/pictures/user_background.png"
        }
        Rectangle {
            id: rect_top
            width: parent.width
            height: parent.height * 0.16
            color: "transparent"
            Button {
                id: btn_delete
                width: parent.width * 0.2
                height: parent.height * 0.5
                contentItem: Text {
                    anchors.fill: parent
                    font.pixelSize: parent.height * 0.5
                    text: qsTr("delete")
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                enabled: list_view_user.currentIndex === -1 ? false : true

                background: Image {
                    id: img_delete
                    anchors.fill: parent
                    source: !enabled ? "qrc:/res/pictures/btn_2.png" : "qrc:/res/pictures/btn_1.png"
                }

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: width * 0.25
                }

                Component.onCompleted: {
                    if (root.user_level === 1) {
                        btn_delete.visible = false
                    } else if (root.user_level === 2) {
                        btn_delete.visible = true
                    }
                }

                onClicked: {
                    if (root.checked_user_level == 2 && root.admin_num === 1) {

                    } else {
                        socket_manager.accountDelete(root.checked_user_name)

                    }

                }
            }
            Button {
                id: btn_update
                width: parent.width * 0.2
                height: parent.height * 0.5
                contentItem: Text {
                    anchors.fill: parent
                    font.pixelSize: parent.height * 0.5
                    text: qsTr("update")
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                enabled: list_view_user.currentIndex === -1 ? false : true

                background: Image {
                    id: img_update
                    anchors.fill: parent
                    source: !enabled ? "qrc:/res/pictures/btn_2.png" : "qrc:/res/pictures/btn_1.png"
                }

                anchors {
                    bottom: parent.bottom
                    right: btn_delete.visible ? btn_delete.left : parent.right
                    rightMargin: width * 0.1
                }
                onClicked: message_update_uer.open()
            }
        }

        Rectangle {
            id: rect_list
            width: parent.width * 0.8
            height: parent.height * 0.45
            clip: true
            color: "transparent"
            anchors {
                top: rect_top.bottom
                horizontalCenter: parent.horizontalCenter
            }
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
                        color: "white"
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
                        color: "white"
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
            id: rect_add_user
            width: parent.width * 0.4
            height: parent.height * 0.3
            anchors{
                top: rect_list.bottom
                topMargin: parent.height * 0.04
                right: parent.right
                rightMargin: parent.width * 0.08
            }
            color: "transparent"

            Rectangle {
                id: user_rect
                width: parent.width
                height: parent.height * 0.2
                anchors {
                    top: parent.top
                }
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
                        topMargin: parent.height * 0.2
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
                width: parent.width * 0.8
                height: parent.height * 0.1
                anchors{
                    top: pwd_rect.bottom
                    topMargin: parent.height * 0.08
                    right: parent.right
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
                    horizontalCenterOffset: parent.width * 0.1
                }
                btn_text: qsTr("OK")
                onClicked: {
                    if (btn_add_pwd.text === "" || btn_add_username.text === "" ||
                            radio_btn.checked_num === -1) {
//                        message_account.title = qsTr("empty error")
//                        message_account.message_level = 0
//                        message_text.text = qsTr("some information is empty!!!")
                        message_account.dia_title = qsTr("some information is empty!!!")
                        message_account.dia_title_color = "red"
                        message_account.dia_image_source = "qrc:/res/pictures/sad.png"
                        message_account.open()
                        return
                    } else {
                        var level = radio_btn.checked_num
                        socket_manager.accountAdd(btn_add_username.text, btn_add_pwd.text, level)
//                        var states = account_manager.addUser(btn_add_username.text, btn_add_pwd.text, level)

                    }
                }
            }
        }

    }

    Rectangle {
        id: rect_nomal
        height: parent.width > parent.height ? parent.height * 0.9 : parent.width * 0.9 * 0.787
        width: parent.width > parent.height ? parent.height * 0.9 * 1.27 : parent.width * 0.9
        anchors.centerIn: parent
        color: "transparent"
        visible: root.user_level === 1 ? true : false
        Image {
            id: img
            anchors.fill: parent
            source: "qrc:/res/pictures/user_nomal_background.png"
        }
        Rectangle {
            id: rect_noaml_update
            width: parent.width
            height: parent.height * 0.15
            anchors{
                top: parent.top
                topMargin: parent.height * 0.07
            }
            color: "transparent"
            Button {
                id: btn_update_nomal
                width: parent.width * 0.2
                height: parent.height * 0.5

                contentItem: Text {
                    anchors.fill: parent
                    font.pixelSize: parent.height * 0.5
                    text: qsTr("update")
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Image {
                    id: img_update_nomal
                    anchors.fill: parent
                    source: !enabled ? "qrc:/res/pictures/btn_2.png" : "qrc:/res/pictures/btn_1.png"
                }

                anchors {
                    top: parent.top
                    topMargin: parent.height * 0.1
                    right: parent.right
                    rightMargin: width * 0.4
                }
                onClicked: {
                    root.checked_user_name = rect_nomal_user_name_text.user_name.trim()
                    root.checked_user_level = 1
                    message_update_uer.open()
                }
            }
        }

        Rectangle {
            id: rect_nomal_user_name_text
            width: parent.width * 0.8
            height: parent.height * 0.6
            anchors{
                top: rect_noaml_update.bottom
                horizontalCenter: parent.horizontalCenter
            }
            color: "transparent"
            property var user_name: "error"
            Component.onCompleted: {
                for (var key in root.v_accounts_info) {
                    rect_nomal_user_name_text.user_name = key
                }
            }

            Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height * 0.1
                text: rect_nomal_user_name_text.user_name
                color: "white"
            }
        }
    }

    Component.onCompleted: {
        socket_manager.getAllAccounts()
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
                    ++root.admin_num;
                }
            }
        }
    }

    Connections {
        target: socket_manager
        onEmitAddAccountCB: {
            switch (states) {
            case 0:
                message_account.dia_title = qsTr("user name has exited !")
                message_account.dia_title_color = "red"
                message_account.dia_image_source = "qrc:/res/pictures/sad.png"
                message_account.open()
                break;
            case 1:
                var leve_name = ""
                if (level === 1) {
                    leve_name = qsTr("nomal_user")
                } else if (level === 2) {
                    leve_name = qsTr("admin_user")
                    ++root.admin_num
                }
                message_account.dia_title = qsTr("a new user was added")
                message_account.dia_title_color = "#4F94CD"
                message_account.dia_image_source = "qrc:/res/pictures/smile.png"
                message_account.open()
                break;
            }
        }
        onEmitAllAccountInfo: {
            root.admin_num = 0
            root.v_accounts_info = accounts_info
            user_list_model.clear()

            var nomal_level = qsTr("nomal_level")
            var admin_level = qsTr("admin_level")

            for (var key in root.v_accounts_info) {
                if (root.v_accounts_info[key] === 0) {
                    console.info("error user level")
                } else if (root.v_accounts_info[key] === 1) {
                    user_list_model.append({"user_name": key, "level": nomal_level, "user_level": accounts_info[key]})
                } else if (root.v_accounts_info[key] === 2) {
                    user_list_model.append({"user_name": key, "level": admin_level, "user_level": accounts_info[key]})
                    ++root.admin_num;
                }
            }
        }
        onEmitDeleteAccountCB: {
            switch(status) {
            case 0:
                message_account.dia_title_color = "red"
                message_account.dia_title = message//qsTr("This one user is last admin,\n you are not allowed to delete it!")
                message_account.dia_image_source = "qrc:/res/pictures/sad.png"
                message_account.open()

                break;
            case 1:
                list_view_user.currentIndex = -1
                message_account.dia_title = qsTr("user ") + root.checked_user_name + qsTr(" was deleted !")
                message_account.dia_title_color = "#4F94CD"
                message_account.dia_image_source = "qrc:/res/pictures/smile.png"
                message_account.open()
                if (root.checked_user_level == 2) {
                    --root.admin_num
                }
                break;
            }
        }
        onEmitUpdateAccountCB: {
            switch(status) {
            case 0:
                message_account.dia_title = message
                message_account.dia_title_color = "red"
                message_account.dia_image_source = "qrc:/res/pictures/sad.png"
                message_account.open()
                break;
            case 1:
                message_account.dia_title = qsTr("password had be changed!!!")
                message_account.dia_title_color = "#4F94CD"
                message_account.dia_image_source = "qrc:/res/pictures/smile.png"
                message_account.open()
                break;
            }
        }
    }

}
