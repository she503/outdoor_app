import QtQuick 2.0
import "homemade_components"
Rectangle {
    id: root
    TLMessageBox {
        id: message_box

        x: (parent.width - width ) / 2
        y: (parent.height - height) / 2
        width: 300
        height: 200
    }

    Connections {
        target: socket_manager
        onEmitMappingMessage: {
            message_box.dia_type = flag ? 1 : 0
            message_box.dia_title = qsTr("COPY")
            message_box.dia_text = message
            message_box.open()
        }
    }


    Connections {
        target: map_task_manager
        onEmitGetAllMapsInfoError: {
            message_box.dia_type = 0
            message_box.dia_title = qsTr("Map Error")
            message_box.dia_text = qsTr("get map error")
            message_box.open()
        }

        onEmitSetMapNameRstInfo: {
            message_box.dia_type = 0
            message_box.dia_title = qsTr("Map Error")
            message_box.dia_text = qsTr("set map error")
            message_box.open()
        }

        onEmitSetInitPoseRstInfo: {
            if (status === 0) {
                message_box.dia_type = 0
                message_box.dia_title = qsTr("Init Error")
                message_box.dia_text = qsTr("Init Pos error")
                message_box.open()
            }
        }

        onEmitGetMapAndTasksInfoError: {
            message_box.dia_type = 0
            message_box.dia_title = qsTr("Task Error")
            message_box.dia_text = qsTr("get map and tasks error")
            message_box.open()
        }

        onEmitSetTasksRstInfo: {
            message_box.dia_type = 0
            message_box.dia_title = qsTr("Map Error")
            message_box.dia_text = qsTr("get map error")
            message_box.open()
        }

        onEmitGetWorkMapInfoError: {
            message_box.dia_type = 0
            message_box.dia_title = qsTr("Work Map Error")
            message_box.dia_text = qsTr("get work map error")
            message_box.open()
        }

        onEmitGetWorkRefLineInfoError: {
            message_box.dia_type = 0
            message_box.dia_title = qsTr("Ref Line Error")
            message_box.dia_text = qsTr("get ref line error")
            message_box.open()
        }
    }

    Connections {
        target: account_manager
        onEmitLoginRst: {
            if (status === 0) {
                message_box.dia_type = 0
                message_box.dia_title = qsTr("Login Error")
                message_box.dia_text = qsTr("Account or password is wrong!")
                message_box.open()
            }
        }

        onEmitAddAccountRst: {
            if (status === 0) {
                message_box.dia_type = 0
                message_box.dia_title = qsTr("Add Error")
                message_box.dia_text = qsTr("user name has exited !")
                message_box.open()
            } else if (status === 1) {
                message_box.dia_type = 1
                message_box.dia_text = qsTr("a new user was added!")
                message_box.dia_title = qsTr("Add Success")
                message_box.open()
            }
        }

        onEmitDeleteAccountRst: {
            if (status === 0) {
                message_box.dia_type = 0
                message_box.dia_title = qsTr("Delete Error")
                message_box.dia_text = qsTr("user name has exited !")
                message_box.open()
            } else if (status === 1) {
                message_box.dia_type = 1
                message_box.dia_text = qsTr("delete success")
                message_box.dia_title = qsTr("Delete Success")
                message_box.open()
            }
        }

        onEmitUpdateAccountRst: {
            if (status === 0) {
                message_box.dia_title = qsTr("update error")
                message_box.dia_text = message
                message_box.dia_type = 0
                message_box.open()
            } else if (status === 1) {
                message_box.dia_type = 1
                message_box.dia_title = qsTr("update success")
                message_box.dia_text = qsTr("password had be changed!!!")
                message_box.open()
            }
        }
    }
}
