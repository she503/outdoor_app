import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "./homemade_components"
import "./user_manager"
import "./map_task_manager"
import "./mapping"

Rectangle {
    id: root

    signal sigBackBtnPress()

    onSigBackBtnPress: {
        list_view.currentIndex = 0
        list_view.mainPageChanged(0)
    }

    color: "transparent"
    property int stack_view_index: 0
    property Component user_manage_page: UserManagePage {}
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }


    property Component task_settings_page: TaskSettingsPage {
        onStartTaskLock: {
            lock_screen_page.pop_lock.open()
        }
        onSigBackBtnPress: {
            root.sigBackBtnPress()
        }
        onSigEndWork: {
            work_done_widget.btn_stop_pressed = true
        }
    }

    MappingPage {
        id: mapping_page
        width: stack_view.width
        height:stack_view.height

    }

    LockScreenPage { id: lock_screen_page}

    WorkDone {
        id: work_done_widget
        onSigBackBtnPress: {
            root.sigBackBtnPress()
        }
    }

    Component.onCompleted: {
        var status = status_manager.getWorkStatus()
        if (status === status_manager.getWorkingID()) {
            misson_bord.showMessagePics(true)
        } else {
            misson_bord.showMessagePics(false)
        }
    }

    Connections {
        target: status_manager
        onWorkStatusUpdate: {
            misson_bord.showMessagePics(false)
            if (status <= status_manager.getNoneWorkID()) {
                list_view.currentIndex = 2
                menu_stack.tlReplace(list_view)
            } else if (status > status_manager.getNoneWorkID() && status < status_manager.getWorkingID()) {
                menu_stack.tlReplace(list_view)
            } else if (status === status_manager.getWorkingID()) {
                misson_bord.showMessagePics(true)
            }

            if (status_manager.getWorkStatus() >= status_manager.getWorkingID() && root.stack_view_index === 1) {
                rec_left.width = 0
            } else {
                rec_left.width = rec_left.height * 0.4
            }
        }
    }

    Image {
        id: img_main_background
        source: "qrc:/res/ui/background/main.png"
        anchors.fill: parent
    }

    Rectangle {
        id: home_page
        color: "transparent"
        HomePage{
            id: home_page_1
            anchors.fill: parent
            onCenterBtnPress: {
                list_view.currentIndex = 2
                list_view.mainPageChanged(1)
            }
        }
    }

    Row {
        anchors.fill: parent
        Rectangle {
            id: rec_left
            width: height * 0.4
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
                visible: false
                onMainPageChanged: {
                    if (current_index === 0) {
                        stack_view.tlReplace(home_page)
                    } else if (current_index === 4) {
                        stack_view.tlReplace(user_manage_page)
                    } else if (current_index === 1) {
                        if (status_manager.getWorkStatus() === status_manager.getWorkingID()) {
                        } else {
                            menu_stack.tlReplace(list_view)
                        }
                        stack_view.tlReplace(task_settings_page)
                    } else if (current_index === 2) {
                        stack_view.tlReplace(help_document_page)
                    } else if (current_index === 3) {
                        stack_view.tlReplace(about_machine_page)
                    } else if (current_index === 5) {
                        stack_view.tlReplace(mapping_page)
                    }
                    if (status_manager.getWorkStatus() >= status_manager.getWorkingID() && current_index === 1) {
                        rec_left.width = 0
                    } else {
                        rec_left.width = rec_left.height * 0.4
                    }

                    root.stack_view_index = current_index
                }
            }
        }

        Rectangle {
            id: rect_right
            width: parent.width - rec_left.width
            height: parent.height
            color:"transparent"
            MissonBordPage {
                id: misson_bord
                width: parent.width
                height: parent.height * 0.1
                anchors {
                    left: parent.left
                    top: parent.top
                }
                onLockScreen: {
                    lock_screen_page.pop_lock.open()
                }
                Image {
                    id: img_mission
                    anchors.fill: parent
                    source: "qrc:/res/ui/background/mission_bar.png"
                    fillMode: Image.PreserveAspectCrop
                }
            }
            StackView {
                id: stack_view
                width: parent.width
                height: parent.height - misson_bord.height
                anchors.top: misson_bord.bottom
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
}
