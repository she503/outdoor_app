import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import "../homemade_components"

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
    property var _work_second: 0
    property var _work_time: []
    property int current_map_index: 0

    onCurrent_map_indexChanged: {
        map_display_page.is_select_begin_point = false
        rec_checked_location.resureLocalization(false)
        rect_resure_point.visible = true
        rect_resure_localization.visible = false
    }


    WorkDone {
        id: work_done_widget
        x:0
        y:100
    }

    signal startTaskLock()

    signal sigBackBtnPress()

    function updateMapSettingPage(status) {
        if (status <= status_manager.getSelectMapID()) {//selecting map
            map_name_list.clear()
            var maps_name = map_task_manager.getMapsName()

            for (var j = 0; j < maps_name.length; ++j) {
                map_name_list.append({"map_name": maps_name[j], "map_select_index" : j})
            }
            root.current_map_index = map_task_manager.getCurrentMapIndex()
            chooseMapPage()
        } else if (status === status_manager.getSelectTaskID()) {
            var tasks_name = map_task_manager.getTasksName()
            task_list_model.clear()
            for (var i = 0; i < tasks_name.length; ++i) {
                task_list_model.append({"idcard": i,"task_name": tasks_name[i]})
            }
            chooseTaskPage()
        }  else if (status === status_manager.getWorkingID()) {
            startTaskPage()
        } else if (status >= status_manager.getWorkDoneID()) {

        }
    }

    function hideAllComponent() {
        rec_header_bar.visible = false
        rec_header_bar.height = 0
        rec_checked_location.visible = false
        rec_task_control.visible = false
        rec_ref_lines.visible = false
        map_display_page.p_choose_marker.visible = false
        btn_start_task.visible = false
    }

    function chooseMapPage() {
        hideAllComponent()
        rec_header_bar.visible = true
        rec_header_bar.height = rec_task_page.height * 0.08
        rec_checked_location.visible = true
        map_display_page.p_choose_marker.visible = true

        task_list_model.clear()
        mapFillScreen(false)
    }

    function confirmMapPage() {
        hideAllComponent()
        rec_ref_lines.visible = true
        rec_task_control.visible = true
        mapFillScreen(false)

    }

    function chooseTaskPage() {
        hideAllComponent()
        btn_start_task.visible = true
        rec_task_control.visible = true
        rec_ref_lines.visible = true
        mapFillScreen(true)
    }

    function startTaskPage() {
        hideAllComponent()
        mapFillScreen(true)
    }

    function mapFillScreen(flag) {
        if (flag) {

        } else {

        }
    }

    Component.onCompleted: {
        var work_status = status_manager.getWorkStatus()
        if (work_status === status_manager.getWorkDoneID()) {
            map_task_manager.turnToSelectMap()
            return
        }
        updateMapSettingPage(work_status)
    }
    Connections {
        target: map_task_manager
        onEmitSetInitPoseRstInfo: {
            rec_checked_location.visible = true
            if (status === 1) {
                rec_checked_location.resureLocalization(false)

            } else if (status === 0) {
                message_box.dia_type = 0
                message_box.dia_title = qsTr("Init Error")
                message_box.dia_text = error_message
                message_box.open()
            }
            busy_indicator.close()

        }
    }

    Connections{
        target: status_manager
        onWorkStatusUpdate: {
            updateMapSettingPage(status)
            root.checked_tasks_name = []
            if (status <= status_manager.getWorkingID()) {
                map_display_page.clearAllCanvas()
            }
            if (status === status_manager.getSelectTaskID()) {
                rec_checked_location.resureLocalization(false)
            }
            if (status <= status_manager.getLocationChoosePointID()) {
                rect_resure_point.visible = true
                rect_resure_localization.visible = false
            }

            busy_indicator.close()

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

        Rectangle {
            id: rec_header_bar
            width: parent.width
            height: parent.height * 0.08
            color: "transparent"
//            anchors{
//                top:parent.top
//                topMargin: parent.height * 0.06
//                left: parent.left
//                leftMargin: parent.width * 0.02
//            }

            ListView {
                id: list_view_areas
                clip: true
                anchors.fill: parent
                orientation:ListView.Horizontal
                spacing: width * 0.02
                currentIndex: 1
                delegate: ItemDelegate {
                    id: item_map_select
                    width: list_view_areas.width / 4
                    height: list_view_areas.height
                    property real map_select_index: model.map_select_index
                    onPressed: {
                        root.chooseMapPage()
                        list_view_areas.currentIndex = index
                        root.current_map_index = index
                        root.choose_map_name = model.map_name
                        map_task_manager.setWorkMapName(model.map_name, index)
                        map_display_page.paintingMap(model.map_name)
                    }

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: item_map_select.map_select_index === root.current_map_index ?
                                        "qrc:/res/ui/background/map_selected.png" : "qrc:/res/ui/background/map_no_select.png"
//                            source: parent.parent.focus ?
//                                        "qrc:/res/ui/background/map_selected.png" : "qrc:/res/ui/background/map_no_select.png"
                        }
                        Text {
                            text: model.map_name
                            clip: true
                            width: parent.width * 0.9
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width * 0.05
                            horizontalAlignment: Text.AlignLeft
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
                        for (var i = 0; i < root._maps_name.length; ++i) {
                            map_name_list.append({"map_name":_maps_name[i], "map_select_index" : i})
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rec_task_page
            width: parent.width
            height: parent.height - rec_header_bar.height
//            anchors.fill: parent
            color: "transparent"
            visible: root.map_status !== 0
            anchors {
                left: parent.left
                top: rec_header_bar.bottom
            }

            Rectangle {
                width: parent.width
                height: parent.height
                anchors.top: parent.top
                radius: 10
                border.color: "lightblue"
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
                    color: "transparent"
                    radius: 10
                    ListView {
                        id: list_view
                        clip: true
                        width: parent.width
                        height: parent.height * 0.9
                        orientation:ListView.Vertical
                        spacing: height * 0.02
                        currentIndex: -1
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.05
                        delegate: ItemDelegate {
                            id: item
                            width: parent.width
                            property int id_card: model.idcard
                            property bool is_active: false
                            height: list_view.height / 10
                            Image {
                                width: parent.width - 4
                                height: parent.height
                                source: item.is_active ?
                                            "qrc:/res/ui/task/task_red.png" : "qrc:/res/ui/background/map_no_select.png"
                            }
                            Text {
                                id: checked_text
                                clip: true
                                text: model.task_name
                                //                                horizontalAlignment: Text.AlignLeft
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width * 0.1
                                verticalAlignment: Text.AlignVCenter
                                width: parent.width * 2
                                height: parent.height
                                font.pixelSize: height * 0.3
                                wrapMode: Text.WordWrap
                                font.bold: true
                                color: "black"

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
                        color: "transparent"
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

                Rectangle{
                    id: rec_checked_location//
                    visible: true
                    color: "transparent"
                    width: parent.width
                    height: parent.height * 0.1
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.06
                    anchors.horizontalCenter: parent.horizontalCenter

                    function resureLocalization(flag) {
                        if (flag) {
                            rect_resure_localization.visible = true
                            txt_localization.text = qsTr("Please waite for minute!")
                            rect_resure_point.visible = false
                            img_no.visible = false
                            img_yes.visible = false

                        } else {
                            rect_resure_localization.visible = true
                            txt_localization.text = qsTr("please resure location is right!")
                            rect_resure_point.visible = false
                            img_no.visible = true
                            img_yes.visible = true
                        }
                    }

                    Rectangle {
                        id: rect_resure_localization
                        anchors.fill: parent
                        visible: false
                        color: "transparent"
                        Rectangle {
                            id: resure_point
                            width: parent.width
                            height: parent.height * 0.9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Qt.rgba(0,255,0,0.5)
                        }

                        Text {
                            id: txt_localization
                            text: qsTr("please resure location is right!")
                            width: parent.width * 0.7
                            height: parent.height
                            font.family: "Helvetica"
                            font.pixelSize: height * 0.5
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "black"
                        }
                        Image {
                            id: img_no
                            width: parent.width * 0.2
                            height: parent.height
                            anchors.right: img_yes.left
                            source: "qrc:/res/ui/background/btn.png"
                            fillMode: Image.PreserveAspectFit
                            Text {
                                text: qsTr("No")
                                anchors.fill: parent
                                color: "white"
                                font.pixelSize: height * 0.3
                                font.family: "Arial"
                                font.weight: Font.Thin
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    map_task_manager.setInitIsRight(false)
                                    rect_resure_localization.visible = false
                                    txt_localization.text = qsTr("please choose a begin point!")
                                    rect_resure_point.visible = true
                                    img_no.visible = false
                                    img_yes.visible = false

                                    map_display_page.a_vehicle.x = 0
                                    map_display_page.a_vehicle.y = 0
                                    map_display_page.a_vehicle.rotation = 0


                                }
                            }
                        }
                        Image {
                            id: img_yes
                            width: parent.width * 0.2
                            height: parent.height
                            anchors.right: parent.right
                            source: "qrc:/res/ui/background/btn.png"
                            fillMode: Image.PreserveAspectFit
                            Text {
                                text: qsTr("Yes")
                                anchors.fill: parent
                                color: "white"
                                font.pixelSize: height * 0.3
                                font.family: "Arial"
                                font.weight: Font.Thin
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    map_task_manager.setInitIsRight(true)
                                    rec_checked_location.resureLocalization(true)
                                    busy_indicator.txt_context = qsTr("get map and task info, please waite for a minute!")
                                    busy_indicator.open()
                                }
                            }
                        }
                    }


                    Rectangle {
                        id: rect_resure_point
                        anchors.fill: parent
                        color: "transparent"
                        Rectangle {
                            id: choose_point
                            width: parent.width
                            height: parent.height * 0.9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Qt.rgba(0,255,0,0.5)
                        }

                        Text {
                            id: note_text
                            text: qsTr("Check a begin point image in map to init localization!")
                            width: parent.width * 0.7
                            height: parent.height
                            font.family: "Helvetica"
                            font.pixelSize: height * 0.5
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: "black"
                        }
                        Image {
                            width: parent.width * 0.2
                            height: parent.height
                            anchors.right: parent.right
                            visible: map_display_page.is_select_begin_point
                            source: "qrc:/res/ui/background/btn.png"
                            fillMode: Image.PreserveAspectFit
                            Text {
                                text: qsTr("SURE")
                                anchors.fill: parent
                                color: "white"
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

                    Rectangle {
                        id: btn_resure
                        width: parent.width * 0.2
                        height: parent.height
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.1
                        color: "transparent"

                    }
                }

            }

            WorkingBtns {
                id: working_btns
                width: parent.width * 0.07
                height: parent.height * 0.5
//                anchors.bottom: parent.bottom
//                anchors.left: parent.left
                anchors{

                    right: parent.right
                    rightMargin: parent.width * 0.01
                    bottom: parent.bottom

                }
                //                anchors.leftMargin: parent.width * 0.05
                onSigWorkDown: {
                    work_done_widget.open()
                }
                onSigBackBtnPress:{
                    root.sigBackBtnPress()
                }

                Component.onCompleted: {
                    var status = status_manager.getWorkStatus()
                    if (status === status_manager.getWorkingID()) {
                        working_btns.visible = true

                    } else {
                        working_btns.visible = false
                        root._work_second = 0
                        root._work_time = []
                    }
                }

                Connections {
                    target: status_manager
                    onWorkStatusUpdate: {
                        if (status === status_manager.getWorkingID()) {
                            working_btns.visible = true
                        } else {
                            working_btns.visible = false
                            root._work_second = 0
                            root._work_time = []
                        }
                        if (status <= status_manager.getLocationChoosePointID()) {
                            rect_resure_point.visible = true
                            rect_resure_localization.visible = false
                        } else if (status === status_manager.getLocationComfirmID()) {
                            rect_resure_point.visible = false
                            rect_resure_localization.visible = true
                        }
                    }
                }

                Connections {
                    target: map_task_manager
                    onEmitWorkDone: {
                        work_done_widget.open()

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
                    source: "qrc:/res/ui/background/btn.png"
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
                            busy_indicator.txt_context = qsTr("Setting task ,please waite for a minute")
                            busy_indicator.open()
                        }
                    }
                }
            }
            Connections {
                target: map_task_manager
                onEmitSetTasksRstInfo: {
                    busy_indicator.close()
                    if (status == 0) {
                        message_box.dia_type = 0
                        message_box.dia_title = qsTr("Init Error")
                        message_box.dia_text = error_message
                        message_box.open()
                    }
                }
            }
        }
    }

    Rectangle {
        id: rect_error
        width: parent.width * 0.83
        height: parent.height * 0.79
        anchors {
            top: parent.top
            topMargin: parent.height * 0.12
            left: parent.left
            leftMargin: parent.width * 0.09
        }

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
            list_view_areas.currentIndex = root.current_map_index

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
            map_task_manager.sendInitPos()
            rec_checked_location.visible = false
            busy_indicator.txt_context = qsTr("Locating, please waite for a minute!")
            busy_indicator.open()
        }
        onCancelClicked: {
            root.chooseMapPage()
            dialog_resure.close()
        }
    }
}
