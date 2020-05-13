import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "./homemade_components"
import "./user_manager"
import "./map_task_manager"
import "./mapping"

Rectangle {
    id: root

    color: "transparent"
    property Component user_manage_page: UserManagePage {}
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }

    property Dialog work_done_widget: WorkDone {
        x: (parent.parent.width - width ) /2
        y: (parent.parent.height - height) / 2
    }
    property Component task_settings_page: TaskSettingsPage{
        onStartTaskLock: {
            lock_screen_page.pop_lock.open()
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

    MappingPage {
        id: mapping_page
        width: rect_right.width
        height:rect_right.height

    }

    LockScreenPage { id: lock_screen_page}


    Component.onCompleted: {
        map_task_manager.setWorkMapName(map_task_manager.getCurrentMapName())
    }


    TaskProgressPage {
       id: task_process_page
        onSigBackBtnPress: {
            list_view.currentIndex = 0
            menu_stack.tlReplace(list_view)
            stack_view.tlReplace(home_page)
        }
        onSigWorkDown: {
            work_done_widget.open()
        }
    }


    Connections {
        target: map_task_manager
        onEmitWorkDone: {
            work_done_widget.open()
        }
    }

    Connections {
        target: status_manager
        onWorkStatusUpdate: {
            if (status <= 1) {
                list_view.currentIndex = 2
                menu_stack.tlReplace(list_view)
            } else if (status > 1 && status < 5) {
                menu_stack.tlReplace(list_view)
            } else if (status === 5) {
                menu_stack.tlReplace(task_process_page)
            }
        }
    }

    Image {
        id: img_main_background
        source: "qrc:/res/ui/background/main.png"
        anchors.fill: parent
    }



    Rectangle {
        id: rect_title
        width: parent.width - rec_left.width
        height: parent.height * 0.1
        color: "transparent"
        anchors.left: rec_left.right
        MissonBordPage {
            id: misson_bord
            width: parent.width
            height: parent.height
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            onLockScreen: {
                lock_screen_page.pop_lock.open()
            }
        }
    }


    Rectangle {
        id: rec_left
        width: height * 0.5
        height: parent.height
        color: "transparent"
        Image {
            id: menu_background
            source: "qrc:/res/ui/background/menu.png"
            anchors.fill: parent
            z:0
        }
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
            z: 1
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
//                    menu_stack.tlReplace(task_process_page)
                    stack_view.tlReplace(task_settings_page)
                } else if (current_index === 2) {
                    stack_view.tlReplace(help_document_page)
                } else if (current_index === 3) {
                    stack_view.tlReplace(about_machine_page)
                } else if (current_index === 5) {
                    stack_view.tlReplace(mapping_page)
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
