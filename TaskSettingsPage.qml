import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import "./CustomControl"

Rectangle {
    id: root
    color: "transparent"
    property var map_areas: []

    /*
      @ map_status  ===> -1: init param; 0: load map faildX; 1: load map success;
      @ error       ===> if map load faild, it is map error information
      */
    property var map_status: -1
    property string error: ""

    property string choose_map_name: ""
    property var tasks_list: []
    property var checked_tasks_name: []

    function chooseMapPage() {
        rec_header_bar.visible = true
        rec_header_bar.height = rec_task_page.height * 0.1
        rect_decoration.visible = true
        rec_checked_location.visible = true

        rec_task_control.visible = false
        rec_ref_lines.visible = false

        monitor_page.choose_marker.visible = true

        task_list_model.clear()
    }

    function confirmMapPage() {
        rec_header_bar.visible = false
        rec_header_bar.height = 0
        rect_decoration.visible = false
        rec_checked_location.visible = false

        rec_ref_lines.visible = true

        monitor_page.choose_marker.visible = false
        btn_start_task.visible = false
        rec_task_control.visible = true

//        map_task_manager.getMapTask( root.choose_map_name )
    }

    function chooseTaskPage() {
        confirmMapPage()
        btn_start_task.visible = true
        rec_task_control.visible = true
    }

    function startTaskPage() {

        chooseTaskPage()
        btn_start_task.visible = false
        rec_task_control.visible = false
        rec_ref_lines.visible = false
    }

    FontLoader {
        id: font_hanzhen;
        source: "qrc:/res/font/hanzhen.ttf"
    }



    Component.onCompleted: {

       map_task_manager.getMapsName()
    }

    Connections {
        target: map_task_manager
        onUpdateMapsName: {
            list_model_areas.clear()
            map_areas = maps_name
            map_status = 1
            for (var i = 0; i < map_areas.length; ++i) {
                list_model_areas.append({"id_card": i, "map_name":map_areas[i]})
            }
            chooseMapPage()
        }
        onGetMapInfoError: {
            map_status = 0
            error = error_message
        }
        onUpdateTasksName: {
            busy.running = false
            tasks_list = tasks
            task_list_model.clear()
            if (tasks_list.length <= 4 ) {
                vbar.visible = false
            } else {
                vbar.visible = true
            }

            for (var i = 0; i < tasks_list.length; ++i) {
                task_list_model.append({"idcard": i,"check_box_text": tasks_list[i]})
            }
            confirmMapPage()
        }
//        onLocalizationInitInfo: {
//            if (status === 0) {
//                root.chooseMapPage()
//                dialog_match_warn.dia_title = message
//                dialog_match_warn.open()
//            } else if (status === 1) {
//                root.confirmMapPage()
//            }
//            busy.running = false
//        }
        onSetTaskInfo: {
            root.chooseTaskPage()
            dialog_match_warn.dia_title = qsTr("Error")//message
            dialog_match_warn.dia_content = message
            dialog_match_warn.open()
        }
//        onUpdateSetMapAndInitPosInfo: {
//            busy.running = false
//            dialog_match_warn.dia_content = message
//            dialog_match_warn.open()
//        }
        onUpdateMapAndTasksInfo: {
            root.choose_map_name = map_name
            root.confirmMapPage()
        }
        onUpdateMapAndTaskInfo: {
            root.choose_map_name = map_name
            root.startTaskPage()
        }
        onUpdateInitPosInfo: {

        }
        onUpdateErrorToLoadMapOrNoneTasksInfo: {
            busy.running = false
            dialog_match_warn.dia_title = qsTr("Error ")
            dialog_match_warn.dia_content = message
            dialog_match_warn.open()

        }

        onUpdateMapName: {
            list_view_areas.currentIndex = index
            map_task_manager.parseMapData(map_name)
            map_task_manager.getFeature(map_name)
        }
    }
    Rectangle {
        id: rec_glow_background
        anchors.fill: parent
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
                        property int id_card: model.id_card
                        onPressed: {
                            root.chooseMapPage()
                            list_view_areas.currentIndex = index

                            root.choose_map_name = model.map_name
                            monitor_page.choose_map_name = model.map_name

                            map_task_manager.setMapName(model.map_name)
//                            map_task_manager.parseMapData(model.map_name)
//                            map_task_manager.getFeature(model.map_name)
                        }

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: list_view_areas.currentIndex === parent.id_card ?
                                              Qt.rgba(0,191,255, 0.8) : Qt.rgba(205,133,63, 0.5)
                            border.color:  Qt.rgba(205,133,63, 0.5)
                            Text {
                                text: model.map_name
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: "black"
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
                            GradientStop { position: 0.0; color: Qt.rgba(0,191,255, 0.5)}
                            GradientStop { position: 1.0; color: Qt.rgba(225,255,255, 0.5)}
                        }
                    }

                    ListView {
                        id: list_view
                        clip: true
                        width: parent.width
                        height: parent.height
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
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width * 0.1
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
                                width: parent.width
                                height: parent.height
                                anchors.left: check_style.right
                                anchors.leftMargin: parent.width * 0.05
                                font.pixelSize: height * 0.4
                                color: item.is_active ? "red" : "black"
                            }
                            onClicked: {
                                root.chooseTaskPage()
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
                                map_task_manager.getTasksData(root.checked_tasks_name)
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
                            policy: ScrollBar.AsNeeded
                            contentItem: Rectangle {
                                implicitWidth: 4
                                implicitHeight: 1
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
            visible: false
            color: "transparent"
            width: rec_task_page.width
            height: parent.height * 0.1
            anchors.bottom: rec_task_page.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle {
                id: btn_start_task
                width: parent.width * 0.2
                height: parent.height
                color: "transparent"
                anchors {
                    right: parent.right
                    rightMargin: parent.width * 0.05
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
                        anchors.fill: parent
                        color: "lightgreen"
                        font.pixelSize: height * 0.3
                        font.family: "Arial"
                        font.weight: Font.Thin
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            map_task_manager.sentMapTasksName(root.checked_tasks_name)
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
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.06
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

            Text {
                id: note_text
                text: qsTr("move and choose point!")//移动选点!
                width: parent.width * 0.7
                height: parent.height
                font.family: "Helvetica"
                font.pixelSize: height * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "red"
            }
            Rectangle {
                id: btn_resure
                width: parent.width * 0.2
                height: parent.height
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.1
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: "qrc:/res/pictures/btn_style1.png"
                    fillMode: Image.PreserveAspectFit
                    Text {
                        text: qsTr("SURE")
                        anchors.fill: parent
                        color: "blue"
                        font.pixelSize: height * 0.3
                        font.family: "Arial"
                        font.weight: Font.Thin
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            dialog_resure.open()
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
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: "error"
    }

    TLDialog {
        id: dialog_resure
        width: root.width * 0.4
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Repeat")
        dia_content: qsTr("Are you sure?")
        status: 1
        ok: true
        cancel_text: qsTr("cancel")
        ok_text: qsTr("yes")
        onOkClicked: {
            dialog_resure.close()
            monitor_page.sendInitPoint()
            busy.running = true
        }
        onCancelClicked: {
            root.chooseMapPage()
            dialog_resure.close()
        }
    }


}
