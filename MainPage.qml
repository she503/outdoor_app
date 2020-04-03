import QtQuick 2.9
import QtQuick.Controls 2.2
import "CustomControl"

Rectangle {
    id: root

    color: "transparent"

    property Component user_manage_page: UserManagePage {}
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }
    signal mainPageChanged(var current_index)


    //to do
    Connections {
        target: map_task_manager
        onUpdateMapAndTaskInfo: {
            stack_menu.replace(task_process_page)
        }
    }
    Connections {
        target: map_task_manager
        onUpdateStopTaskInfo: {
            if (status === 1) {
                root.mainPageChanged(0)
                stack_menu.replace(list_view)
                list_view.currentIndex = 0

            }
        }
    }
    onMainPageChanged: {
        if (current_index === 0) {
            stack_view.replace(home_page)
        } else if (current_index === 1) {
            stack_view.replace(user_manage_page)
        } else if (current_index === 2) {
            stack_view.replace(task_settings_page)
            map_task_manager.judgeIsMapTasks()
            map_task_manager.getFirstMap()
        } else if (current_index === 3) {
            stack_view.replace(help_document_page)
        } else if (current_index === 4) {
            stack_view.replace(about_machine_page)
        }
        task_settings_page.checked_tasks_name = []
    }

    HomePage {
        id: home_page
        onSigEyeBtnPress: {
            if ( map_task_manager.getIsWorking() ) {
                stack_menu.replace(list_view)
                root.mainPageChanged(2)
            } else {
                dialog_working_states.open()
            }


        }
    }
    TaskSettingsPage {
        id: task_settings_page
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

        MessageViewPage {
            id: message_view
            height: parent.height * 0.8
            width: height
            anchors {
                right: parent.right
                rightMargin: height *0.6
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
            id: stack_menu
            anchors.fill: parent
            initialItem: list_view

            replaceEnter: Transition {

            }
            replaceExit: Transition {

            }
        }

        ListView {
            id: list_view
            //            anchors.fill: parent
            spacing: height * 0.002
            currentIndex: 0
            highlight: Rectangle {color: "transparent"}
            clip: true
            highlightFollowsCurrentItem: false
            delegate: ItemDelegate {
                id: item
                height: list_view.height / 5
                width: height * 2.5
                property real id_num: model.id_num
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Image {
                        id: img_background
                        source: model.focus_source
                        opacity: list_view.currentIndex == item.id_num ? 1 : 0.3
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                    }
                }

                onClicked: {
                    list_view.currentIndex = index
                    mainPageChanged(list_view.currentIndex)
                }
            }
            model: ListModel {
                ListElement {
                    id_num: 0
                    focus_source: "qrc:/res/pictures/home.png"
                }
                ListElement {
                    id_num: 1
                    focus_source: "qrc:/res/pictures/user.png"
                }
                ListElement {
                    id_num: 2
                    focus_source: "qrc:/res/pictures/setting.png"
                }
                ListElement {
                    id_num: 3
                    focus_source: "qrc:/res/pictures/help.png"
                }
                ListElement {
                    id_num: 4
                    focus_source: "qrc:/res/pictures/about.png"
                }
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

            onSigStopBtnPress: {

            }

            onSigEndingBtnPress: {

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
        dia_title: qsTr("Error")
        dia_content: qsTr("There is no task is working, you can click the \"setting\" btn to create one!")
    }

    //    TLDialog {
    //        id: dialog_machine_back
    //        width: root.width * 0.4
    //        height: root.height * 0.4
    //        x: (root.width - width) / 2
    //        y: (root.height - height) / 2
    //        dia_title: qsTr("Back!")
    //        dia_title_color: "#4F94CD"
    //        dia_image_source: "qrc:/res/pictures/smile.png"
    //        onOkClicked: {
    //            dialog_machine_back.close()
    //        }
    //    }
}
