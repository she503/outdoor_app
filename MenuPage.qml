import QtQuick 2.0
import QtQuick.Controls 2.2

ListView {
    id: list_view
    signal mainPageChanged(var current_index)

    property real last_index: 0
    property int level: -1

    function setTaskPageIndex(current_index)
    {
        if (level > 1) {
            if (current_index === 1) {
                stack_view.replace(user_manage_page)
                list_view.last_index = current_index
            } else if (current_index === 2) {
                setCannotOperatorTask()
            }
        } else {
            if (current_index === 1) {
                setCannotOperatorTask()
            } else if (current_index === 2) {
                stack_view.replace(help_document_page)
            }
        }
    }
    function setCannotOperatorTask()
    {
        if (message_view.has_error == true) {
            list_view.currentIndex = list_view.last_index
            stack_menu.replace(list_view)
        } else {
            stack_view.replace(task_settings_page)
            map_task_manager.judgeIsMapTasks()
            map_task_manager.getFirstMap()
        }
//        stack_menu.replace(task_process_page) // delet
    }

    Connections {
        target: account_manager
        onEmitLevel: {
            list_view.level = level
            if (level <= 1) {
                user_lit_model.append({"id_num": 0, "focus_source": "qrc:/res/pictures/home.png"})
                user_lit_model.append({"id_num": 1, "focus_source": "qrc:/res/pictures/TASKSETTING-button.png"})
                user_lit_model.append({"id_num": 2, "focus_source": "qrc:/res/pictures/help.png"})
                user_lit_model.append({"id_num": 3, "focus_source": "qrc:/res/pictures/about.png"})
            } else {
                user_lit_model.append({"id_num": 0, "focus_source": "qrc:/res/pictures/home.png"})
                user_lit_model.append({"id_num": 4, "focus_source": "qrc:/res/pictures/user.png"})
                user_lit_model.append({"id_num": 1, "focus_source": "qrc:/res/pictures/TASKSETTING-button.png"})
                user_lit_model.append({"id_num": 2, "focus_source": "qrc:/res/pictures/help.png"})
                user_lit_model.append({"id_num": 3, "focus_source": "qrc:/res/pictures/about.png"})
            }
        }
    }

    //            anchors.fill: parent
    spacing: height * 0.002
    currentIndex: 0
    highlight: Rectangle {color: "transparent"}
    clip: true
    highlightFollowsCurrentItem: false
    delegate: ItemDelegate {
        id: item
        height: list_view.level <= 1 ? list_view.height / 4 : list_view.height / 5
        width: parent.width
        property real id_num: model.id_num
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            Image {
                id: img_background
                source: model.focus_source
                anchors.fill: parent
                opacity: item.focus ? 1: 0.3
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
            }
        }

        onClicked: {
            list_view.currentIndex = index
            list_view.mainPageChanged(model.id_num)
        }
    }
    model: ListModel {
        id: user_lit_model
    }
}