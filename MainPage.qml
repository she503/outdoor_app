import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "CustomControl"

Rectangle {
    id: root

    color: "transparent"
    property Component user_manage_page: UserManagePage {}
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }

    Component{
        id: home_page
        HomePage {

            onCenterBtnPress: {
                if (list_view.cant_clicked_task) {

                } else {
                    if (status <= 2) {
                        home_page._text_visible = false
                        if (account_manager.getCurrentUserLevel() <= 1) {
                            list_view.currentIndex = 1
                        } else {
                            list_view.currentIndex = 2
                        }
                        menu_stack.replace(list_view)
                        list_view.mainPageChanged(1)
                    } else if (status >= 3) {
                        home_page._text_visible = true
                        menu_stack.replace(task_process_page)
                        list_view.mainPageChanged(1)
                    }
                }
            }
        }
    }
    TaskSettingsPage {
        id: task_settings_page
        visible: false
        width: rect_right.width
        height: rect_right.height
        onChoose_map_nameChanged: {
            task_process_page.map_name = task_settings_page.choose_map_name
        }
        onWork_timeChanged: {
            task_process_page.work_time = task_settings_page.work_time
        }
        onStartTaskLock: {
            verify_password_page.pop_lock.open()
        }
    }
    VerifyPasswordPage {
        id: verify_password_page
        anchors.fill: parent
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
        }
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
            id: menu_stack
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
                } else if (current_index === 2) {
                    stack_view.replace(help_document_page)
                } else if (current_index === 3) {
                    stack_view.replace(about_machine_page)
                }
                task_settings_page.checked_tasks_name = []
            }
        }

        TaskProcess {
            id:task_process_page
            visible: false
            onSigBackBtnPress: {
                list_view.currentIndex = 0
                menu_stack.replace(list_view)
                stack_view.replace(home_page)
            }
            onStopTaskCommond: {
                task_settings_page.timer_task_timing.stop()
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
}
