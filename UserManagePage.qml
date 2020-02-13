import QtQuick 2.9
import QtQuick.Controls 2.2
//import QtQuick.Controls.Styles 1.4
import "CustomControl"

Rectangle {
    id: root

    property var user_nomal
    property var user_admin
    property string checked_user_name: ""
    property string checked_user_level: ""
    Component.onCompleted: {
        user_manage.getAllUserAccountData()
    }

    Connections {
        target: user_manage
        onEmitALLUserAccount: {
            root.user_nomal = nomal
            root.user_admin = admin
            var nomal_level = qsTr("nomal_level");
            var admin_level = qsTr("admin_level")
            for (var nomal_key in nomal) {
                user_list_model.append({"user_name": nomal_key, "level": nomal_level, "level_obj_name": "nomal_user"})
            }
            for (var admin_key in admin) {
                user_list_model.append({"user_name": admin_key, "level": admin_level, "level_obj_name": "admin_user"})
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
                        if (root.user_nomal[root.checked_user_name] === field_old_pwd.text) {
                            if (user_manage.addNewOrUpdateUserAccount(root.checked_user_name, field_new_pwd.text, root.checked_user_level)) {
                                root.user_nomal[root.checked_user_name] = field_new_pwd.text
                            }

                        } else if (root.user_admin[root.checked_user_name] === field_old_pwd.text){
                            if (user_manage.addNewOrUpdateUserAccount(root.checked_user_name, field_new_pwd.text, root.checked_user_level)) {
                                root.user_admin[root.checked_user_name] === field_new_pwd.text
                            }
                        } else {
                    console.info("error old pwd")
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
                delete root.user_nomal[root.checked_user_name];
                console.info(user_manage.deleteUserAccount(root.user_nomal, root.checked_user_level))
                user_list_model.remove(list_view_user.currentIndex)
                list_view_user.currentIndex = -1
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
                id: item_de
                width: list_view_user.width
                height: list_view_user.height * 0.1
                highlighted: ListView.isCurrentItem

                Rectangle {
                    id: rect_circle
                    width: parent.height * 0.8
                    height: width
                    radius: height / 2
                    border.width: 1
                    border.color: "#87CEFA"
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.centerIn: rect_circle
                        width: parent.width * 0.4
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
                    objectName: model.level_obj_name
                    anchors {
                        left: text_username.right
                        leftMargin: item_de.height * 0.2
                        verticalCenter: item_de.verticalCenter
                    }
                    text: model.level
                    font.pixelSize: item_de.height * 0.8
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    list_view_user.currentIndex = index
                    root.checked_user_name = model.user_name
                    root.checked_user_level = model.level_obj_name
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
                topMargin: 2
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
                topMargin: 2
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
                anchors.fill: parent

                spacing: width * 0.1

                TLRadioButton {
                    id: radio_btn_operator
                    width: parent.width * 0.5
                    height: parent.height
                    text_name: qsTr("operator")

                }
                TLRadioButton {
                    id: radio_btn_admin
                    width: parent.width * 0.5
                    height: parent.height
                    text_name: qsTr("admin")
                }
            }
        }
        TLButton {
            id: btn_registered
            width: parent.width
            height: parent.height * 0.2
            anchors.top: radio_box.bottom
            btn_text: qsTr("OK")
            Component.onCompleted: {

            }

            onClicked: {
                if ((radio_btn_operator.checked || radio_btn_admin.checked)
                        && btn_add_username.text.trim() !=  ""
                        && btn_add_pwd.text.trim() != "") {
                    var user_name = btn_add_username.text
                    var user_pwd = btn_add_pwd.text
                    var user_level = radio_btn_operator.checked ? "nomal_user" : "admin_user"

                    for (var key_nomal in root.user_nomal) {
                         if (key_nomal === user_name) {
                             console.info("[registered faild]: existence user name!!!")
                             return
                         }
                    }
                    for (var key_admin in root.user_admin) {
                        if (key_admin === user_name) {
                            console.info("[registered faild]: existence user name!!!")
                            return
                        }
                    }

                    user_manage.addNewOrUpdateUserAccount(user_name, user_pwd, user_level)
                    var add_admin_level = qsTr("add_admin_level")
                    var add_user_level = qsTr("add_user_level")
                    if (user_level === "nomal_user") {
                        user_list_model.append({"user_name": user_name, "level": add_user_level, "level_obj_name": user_level})
                    } else if (user_level === "admin_user") {
                        user_list_model.append({"user_name": user_name, "level": add_admin_level, "level_obj_name": user_level})
                    }

                    console.info("registered success!!!")
                } else {
                    console.info("registered faild!!!")
                }
            }
        }
    }
}
