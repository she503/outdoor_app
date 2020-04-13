import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "CustomControl"

Rectangle {
    id: root


    property alias root_main: root
    color: "transparent"
    property Component user_manage_page: UserManagePage {}
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }


    //to do
    Connections {
        target: map_task_manager
        onUpdateMapAndTaskInfo: {
            stack_menu.replace(task_process_page)
            stack_view.replace(task_settings_page)
            home_page.text_visible = true

        }
    }
    Connections {
        target: map_task_manager
        onUpdateStopTaskInfo: {
            if (status === 1) {
                list_view.mainPageChanged(0)
                stack_menu.replace(list_view)
                list_view.currentIndex = 0
                home_page.text_visible = false
            }
        }
    }


    HomePage {
        id: home_page

        onCenterBtnPress: {
            if (list_view.cant_clicked_task) {

            } else {
                if (status <= 2) {
                    home_page.text_visible = false
                    if (account_manager.getCurrentLevel() <= 1) {
                        list_view.currentIndex = 1
                    } else {
                        list_view.currentIndex = 2
                    }
                    stack_menu.replace(list_view)
                    list_view.mainPageChanged(1)
                } else if (status >= 3) {
                    home_page.text_visible = true
                    stack_menu.replace(task_process_page)
                    list_view.mainPageChanged(1)
                }
            }
        }
    }
    TaskSettingsPage {
        id: task_settings_page
        visible: false
        width: rect_right.width
        height: rect_right.height

    }

    Image {
        id: img_main_background
        source: "qrc:/res/pictures/main_background.png"
        anchors.fill: parent
    }

    Rectangle {
        id: rect_title
        width: parent.width
        height: parent.height * 0.082
        color: "transparent"

        MonitorMessagePage {
            id: message_view
            height: parent.height * 0.8
            width: height * 3
            anchors {
                right: rect_title.right
                rightMargin: height * 0.6
                verticalCenter: parent.verticalCenter
            }
            onLockScreen: {
                message_view.is_locked = true
                verify_password_page.pop_lock.open()
            }
            onCannotOperatorTask: {
                list_view.cant_clicked_task = true
                list_view.mainPageChanged(0)
                list_view.currentIndex = 0
            }
        }
    }
    VerifyPasswordPage {
        id: verify_password_page
        anchors.fill: parent
    }

    Rectangle {
        id: rec_left
        anchors {
            top: rect_title.bottom
        }
        width: height * 0.5
        height: parent.height - rect_title.height
        color: "transparent"

        StackView {
            id: stack_menu
            anchors.fill: parent
            initialItem: list_view

            replaceEnter: Transition {

            }
            replaceExit: Transition {

            }
        }

        MenuPage {
            id: list_view
            onMainPageChanged: {
                if (current_index === 0) {
                    stack_view.replace(home_page)
                } else if (current_index === 4) {
                    stack_view.replace(user_manage_page)
                } else if (current_index === 1) {
                    task_settings_page.visible = true
                    stack_view.replace(task_settings_page)
                    map_task_manager.judgeIsMapTasks()
                    map_task_manager.getFirstMap()
                } else if (current_index === 2) {
                    stack_view.replace(help_document_page)
                } else if (current_index === 3) {
                    stack_view.replace(about_machine_page)
                }
                task_settings_page.checked_tasks_name = []
            }
        }

        TaskProcess{
            id:task_process_page
            visible: false
            onSigBackBtnPress: {
                list_view.currentIndex = 0
                stack_menu.replace(list_view)
                stack_view.replace(home_page)
            }
        }
    }

    Rectangle {
        id: rect_right
        width: parent.width - rec_left.width
        height: parent.height - rect_title.height
        color:"transparent"
        anchors{
            top: rect_title.bottom
            left: rec_left.right
        }
        StackView {
            id: stack_view
            anchors.fill: parent
            initialItem: home_page

            replaceEnter: Transition {

            }
            replaceExit: Transition {

            }
        }
    }


    TLDialog {
        id: dialog_working_states
    }
}
