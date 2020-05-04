import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import "./homemade_components"
import "map_task_manager"

Rectangle {
    id: root
    color: "transparent"
    property var _maps_name: []
    /*
      @ map_status  ===> 0: load map faildX; 1: load map success;
      @ error       ===> if map load faild, it is map error information
      */
    property var map_status: status_manager.getWorkStatus()
    property string error: ""

    property int init_time: 0
    property string choose_map_name: ""
    property string work_time: ""
    property var tasks_list: []
    property var checked_tasks_name: []

    signal startTaskLock()

    function updateMapSettingPage(status) {
        if (status <= 2) {//selecting map
            map_name_list.clear()
            var maps_name = map_task_manager.getMapsName()

            for (var j = 0; j < maps_name.length; ++j) {
                map_name_list.append({"map_name": maps_name[j]})
            }
            chooseMapPage()
        } else if (status === 4) {
            var tasks_name = map_task_manager.getTasksName()
            task_list_model.clear()
            for (var i = 0; i < tasks_name.length; ++i) {
                task_list_model.append({"idcard": i,"task_name": tasks_name[i]})
            }
            chooseTaskPage()
        }  else if (status === 5 ) {
            startTaskPage()
        } else if (status >= 6) {

        }

    }

    function hideAllComponent() {
        rec_header_bar.visible = false
        rec_header_bar.height = 0
        rect_decoration.visible = false
        rec_checked_location.visible = false
        rec_task_control.visible = false
        rec_ref_lines.visible = false
        map_display_page.p_choose_marker.visible = false
        btn_start_task.visible = false
    }

    function chooseMapPage() {
        hideAllComponent()
        rec_header_bar.visible = true
        rec_header_bar.height = rec_task_page.height * 0.1
        rect_decoration.visible = true
        rec_checked_location.visible = true
        map_display_page.p_choose_marker.visible = true

        task_list_model.clear()
    }

    function confirmMapPage() {
        hideAllComponent()
        rec_ref_lines.visible = true
        rec_task_control.visible = true

    }

    function chooseTaskPage() {
        hideAllComponent()
        btn_start_task.visible = true
        rec_task_control.visible = true
        rec_ref_lines.visible = true
    }

    function startTaskPage() {
        hideAllComponent()
    }

    Component.onCompleted: {
        var work_status = status_manager.getWorkStatus()
        updateMapSettingPage(work_status)
    }

    Connections{
        target: status_manager
        onWorkStatusUpdate: {

            updateMapSettingPage(status)
            root.checked_tasks_name = []
            map_display_page.clearAllCanvas()
            map_display_page.paintingMap(map_task_manager.getCurrentMapName())
        }
    }

    FontLoader {
        id: font_hanzhen;
        source: "qrc:/res/font/hanzhen.ttf"
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
            visible: root.map_status !== 0
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
                    currentIndex: 0
                    delegate: ItemDelegate {
                        width: list_view_areas.width / 4
                        height: list_view_areas.height
                        onPressed: {
                            root.chooseMapPage()
                            list_view_areas.currentIndex = index

                            root.choose_map_name = model.map_name
                            map_task_manager.setWorkMapName(model.map_name)
                            map_display_page.paintingMap(model.map_name)
                        }

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"
                            border.color:  Qt.rgba(205,133,63, 0.5)
                            Image {
                                anchors.fill: parent
                                source: parent.parent.focus ?
                                            "qrc:/res/pictures/map_areas_focus.png" : "qrc:/res/pictures/map_areas_normal.png"
                            }
                            Text {
                                text: model.map_name
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: height * 0.4
                                font.bold: true
                                color: "white"
                            }
                        }
                    }
                    model: ListModel {
                        id: map_name_list
                        Component.onCompleted: {
                            map_name_list.clear()
                            root._maps_name = map_task_manager.getMapsName()
                            for (var i = 0; i < _maps_name.length; ++i) {
                                map_name_list.append({"map_name":_maps_name[i]})
                            }
                        }
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
                    id: map_display_page
                    width:parent.width
                    height: parent.height
                }

                Rectangle {
                    id: rec_ref_lines
                    visible: false
                    z: 1
                    width: parent.width * 0.2
                    height: parent.height * 0.833
                    color: "white"
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
                            width: parent.width
                            property int id_card: model.idcard
                            property bool is_active: false
                            Image {
                                width: parent.width - 4
                                height: parent.height
                                source: item.is_active ?
                                            "qrc:/res/pictures/bar_ref_line0.png" : "qrc:/res/pictures/map_areas_normal.png"
                            }
                            Text {
                                id: checked_text
                                clip: true
                                text: model.task_name
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                width: parent.width
                                height: parent.height
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width * 0.1
                                font.pixelSize: height * 0.4
                                font.bold: true
                                color: "white"
                                //                                color: item.is_active ? "red" : "black"
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
                                var tasks_data = map_task_manager.getTasksData(root.checked_tasks_name)
                                map_display_page.p_task_lines = tasks_data[0]
                                map_display_page.p_task_points = tasks_data[1]
                                map_display_page.p_task_regions = tasks_data[2]
                                map_display_page.paintTasks()

                            }
                        }
                        model: ListModel {
                            id: task_list_model
                        }


                        ScrollBar.vertical: TLScrollBar { visible: task_list_model.count > 6 }

                    }
                    Rectangle {
                        id: rect_back
                        width: parent.width
                        height: parent.height * 0.2
                        anchors.top: rec_ref_lines.bottom
                        TLButton {
                            id: btn_return_choose_map
                            width: parent.width * 0.8
                            height: parent.height * 0.5
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            onClicked: {

                            }
                            Text {
                                text: qsTr("back to choose map again")
                                width: parent.width / 2
                                height: parent.height
                                color: "lightgreen"
                                anchors.left: parent.left
                                anchors.leftMargin: height * 0.05
                                font.pixelSize: Math.sqrt(parent.height) * 2
                                font.family: "Arial"
                                font.weight: Font.Thin
                                verticalAlignment: Text.AlignVCenter
                            }
                            Image {
                                id: img_back
                                height: parent.height
                                width: Math.sqrt(parent.height) * 4
                                anchors.right: parent.right
                                source: "qrc:/res/pictures/back_style4.png"
                                opacity: 0.6
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                dialog_return_map_tip.open()
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
                            map_task_manager.setWorkTasksName(root.checked_tasks_name)
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
            visible: running
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

    Connections {
        target: map_task_manager
        onEmitSetInitPoseRstInfo: {
            busy.visible = false
            busy.running = false
            rec_checked_location.visible = true
        }
    }

    Timer {
        id: timer_cant_control_pop
        running: false
        repeat: true
        interval: 10
        onTriggered: {
            if (busy.running == true) {
                pop_lock_loading_task.open()
            } else {
                pop_lock_loading_task.close()
            }
        }
    }

    Popup {
        id: pop_lock_loading_task
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        dim: false
        closePolicy: Popup.CloseOnPressOutsideParent
        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
        }
    }
    TLDialog {
        id: dialog_return_map_tip
        height: parent.height * 0.5
        width: height * 1.5
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Repeat")
        dia_content: qsTr("Whether to reselect the map?")
        status: 1
        ok: true
        cancel_text: qsTr("cancel")
        ok_text: qsTr("yes")
        onCancelClicked: {
            dialog_return_map_tip.close()
        }
        onOkClicked: {
            dialog_return_map_tip.close()
            map_task_manager.turnToSelectMap()

        }
    }

    TLDialog {
        id: dialog_resure
        height: parent.height * 0.5
        width: height * 1.5
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
            map_display_page.sendInitPoint()
            busy.visible = true
            busy.running = true
            rec_checked_location.visible = false
            pop_lock_loading_task.open()
            timer_cant_control_pop.start()
        }
        onCancelClicked: {
            root.chooseMapPage()
            dialog_resure.close()
        }
    }
}
