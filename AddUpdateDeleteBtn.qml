import QtQuick 2.0
import QtQuick.Controls 2.2
import "../homemade_components"
Rectangle {
    id: root
    color: "transparent"

    property int p_checked_user_level: 0
    property string p_checked_user_name: ""
    property bool p_is_choose_account: false
    property int p_admin_num: 0
    onP_checked_user_nameChanged: {
        message_update_uer.p_checked_user_level = root.p_checked_user_level
        message_update_uer.p_checked_user_name = root.p_checked_user_name
    }
    property Dialog dialog_add_user: AddNewAccount{
        x: -parent.width * 0.5
        y: parent.height * 0.7
        width: parent.width * 1.2
        height: parent.height * 5
    }
    UpdateAccount{
        id:message_update_uer
        x: -parent.width * 0.5

        width: 300
        height: parent.height * 5
    }

    Button {
        id: btn_delete
        width: parent.width * 0.3
        height: parent.height * 0.5
        contentItem: Text {
            width: parent.width
            height: parent.height * 0.8
            anchors.top: parent.top
            font.pixelSize: parent.height * 0.53
            text: qsTr("delete")
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors.topMargin: parent.height * 0.05
        }
        enabled: root.p_is_choose_account

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
        onClicked: {
            if ( root.p_checked_user_level === 2 && root.p_admin_num === 1) {
                tl_message_box.dia_title = qsTr("delete faild")
                tl_message_box.dia_text = qsTr("you cant delete last admin account!!!")
                tl_message_box.dia_type = 0
                tl_message_box.open()
            } else {
                account_manager.accountDelete(root.p_checked_user_name)
            }
        }
    }
    Button {
        id: btn_update
        width: parent.width * 0.3
        height: parent.height * 0.5
        contentItem: Text {
            width: parent.width
            height: parent.height * 0.8
            font.pixelSize: parent.height * 0.53
            text: qsTr("update")
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.05
        }

        enabled: root.p_is_choose_account

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
    Button {
        id: btn_add
        width: parent.width * 0.3
        height: parent.height * 0.5
        contentItem: Text {
            width: parent.width
            height: parent.height * 0.8
            font.pixelSize: parent.height * 0.52
            text: qsTr("add")
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.05
        }

        background: Image {
            id: img_add
            anchors.fill: parent
            source: "qrc:/res/pictures/btn_1.png"
        }

        anchors {
            bottom: parent.bottom
            right: btn_update.left
            rightMargin: width * 0.1
        }
        onClicked: dialog_add_user.open()
    }
}
