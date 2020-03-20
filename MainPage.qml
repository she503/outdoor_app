import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Control_14
import "CustomControl"

Rectangle {
    id: root

    color: "transparent"
    signal backToHomePage()

    property real ratio: Math.sqrt(Math.min(rec_left.width / 3, rec_power_control.height)) * 0.1
    property var text_process: ["map1#", "1h", "80%", "20min"]
    property bool turn_task_page: false

    property Component home_page: HomePage { }
    property Component user_manage_page: UserManagePage { }
    property Component task_settings_page: TaskSettingsPage {
        onBackToHomePage: {
            stack_view.replace(home_page)
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
            turn_task_page = false
            stack_view.replace(task_settings_page)
            socket_manager.connectToHost("192.168.8.143", "32432")
            socket_manager.sendAllPower(true)
        } else if (current_index === 3) {
            stack_view.replace(help_document_page)
        } else if (current_index === 4) {
            stack_view.replace(about_machine_page)
        }
    }
    onTurn_task_pageChanged: {
        if (turn_task_page) {
            rec_turn_view.visible = true
            list_view.visible = false
        } else {
            list_view.visible = true
            rec_turn_view.visible = false
        }
    }

    Rectangle {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "qrc:/res/pictures/background_all.png"
        }
    }
    Control_14.SplitView {
        id: split_view
        anchors.fill: parent
        orientation: Qt.Horizontal
        Rectangle {
            id: rec_left
            width: parent.width * 0.25
            height: parent.height
            color: "white"
            Layout.minimumWidth: parent.width * 0.1
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
                Rectangle {
                    id: rec_peocess
                    width: parent.width
                    height:  parent.height * 0.2
                    anchors.top: rec_pic_car.bottom
                    anchors.left: parent.left
                    Column {
                        Repeater {
                            model: ["Current map: ", "Worked hours: ", "Finished: ", "Estimated time: "]
                            Rectangle {
                                width: rec_peocess.width
                                height: rec_peocess.height * 0.25
                                Text {
                                    anchors {
                                        top: parent.top
                                        left: parent.left
                                        leftMargin: rec_peocess.width * 0.05
                                    }
                                    text: qsTr(modelData + "  " + text_process[index])
                                    font.pixelSize: rate * 15 * ratio
                                }
                            }
                        }
                    }
                }
            }

            ListView {
                id: list_view
                anchors.fill: parent
                spacing: height * 0.002
                currentIndex: -1
                delegate: ItemDelegate {
                    width: list_view.width
                    height: list_view.height / 8
                    highlighted: ListView.isCurrentItem
                    Row {
                        id: row
                        width: parent.width
                        height: parent.height * 0.99
                        Image {
                            id: img_logo
                            width: parent.width * 0.2
                            height: parent.height
                            source: sourcee
                            fillMode: Image.PreserveAspectFit
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                        }

                        Rectangle {
                            width: parent.width * 0.5
                            height: parent.height

                            Text {
                                id: model_name
                                clip: true
                                text: "  " + model.name
                                objectName: model.obj_name
                                width: parent.width
                                height: parent.height * 0.6
                                font.bold: true
                                font.pixelSize: height * 0.7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                id: description
                                text: " " + model.text_description
                                clip: true
                                width: parent.width
                                height: parent.height * 0.3
                                font.pixelSize: height * 0.5
                                anchors {
                                    top: model_name.bottom
                                }
                            }
                            color: "transparent"
                        }
                        Image {
                            id: img_right
                            width: parent.width * 0.2
                            height: parent.height
                            source: "qrc:/res/pictures/arrow-right.png"
                            fillMode: Image.PreserveAspectFit
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                        }
                    }
                    onClicked: {
                        list_view.currentIndex = index
                        mainPageChanged(list_view.currentIndex)
                    }
                    Rectangle {
                        width: parent.width
                        height: parent.height * 0.01
                        color: "gray"
                    }
                }
                model: ListModel {
                    ListElement {
                        obj_name: "home"
                        name: qsTr("home")
                        text_description: qsTr("homeeeee")
                        sourcee: "qrc:/res/pictures/home.png"
                    }
                    ListElement {
                        obj_name: "user"
                        name: qsTr("user")
                        text_description: qsTr("userrrr")
                        sourcee: "qrc:/res/pictures/User.png"
                    }
                    ListElement {
                        obj_name: "setting"
                        name: qsTr("setting")
                        text_description: qsTr("setting ")
                        sourcee: "qrc:/res/pictures/setting.png"
                    }
                    ListElement {
                        obj_name: "help"
                        name: qsTr("help")
                        text_description: qsTr("helppp")
                        sourcee: "qrc:/res/pictures/help.png"
                    }
                    ListElement {
                        obj_name: "about"
                        name: qsTr("about")
                        text_description: qsTr("abouttttt")
                        sourcee: "qrc:/res/pictures/about.png"
                    }
                }
            }
        }
        Rectangle {
            id: rect_right
            z: -1
            width: parent.width * 0.75
            height: parent.height
            color:"transparent"
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
        dia_image_source: "qrc:/res/pictures/smile.png"
        onOkClicked: {
            backToHomePage()
            dialog_machine_back.close()
        }
    }

}
