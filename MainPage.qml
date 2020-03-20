import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as Control_14
Rectangle {
    id: root

    color: "transparent"
    property Component home_page: HomePage { }
    property Component user_manage_page: UserManagePage { }
    property Component task_settings_page: TaskSettingsPage { }
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }
    signal mainPageChanged(var current_index)
    onMainPageChanged: {
        if (current_index === 0) {
            stack_view.replace(home_page)
        } else if (current_index === 1) {
            stack_view.replace(user_manage_page)
        } else if (current_index === 2) {
            stack_view.replace(task_settings_page)
        } else if (current_index === 3) {
            stack_view.replace(help_document_page)
        } else if (current_index === 4) {
            stack_view.replace(about_machine_page)
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
        anchors {
            top: rect_title.bottom
        }
        width: parent.width
        height: parent.height - rect_title.height

        color: "transparent"

        Rectangle {
            id: rect_left
            height: parent.height
            width: height / 5 * 2.4
            color: "transparent"

            ListView {
                id: list_view
                anchors.fill: parent
                spacing: height * 0.002
                currentIndex: 0
                highlight: Rectangle {color: "transparent"}
                clip: true
                delegate: ItemDelegate {
                    id: item
                    height: list_view.height / 5
                    width: height * 2.4
                    property real id_num: model.id_num

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        Image {
                            id: img_background
                            source: list_view.currentIndex == item.id_num ? model.focus_source : model.no_focus_source
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
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
                        focus_source: "qrc:/res/pictures/home_focus.png"
                        no_focus_source: "qrc:/res/pictures/home_no.png"

                    }
                    ListElement {
                        id_num: 1
                        focus_source: "qrc:/res/pictures/user_focus.png"
                        no_focus_source: "qrc:/res/pictures/user_no.png"
                    }
                    ListElement {
                        id_num: 2
                        focus_source: "qrc:/res/pictures/setting_focus.png"
                        no_focus_source: "qrc:/res/pictures/setting_no.png"
                    }
                    ListElement {
                        id_num: 3
                        focus_source: "qrc:/res/pictures/help_focus.png"
                        no_focus_source: "qrc:/res/pictures/help_no.png"
                    }
                    ListElement {
                        id_num: 4
                        focus_source: "qrc:/res/pictures/about_focus.png"
                        no_focus_source: "qrc:/res/pictures/about_no.png"
                    }
                }
            }
        }

        Rectangle {
            id: rect_right
            z: -1
            width: parent.width - rect_left.width
            height: parent.height
            color:"transparent"
            anchors.left: rect_left.right
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
}
