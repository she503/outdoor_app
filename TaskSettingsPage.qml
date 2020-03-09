import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4 as Control_14
import "CustomControl"

Rectangle {
    id: root

    property real rate: Math.min(width, height) / 400
    property real ratio: Math.sqrt(Math.min(rec_left.width / 3, rec_power_control.height)) * 0.1
    property var text_process: ["map1#", "1h", "80%", "20min"]
    property var cell_map: ["submap1#", "submap2#", "submap3#"]
    property var sel_map: -1
    signal mapIndexChanged(var current_index)
    onMapIndexChanged: {

    }

    Control_14.SplitView {
        id: split_view
        anchors.fill: parent
        orientation: Qt.Horizontal
        Rectangle {
            id: rec_left
            color: "transparent"
            width: parent.width * 0.25
            height: parent.height
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
                clip: true
                anchors.fill: parent
                model: list_model
                delegate: ItemDelegate {
                    id: list_delegate
                    checkable: true
                    width: parent.width
                    Rectangle {
                        width: parent.width
                        height: parent.height * 0.01
                        color: "lightgrey"
                    }
                    contentItem: ColumnLayout {
                        spacing: 10
                        width: parent.width
                        Label {
                            id: label
                            text: name
                            font.bold: true
                            font.pixelSize: 25 * rate * ratio
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        ColumnLayout {
                            id: grid
                            visible: false
                            ButtonGroup { id: radio_group }
                            Repeater {
                                model: attributes
                                CheckBox {
                                    id: control
                                    text: attrName
                                    font.pixelSize: 18 * rate * ratio
                                    indicator: Rectangle {
                                        anchors.verticalCenter: control.verticalCenter
                                        implicitWidth: rate * 30 * ratio
                                        implicitHeight: rate * 30 * ratio
                                        radius: width / 2
                                        border.color: "grey"
                                        border.width: 1
                                        Image {
                                            visible: control.checked
//                                            anchors.margins: 4
                                            source: "qrc:/res/pictures/finish_2.png"
                                            fillMode: Image.PreserveAspectFit
                                            anchors.fill: parent
                                        }
                                    }
                                    onClicked: {
                                        if (name === qsTr("map1#")) {
                                            sel_map = index
                                            mapIndexChanged(sel_map)
                                        } else if (name === qsTr("map2#")){
                                            sel_map = index
                                        } else if (name === qsTr("map3#")) {
                                            sel_map = index
                                        }
                                    }

                                    ButtonGroup.group : {
                                        if(name === qsTr("map1#") || name === qsTr("map2#") || name === qsTr("map3#")) {
                                            return radio_group
                                        }
                                    }
                                }
                            }
                        }

                    }
                    states: [
                        State {
                            name: "expanded"
                            when: list_delegate.checked
                            PropertyChanges {
                                target: grid
                                visible: true
                            }
                        }
                    ]
                }
                ScrollBar.vertical: ScrollBar {
                    id: vbar
                    hoverEnabled: true
                    active: hovered || pressed
                    orientation: Qt.Vertical
                    anchors {
                        top: parent.top
                        right: parent.right
                        rightMargin: 10 * rate
                        bottom: parent.bottom
                    }
                    policy: ScrollBar.AlwaysOn
                    contentItem: Rectangle {
                        implicitWidth: 20 * rate
                        implicitHeight: height
                        radius: width / 2
                        color: vbar.pressed ? "#c2f4c6" : "transparent"
                    }
                }
            }
            ListModel {
                id: list_model
                function initListModel() {
                    for (var i = 0; i < 3; ++i) {
                        var mapAttr = []
                        for (var j = 0; j < cell_map.length; ++j) {
                            mapAttr.push({attrName: cell_map[j]})
                        }
                        var mapElem = {name: qsTr("map" + (i + 1) + "#"), attributes: mapAttr}
                        append(mapElem)
                    }
                }
                Component.onCompleted: {
                    initListModel()
                }
            }
        }

        Rectangle {
            id: rec_right
            anchors.left: rec_left.right
            width: parent.width * 0.75
            height: parent.height

            Rectangle {
                id: rec_map_view
                width: parent.width
                height: parent.height * 0.7
                MonitorPage {
                    id: monitor_page
                    width:parent.width
                    height: parent.height
                    Component.onCompleted: {
                        checked_location.visible = true
                    }
                }
            }
            Rectangle {
                id: rec_power_view
                width: parent.width
                height: parent.height * 0.3
                anchors.top: rec_map_view.bottom
                color: "white"
                Text {
                    id: text_checked
                    text: qsTr("Make sure the map is selected correctly and
                                        the scrubber is at the starting point of the operation")//请确认地图选择无误，且洗地机位于作业起始点
                    font.bold: true
                    font.pixelSize: 10 * rate
                    anchors {
                        top: parent.top
                        topMargin: parent.height * 0.05
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle {
                    id: rec_button_control
                    width: parent.width
                    height: parent.height * 0.6
                    anchors.top: text_checked.bottom
                    TLButton {
                        id: button_start
                        width: 60 * rate
                        height: 30 * rate
                        font_size: 12 * rate
                        btn_text: qsTr("Start")
                        anchors {
                            right: parent.horizontalCenter
                            rightMargin: 15 * rate
                            verticalCenter: parent.verticalCenter
                        }
                        onClicked: {
                            if (monitor_page.isMatched) {
                                rec_power_view.visible = false
                                list_view.visible = false
                                rec_map_view.height = rec_right.height
                                rec_turn_view.visible = true
                            } else {
                                dialog_match_warn.open()
                            }
                        }
                    }
                    TLButton {
                        width: 60 * rate
                        height: 30 * rate
                        btn_text: qsTr("Cancel")
                        font_size: 12 * rate
                        anchors {
                            left: parent.horizontalCenter
                            leftMargin: 15 * rate
                            verticalCenter: parent.verticalCenter
                        }
                        onClicked: {
                            turn_task_page = false
                        }
                    }
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
        dia_info_text: qsTr("Machine malfunction")
        is_single_btn: true
        onOkClicked: {
//            rec_power_view.visible = true
//            list_view.visible = true
//            rec_map_view.height = rec_right.height * 0.7
//            rec_turn_view.visible = false
//            monitor_page.checked_location.visible = true
//            monitor_page.setCheckedLocationStatus()
//            monitor_page.isMatched = false
//            dialog_machine_warn.close()
            dialog_machine_warn.close()
        }
    }
    TLDialog {
        id: dialog_machine_back
        width: root.width * 0.4
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Back!")
        dia_info_text: qsTr("Return to the homepage")
        onOkClicked: {
            list_view.visible = true
            rec_turn_view.visible = false
            turn_task_page = false
        }
    }
    TLDialog {
        id: dialog_match_warn
        width: root.width * 0.4
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Warn!")
        dia_info_text: qsTr("Please resure the match")
        is_single_btn: true
        onOkClicked: {
            dialog_match_warn.close()
        }
    }
}
