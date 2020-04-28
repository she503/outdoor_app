import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "./customControl"
import "./user"

Rectangle {
    id: root

    color: "transparent"
    property Component user_manage_page: UserManagePage {}
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }
    property Component verify_password_page: VerifyPasswordPage { }
    property Component message_view: MonitorMessagePage { }
    property Component task_settings_page: TaskSettingsPage{
        onStartTaskLock: {
            verify_password_page.pop_lock.open()
        }
    }
    property Component home_page: HomePage{
        onCenterBtnPress: {
            var status = status_manager.getWorkStatus()
            if (status < 5) {
                menu_stack.tlReplace(list_view)
                list_view.currentIndex = 2
            } else if (status === 5) {
                menu_stack.tlReplace(task_process_page)
            }
            list_view.mainPageChanged(1)
        }
    }


    TaskProcess {
       id: task_process_page
        onSigBackBtnPress: {
            list_view.currentIndex = 0
            menu_stack.tlReplace(list_view)
            stack_view.tlReplace(home_page)
        }
        onStopTaskCommond: {
            task_settings_page.timer_task_timing.stop()
        }
    }
    Connections {
        target: status_manager
        onWorkStatusUpdate: {
            if (status < 5) {
                menu_stack.tlReplace(list_view)
                list_view.currentIndex = 2
            } else if (status === 5) {
                menu_stack.tlReplace(task_process_page)
            }
        }
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
            function tlReplace(item) {
                if (menu_stack.currentItem === item) {
                    return;
                } else {
                    replace(item)
                }
            }
            replaceEnter: Transition {

            }
            replaceExit: Transition {

            }
        }

        MenuPage {
            id: list_view
            onMainPageChanged: {
                if (current_index === 0) {
                    stack_view.tlReplace(home_page)
                } else if (current_index === 4) {
                    stack_view.tlReplace(user_manage_page)
                } else if (current_index === 1) {
                    if (status_manager.getWorkStatus() === 5) {
                        menu_stack.tlReplace(task_process_page)
                    } else {
                        menu_stack.tlReplace(list_view)
                    }
                    stack_view.tlReplace(task_settings_page)
                } else if (current_index === 2) {
                    stack_view.tlReplace(help_document_page)
                } else if (current_index === 3) {
                    stack_view.tlReplace(about_machine_page)
                }

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

            function tlReplace(item) {
                if (stack_view.currentItem === item) {
                    return;
                } else {
                    replace(item)
                }
            }

            replaceEnter: Transition {

            }
            replaceExit: Transition {

            }
        }
    }
}
