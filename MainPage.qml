import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0

Page {
    id: root
    width: parent.width
    height: parent.height
    property real listHeight: parent.height / 12
    property real fontPixSize: 12

    SplitView {
        id:split
        z:2
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        orientation: Qt.Horizontal
        resizing: true

        Rectangle{
            id: left_rect
            z: 8
            width: parent.width * 0.3
            height: parent.height
            anchors.left: parent.left

            Rectangle{
                id: rec_list_view
                anchors.fill: parent

                Column{
                    id: page
                    Rectangle{
                        width: rec_list_view.width
                        height: 1
                        color: "#f0f0f0"
                    }
                    Rectangle{
                        id: home_page
                        width: rec_list_view.width
                        height: listHeight
                        Image {
                            id: pic_home
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/images/home.png"
                            sourceSize { width: side * 30; height: side * 30}
                        }
                        Text {
                            text: qsTr("home page")//主页
                            anchors.left: pic_home.right
                            anchors.leftMargin: fontPixSize
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: fontPixSize
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if (stack_right_view.depth < 2) {
                                    stack_right_view.replace(stack_right_view.initialItem)
                                } else {
                                    stack_right_view.pop()
                                }
                            }
                        }
                        Image {
                            source: "qrc:/images/right_dash.png"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            sourceSize { width: side * 30; height:  side * 30}
                        }
                    }
                    //split
                    Rectangle{
                        z: 2
                        width: left_rect.width
                        height: 1
                        color: "#f0f0f0"
                    }
                    Rectangle{
                        id: user_manage
                        width: rec_list_view.width
                        height: listHeight
                        Image {
                            id: pic_user_manage
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/images/user_manager.png"
                            sourceSize { width: side * 30; height: side * 30}
                        }
                        Text {
                            text: qsTr("user manage")//用户管理
                            anchors.left: pic_user_manage.right
                            anchors.leftMargin: fontPixSize
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: fontPixSize
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if (stack_right_view.depth < 2) {
                                    stack_right_view.replace(user_manage_layout)
                                } else {
                                    stack_right_view.pop()
                                }
                            }
                        }
                        Image {
                            source: "qrc:/images/right_dash.png"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            sourceSize { width: side * 30; height:  side * 30}
                        }
                    }
                    //split
                    Rectangle{
                        z: 2
                        width: rec_list_view.width
                        height: 1
                        color: "#f0f0f0"
                    }

                    Rectangle{
                        id:task_config
                        width: rec_list_view.width
                        height: listHeight
                        Image {
                            id: pic_task_config
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/images/task_configuration.png"
                            sourceSize { width: side * 30; height: side * 30}
                        }
                        Text {
                            text: qsTr("task config")//任务配置
                            anchors.left: pic_task_config.right
                            anchors.leftMargin: fontPixSize
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: fontPixSize
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if (stack_right_view.depth < 2) {
                                    stack_right_view.replace(task_config_layout)
                                } else {
                                    stack_right_view.pop()
                                }
                            }
                        }
                        Image {
                            source: "qrc:/images/right_dash.png"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            sourceSize { width: side * 30; height:  side * 30}
                        }
                    }
                    Rectangle{
                        z: 2
                        width: rec_list_view.width
                        height: 1
                        color: "#f0f0f0"
                    }

                    //4
                    Rectangle{
                        id: help_document
                        width: rec_list_view.width
                        height: listHeight
                        Image {
                            id: pic_help_dociment
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/images/help_file.png"
                            sourceSize { width: side * 30; height: side * 30}
                        }
                        Text {
                            text: qsTr("help document")//帮助文档
                            anchors.left: pic_help_dociment.right
                            anchors.leftMargin: fontPixSize
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: fontPixSize
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if (stack_right_view.depth < 2) {
                                    stack_right_view.replace(help_document_layout)
                                } else {
                                    stack_right_view.pop()
                                }
                            }
                        }
                        Image {
                            source: "qrc:/images/right_dash.png"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            sourceSize { width: side * 30; height:  side * 30}
                        }
                    }
                    Rectangle{
                        z: 2
                        width: rec_list_view.width
                        height: 1
                        color: "#f0f0f0"
                    }


                    //5
                    Rectangle{
                        id:about_machine
                        width: rec_list_view.width
                        height: listHeight
                        Image {
                            id: pic_about_machine
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/images/more_information.png"
                            sourceSize { width: side * 30; height: side * 30}
                        }
                        Text {
                            text: qsTr("about machine")//关于本机
                            anchors.left: pic_about_machine.right
                            anchors.leftMargin: fontPixSize
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: fontPixSize
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if(stack_right_view.depth < 2) {
                                    stack_right_view.replace(about_machine_layout)
                                } else {
                                    stack_right_view.pop()
                                }
                            }
                        }
                        Image {
                            source: "qrc:/images/right_dash.png"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            sourceSize { width: side * 30; height:  side * 30}
                        }
                    }
                    Rectangle{
                        z: 2
                        width: rec_list_view.width
                        height: 1
                        color: "#f0f0f0"
                    }
                }



                //second class ListView
                Rectangle {
                    id: home_page_layout
                    visible: false

                    ColumnLayout {
                        anchors.fill: parent

                        GridLayout {
                            id: grid_layout
                            anchors.fill: parent
                            rows: 2
                            columns: 3
                            rowSpacing: 30
                            columnSpacing: 70

                            Image {
                                id: pic_battery
                                source: "qrc:/images/battery.png"
                                Layout.row: 0
                                Layout.column: 0
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Image {
                                id: pic_water
                                source: "qrc:/images/water.png"
                                Layout.row: 0
                                Layout.column: 1
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Image {
                                id: pic_drive_mode
                                source: "qrc:/images/switch_button_left.png"
                                Layout.row: 0
                                Layout.column: 2
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Image {
                                id: pic_car_gear
                                source: "qrc:/images/car_gear.png"
                                Layout.row: 1
                                Layout.column: 0
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Image {
                                id: pic_car_speed
                                source: "qrc:/images/car_speed.png"
                                Layout.row: 1
                                Layout.column: 1
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Image {
                                id: pic_brush_state
                                source: "qrc:/images/switch_button_right.png"
                                Layout.row: 1
                                Layout.column: 2
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }
                        Rectangle {
                            width: right_rect.width
                            height: right_rect.height / 2
                            border.color: "grey"

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/images/power_on.png"
                            }
                        }
                    }

                }

                Rectangle {
                    id: user_manage_layout
                    visible: false
                    color: Qt.rgba(Math.random(), Math.random(), Math.random(), Math.random())

                    Button {
                        id: nextsasa
                        anchors.centerIn: parent
                        anchors.margins: 8
                        text: "user manage"
                        width: 70
                        height: 30
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
//                                if(stack.depth > 0)stack.pop(stack.initialItem)
                            }
                        }
                    }
                }

                Rectangle {
                    id:task_config_layout
                    visible: false
                    color: Qt.rgba(Math.random(), Math.random(), Math.random(), Math.random())

                    Button {
                        id: nextsasasa
                        anchors.centerIn: parent
                        anchors.margins: 8
                        text: "task config"
                        width: 70
                        height: 30
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
//                                if(stack.depth > 0)stack.pop(stack.initialItem)
                            }
                        }
                    }
                }
                Rectangle {
                    id: help_document_layout
                    visible: false

                    Image {
                        source: "qrc:/images/help_file.png"
                        anchors.fill: parent
                    }
                }

                Rectangle {
                    id: about_machine_layout
                    visible: false

                    Image {
                        source: "qrc:/images/more_information.png"
                        anchors.fill: parent
                    }
                }
            }
        }

        Rectangle {
            id: right_rect
            z: 5
            width: parent.width * 0.7
            height: parent.height
            anchors {
                left: left_rect.right
                leftMargin: 5
                right: parent.right
                rightMargin: 5
            }

            StackView {
                id: stack_right_view
                anchors.fill: right_rect
                initialItem: home_page_layout
            }
        }
    }
}
