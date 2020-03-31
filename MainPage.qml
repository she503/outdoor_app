import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "CustomControl"

Rectangle {
    id: root

    color: "transparent"

    property Component home_page: HomePage {   }
    property Component user_manage_page: UserManagePage { }
    TaskSettingsPage {
        id: task_settings_page
        Component.onCompleted: {
            map_task_manager.getMapsName()
        }
    }
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
        id: rec_left
        anchors {
            top: rect_title.bottom
        }
        width: height * 0.5
        height: parent.height - rect_title.height
        color: "transparent"

        ListView {
            id: list_view
            anchors.fill: parent
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
        id: dialog_machine_warn
        width: root.width * 0.4
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Warn!")
        dia_title_color: "red"
        dia_image_source: "qrc:/res/pictures/sad.png"
        is_single_btn: true
        onOkClicked: {
            dialog_machine_warn.close()
        }
    }
    TLDialog {
        id: dialog_machine_back
        width: root.width * 0.4
        height: root.height * 0.4
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Back!")
        dia_title_color: "#4F94CD"
        dia_image_source: "qrc:/res/pictures/smile.png"
        onOkClicked: {
            dialog_machine_back.close()
        }
    }
}
