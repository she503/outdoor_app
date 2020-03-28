import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import "./CustomControl"

Rectangle {
    id: root
    color: "transparent"
    property real rate: Math.min(width, height) / 400
    property real ratio: Math.sqrt(Math.min(rec_left.width / 3, rec_task_control.height)) * 0.1
    property var map_areas: ["MAP1#", "MAP2#", "MAP3#"]
    property var ref_lines: [["Task1#", "Task2#", "Task3#"], ["Task4#", "Task5#", "Task6#"], ["Task7#", "Task8#", "Task9#"]]
    property var sel_map: -1
    property bool isMatched: true
    property bool can_work: false
    property real header_bar_index: 0

    property var map_status: -1
    property string error: ""
    property string choose_map_name: ""
    property var tasks_list
    property var choose_task_type: -1
    property var choose_task_points


    property var checked_tasks_name: []
    property var test_car_init_point

    signal backToHomePage()
    signal mapIndexChanged(var current_index)
    onMapIndexChanged: {

    }

    FontLoader {
        id: font_hanzhen;
        source: "qrc:/res/font/hanzhen.ttf"
    }

    Connections {
        target: socket_manager
        onUpdateMapsName: {
            list_model_areas.clear()
            map_areas = maps_name
            map_status = 1
            for (var i = 0; i < map_areas.length; ++i) {
                list_model_areas.append({"map_name":map_areas[i]})
            }
        }
        onGetMapInfoError: {
            map_status = 0
            error = error_message
        }
        onUpdateTasksName: {
            tasks_list = tasks
            task_list_model.clear()
            if (tasks_list.length === 0 ) {
                vbar.visible = false
            } else {
                vbar.visible = true
            }

            for (var i = 0; i < tasks_list.length; ++i) {
                task_list_model.append({"idcard": i,"check_box_text": tasks_list[i]})
            }
        }
    }

    Rectangle {
        id: rec_glow_background
        anchors.fill: parent
        anchors.margins: 5 * rate
        color: "transparent"
        Image {
            anchors.fill: parent
            source: "qrc:/res/pictures/background_glow1.png"
        }
        Rectangle {
            id: rec_task_page
            width: parent.width * 0.9
            height: parent.height * 0.88
            anchors.centerIn: parent
            color: "transparent"
            visible: root.map_status === 1 ? true : false
            Rectangle {
                id: rec_header_bar
                width: parent.width
                height: parent.height * 0.1
                color: "white"
                ListView {
                    id: list_view_areas
                    clip: true
                    anchors.fill: parent
                    orientation:ListView.Horizontal
                    spacing: width * 0.02
                    currentIndex: -1
                    delegate: ItemDelegate {
                        width: list_view_areas.width / 4
                        height: list_view_areas.height

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            border.color: "transparent"
                            Image {
                                id: bac_areas
                                anchors.fill: parent
                                source: ListView.isCurrentItem ? "qrc:/res/pictures/map_areas_focus.png": "qrc:/res/pictures/map_areas_normal.png"
                                Text {
                                    text: qsTr(model.map_name)
                                    anchors.centerIn: parent
                                    font.pixelSize: 17 * rate * ratio
                                    font.family: "Helvetica"
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                propagateComposedEvents: true
                                onPressed: {
                                    list_view_areas.currentIndex = index
                                    socket_manager.parseMapData(model.map_name)
                                    root.choose_map_name = model.map_name
                                    rec_checked_location.visible = true
                                    monitor_page.choose_marker.visible = true
                                    rect_info_choose_map.visible = false
                                    rec_ref_lines.visible = false

                                    root.choose_map_name = model.map_name
                                }
                                onReleased: {
                                    bac_areas.source = "qrc:/res/pictures/map_areas_normal.png"
                                }
                            }
                        }
                    }
                    model: ListModel {
                        id: list_model_areas
                    }
                }
            }



            Rectangle {
                id: rect_decoration
                width: parent.width
                height: 2
                anchors {
                    top: rec_header_bar.bottom
                    left: parent.left
                }
                color: "lightblue"
            }

            Rectangle {
                id: rect_info_choose_map
                visible: true
                width: parent.width
                height: parent.height * 0.1
                color: Qt.rgba(0, 200, 0, 0.3)
                anchors.top: rect_decoration.bottom
                z:2
                Text {
                    text: qsTr("Please choose a map in top")
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: height * 0.2
                }
            }
            Rectangle {
                width: parent.width
                height: rec_task_page.height - rec_header_bar.height - rect_decoration.height
                anchors.top: rect_decoration.bottom
                MapDisplayPage {
                    id: monitor_page
                    width:parent.width
                    height: parent.height


                }

                Rectangle {
                    id: rec_ref_lines
                    visible: false
                    z: 1
                    width: parent.width * 0.2
                    height: parent.height
                    color: "transparent"
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(parent.width, 0)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.5)}
                            GradientStop { position: 1.0; color: Qt.rgba(255, 255, 255, 0.5)}
                        }
                    }



                    ListView {
                        id: list_view
                        clip: true
                        width: parent.width
                        height: parent.height * 0.8
                        orientation:ListView.Vertical
                        spacing: height * 0.02
                        currentIndex: -1
                        delegate: ItemDelegate {
                            id: item
                            property int id_card: model.idcard
                            property bool is_active: false
                            Rectangle {
                                id: check_style
                                width: parent.width * 0.1
                                height: width
                                anchors.verticalCenter: parent.verticalCenter
                                radius: height / 2
                                border.color: "black"
                                border.width: 1
                                Image {
                                    visible: item.is_active ? true : false
                                    source: "qrc:/res/pictures/finish.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.fill: parent
                                }
                            }
                            Text {
                                id: checked_text
                                clip: true
                                text: model.check_box_text
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                width: parent.width * 0.7
                                height: parent.height
                                anchors.left: check_style.right
                                anchors.leftMargin: parent.width * 0.05
                                font.pixelSize: height * 0.4
                                color: item.is_active ? "lightblue" : "black"
                            }
                            onClicked: {
                                list_view.currentIndex = index
                                item.is_active = !item.is_active
                                if (item.is_active) {
                                    root.checked_tasks_name.push(checked_text.text)
                                } else {
                                    var temp_str = []
                                    for (var i = 0 ; i < root.checked_tasks_name.length; ++i) {
                                       if (checked_text.text === root.checked_tasks_name[i]) {
                                           continue
                                       } else {
                                           temp_str.push(root.checked_tasks_name[i])
                                       }
                                    }
                                    root.checked_tasks_name = temp_str
                                }
                                socket_manager.getTasksData(root.checked_tasks_name)
                            }
                        }
                        model: ListModel {
                            id: task_list_model
                        }


                        ScrollBar.vertical: ScrollBar {
                            id: vbar
                            visible: false
                              hoverEnabled: true
                              active: hovered || pressed
                              orientation: Qt.Vertical
                              size: 0.1
                              anchors.top: parent.top
                              anchors.right: parent.right
                              anchors.bottom: parent.bottom
                              policy: ScrollBar.AlwaysOn
                              contentItem: Rectangle {
                                        implicitWidth: 4
                                        implicitHeight: 10
                                        radius: width / 2
                                        color: vbar.pressed ? "#ffffaa" : "#c2f4c6"
                                    }
                         }
                    }
                }
            }
        }

        Rectangle {
            id: rec_task_control
            color: "transparent"
            width: rec_task_page.width
            height: parent.height * 0.1
            anchors.bottom: rec_task_page.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle {
                id: btn_start_task
                width: 75 * rate
                height: 25 * rate
                color: "transparent"
                anchors {
                    right: parent.horizontalCenter
                    rightMargin: 5 * rate
                    verticalCenter: parent.verticalCenter
                }
                Image {
                    anchors.fill: parent
                    source: "qrc:/res/pictures/btn_style2.png"
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    Text {
                        text: qsTr("Start")
                        anchors.centerIn: parent
                        color: "red"
                        font.pixelSize: 15 * rate * ratio
                        font.family: "Arial"
                        font.weight: Font.Thin
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (can_work) {
                                rec_task_control.visible = false
                                rec_header_bar.visible = false
                                rec_header_bar.height = 0
                                rect_decoration.visible = false
                                rec_ref_lines.visible = false
                                turn_task_page = true


                                socket_manager.sentMapTasksName(root.checked_tasks_name)
                            } else {
                                dialog_match_warn.open()
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: btn_cancle_task
                width: 75 * rate
                height: 25 * rate
                color: "transparent"
                anchors {
                    left: parent.horizontalCenter
                    leftMargin: 5 * rate
                    verticalCenter: parent.verticalCenter
                }
                Image {
                    anchors.fill: parent
                    source: "qrc:/res/pictures/btn_style2.png"
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    Text {
                        text: qsTr("Cancle")
                        anchors.centerIn: parent
                        color: "blue"
                        font.pixelSize: 15 * rate * ratio
                        font.family: "Arial"
                        font.weight: Font.Thin
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            backToHomePage()
                        }
                    }
                }
            }
        }

        Rectangle{
            id: rec_checked_location
            visible: false
            color: "transparent"
            width: rec_glow_background.width
            height: rec_glow_background.height * 0.1
            anchors.bottom: rec_task_control.top
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                id: choose_point
                width: parent.width * 0.96
                height: parent.height * 0.9
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/res/pictures/background_mached.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 15 * rate

                Component.onCompleted: {
                    isMatched = false
                    can_work = false
                    monitor_page.choose_marker.visible = false
                    btn_resure.visible = true
                    note_text.visible = true
                }

                Text {
                    id: note_text
                    visible: false
                    text: qsTr("move and choose point!")//移动选点!
                    font.family: "Helvetica"
                    font.pointSize: 25 * rate
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "red"
                }
                Rectangle {
                    id: btn_resure
                    visible: false
                    width: 75 * rate
                    height: 25 * rate
                    color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/pictures/btn_style1.png"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        Text {
                            text: qsTr("SURE")
                            anchors.centerIn: parent
                            color: "blue"
                            font.pixelSize: 13 * rate * ratio
                            font.family: "Arial"
                            font.weight: Font.Thin
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                isMatched = true
                                can_work = true
                                rec_checked_location.visible = false
                                monitor_page.choose_marker.visible = false

//                                busy.running = true
                                dialog_resure.open()

                            }
                        }
                    }
                }
            }
        }
        BusyIndicator{
            id:busy
            z: 5
            running: false
            width: parent.height * 0.2
            height: width
            anchors.centerIn: parent
            Timer{
                interval: 2000
                running: busy.running
                onTriggered: {
                    busy.running = false
                    rec_ref_lines.visible = true
                }
            }
        }
    }

    Rectangle {
        id: rect_error
        width: parent.width * 0.9
        height: parent.height * 0.88
        anchors.centerIn: parent
        color: "white"
        visible: !rec_task_page.visible
        Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: font_hanzhen.name
            font.pixelSize: height * 0.05
            text: root.error
        }
    }

    TLDialog {
        id: dialog_match_warn
        width: root.width * 0.4
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Warn!")
        dia_title_color: "red"
        dia_image_source: "qrc:/res/pictures/sad.png"
        is_single_btn: true
        onOkClicked: {
            dialog_match_warn.close()
        }
    }

    TLDialog {
        id: dialog_resure
        width: root.width * 0.4
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Are u sure?")
        dia_title_color: "red"
        dia_image_source: "qrc:/res/pictures/smile.png"
        is_single_btn: false
        onOkClicked: {
            dialog_resure.close()

            monitor_page.sendInitPoint()

            rect_decoration.visible = false
            rec_header_bar.visible = false
            rec_header_bar.height = 0
            socket_manager.getMapTask( root.choose_map_name )
            busy.running = true

        }
        onCencelClicked: {
            isMatched = false
            can_work = false
            rec_checked_location.visible = true
            monitor_page.choose_marker.visible = true
            dialog_resure.close()
        }
    }


}
