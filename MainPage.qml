import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "CustomControl"

Rectangle {
    id: root

    color: "transparent"

    property Component home_page: HomePage {
        onViewTask: {
            stack_view.replace(task_settings_page)
        }
    }
    property Component user_manage_page: UserManagePage { }
    property Component task_settings_page: TaskSettingsPage {
        onBackToHomePage: {
            stack_view.replace(home_page)
        }
        Component.onCompleted: {
            socket_manager.getMapsName()
        }
    }
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }

    signal backToHomePage()
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
            id: rec_left
            height: parent.height
            width: height / 5 * 2.4
            color: "red"
            Rectangle {
                id: rec_turn_view
                visible: false
                anchors.fill: parent
                color: "transparent"
                TLInfoDisplayPage {
                    id: rect_info_display
                    width: parent.width
                    height: parent.height * 0.3
                }
                Rectangle {
                    id: rec_pic_car
                    width: parent.width
                    height:  parent.height * 0.5
                    anchors.top: rect_info_display.bottom
                    anchors.left: parent.left
                    color: "transparent"
                    Rectangle {
                        id: rec_power_control
                        width: parent.width
                        height: parent.height * 0.3
                        color: "transparent"
                        Row {
                            anchors.fill: parent
                            Rectangle {
                                width: parent.width / 3
                                height: parent.height
                                color: "transparent"
                                Image {
                                    id: pic_back
                                    width: 60 * rate * ratio
                                    height: 60 * rate * ratio
                                    source: "qrc:/res/pictures/back.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            dialog_machine_back.open()
                                        }
                                    }
                                }
                            }
                            Rectangle {
                                id: rec_machine_state
                                width: parent.width / 3
                                height: parent.height
                                color: "transparent"
                                Image {
                                    id: pic_ok
                                    visible: !has_error
                                    width: 50 * rate * ratio
                                    height: 50 * rate * ratio
                                    source: "qrc:/res/pictures/finish.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                }
                                Image {
                                    id: pic_warn
                                    visible: has_error
                                    width: 50 * rate * ratio
                                    height: 50 * rate * ratio
                                    source: "qrc:/res/pictures/warn.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            dialog_machine_warn.open()
                                        }
                                    }
                                }
                            }
                            Rectangle {
                                id: rec_progress_state
                                width: parent.width / 3
                                height: parent.height
                                color: "transparent"
                                property bool is_processing: false
                                Image {
                                    id: pic_task_stop
                                    visible: !rec_progress_state.is_processing
                                    width: 50 * rate * ratio
                                    height: 50 * rate * ratio
                                    source: "qrc:/res/pictures/progress_stop.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (rec_progress_state.is_processing) {
                                                rec_progress_state.is_processing = false
                                            } else {
                                                rec_progress_state.is_processing = true
                                            }
                                        }
                                    }
                                }
                                Image {
                                    id: pic_task_start
                                    visible: rec_progress_state.is_processing
                                    width: 60 * rate * ratio
                                    height: 60 * rate * ratio
                                    source: "qrc:/res/pictures/progress_start.png"
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (rec_progress_state.is_processing) {
                                                rec_progress_state.is_processing = false
                                            } else {
                                                rec_progress_state.is_processing = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: rec_car_icon
                        width: parent.width
                        height: parent.height * 0.7
                        anchors.top: rec_power_control.bottom
                        color: "transparent"
                        Image {
                            id: pic_car
                            source: "qrc:/res/pictures/logo.png"
                            width: 120 * rate * ratio
                            height: 120 * rate * ratio
                            anchors.centerIn:  parent
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                }
            }

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
                    width: height * 2.4
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
            z: -1
            width: parent.width - rec_left.width
            height: parent.height
            color:"transparent"
            anchors.left: rec_left.right
            Layout.minimumWidth: parent.width * 0.1
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
            backToHomePage()
            dialog_machine_back.close()
        }
    }

}
