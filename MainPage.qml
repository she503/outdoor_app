import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "CustomControl"

Rectangle {
    id: root

    color: "transparent"
    signal backToHomePage()
    property var text_process: ["map1#", "1h", "80%", "20min"]
    property bool turn_task_page: false
    property var error_message: []

    property Component home_page: HomePage {   }
    property Component user_manage_page: UserManagePage { }
    property Component task_settings_page: TaskSettingsPage {
        Component.onCompleted: {
            socket_manager.getMapsName()
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
        Button {
            id: btn_error
//            visible: has_error
            height: parent.height * 0.8
            width: height
            anchors {
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
            background: Rectangle {
                implicitWidth: 83
                implicitHeight: 37
                color: "transparent"
                radius: width / 2
                Image {
                    anchors.fill: parent
                    source: "qrc:/res/pictures/warn.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
            onClicked: {
                if(draw_error.visible){
                    draw_error.close()
                }else{
                    draw_error.open()
                }
            }
        }
    }
    Drawer {
        id: draw_error
        visible: false
        y: rect_title.height
        width: parent.width / 2
        height: parent.height / 2
        modal: true
        dim: false
        edge: Qt.RightEdge
        closePolicy: Popup.NoAutoClose | Popup.CloseOnPressOutside
        background: Rectangle{
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/background_glow1.png"
            }
        }
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: parent.height * 0.88
            color: "transparent"
            Rectangle {
                id: rec_message_head
                width: parent.width
                height: parent.height * 0.1
                color: "transparent"
                Text {
                    text: qsTr("message:")
                    width: parent.width
                    height: parent.height
                    font.pixelSize: parent.height * 0.6
                }
            }
            Rectangle {
                id: rec_message_info
                width: parent.width
                height: parent.height * 0.9
                anchors.top: rec_message_head.bottom
                border.width: 1
                border.color: "grey"
                color: "transparent"
                Column {
                    spacing: 5
                    Repeater {
                        model: 4
                        Rectangle {
                            width:  rec_message_info.width
                            height: 20
                            color: "transparent"
                            Text {
                                text: qsTr("error code status:  " + index)
                                width: parent.width
                                height: parent.height
                                font.pixelSize: parent.height * 0.5
                                verticalAlignment: Text.AlignVCenter
                                anchors.left: parent.left
                                anchors.leftMargin: parent.height * 0.5
                            }
                        }
                    }
                }
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
