import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4 as Control_14
import "CustomControl"

Rectangle {
    id: root

    property real rate: Math.min(width, height) / 400
    property real ratio: Math.sqrt(Math.min(rec_left.width / 3, rec_task_control.height)) * 0.1
    property var map_areas: ["MAP1#", "MAP2#", "MAP3#"]
    property var ref_lines: [["submap1#", "submap2#", "submap3#"], ["submap4#", "submap5#", "submap6#"], ["submap7#", "submap8#", "submap9#"]]
    property var sel_map: -1
    property bool isMatched: true
    property bool can_work: false
    property real header_bar_index: 0

    signal backToHomePage()
    signal mapIndexChanged(var current_index)
    onMapIndexChanged: {

    }

    TabBar {
        id: header_bar
        width: parent.width
        height: parent.height * 0.05 * rate
        position: TabBar.Header
        Repeater {
            model: map_areas

            TabButton {
                text: modelData
                width: header_bar.width / map_areas.length
                height: parent.height
                onPressed: {
                    header_bar_index = index
                    list_model.clear()
                    list_model.initListModel()
                }
            }
        }
    }

    Control_14.SplitView {
        id: split_view
        width: parent.width
        height: root.height - header_bar.height
        anchors.left: parent.left
        anchors.top: header_bar.bottom
        orientation: Qt.Horizontal
        Rectangle {
            id: rec_left
            color: "transparent"
            width: parent.width * 0.2
            height: parent.height

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
                        width: parent.width
                        ColumnLayout {
                            id: grid
                            visible: true
                            ButtonGroup { id: radio_group }
                            Repeater {
                                model: attributes
                                CheckBox {
                                    id: control
                                    text: attrName
                                    font.pixelSize: 15 * rate * ratio
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
//                                        if (name === qsTr("map1#")) {
//                                            sel_map = index
//                                            mapIndexChanged(sel_map)
//                                        } else if (name === qsTr("map2#")){
//                                            sel_map = index
//                                        } else if (name === qsTr("map3#")) {
//                                            sel_map = index
//                                        }
                                    }

                                    ButtonGroup.group : {
                                        if(true) {
                                            return radio_group
                                        }
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


            ListModel {
                id: list_model
                function initListModel() {
                    //                    for (var i = 0; i < 3; ++i) {
                    var mapAttr = []
                    for (var i = 0; i < ref_lines[header_bar_index].length; ++i) {
                        mapAttr.push({attrName: ref_lines[header_bar_index][i]})
                    }
                    var mapElem = {attributes: mapAttr}
                    append(mapElem)
                }
                //                }
                Component.onCompleted: {
                    initListModel()
                }
            }
        }

        Rectangle {
            id: rec_right
            anchors.left: rec_left.right
            width: split_view.width - rec_left.width
            height: parent.height
            MonitorPage {
                id: monitor_page
                width:parent.width
                height: parent.height
            }
        }
    }

    Rectangle {
        id: rec_task_control
        width: parent.width
        height: parent.height * 0.1
        anchors.bottom: parent.bottom
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
                if (can_work) {
                    rec_task_control.visible = false
                    rec_left.visible = false
                    header_bar.visible = false
                    rec_left.width = 0
                    header_bar.height = 0
                    turn_task_page = true
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
                backToHomePage()
            }
        }
    }

    Rectangle{
        id: rec_checked_location
        color: "#98F5FF"
        width: parent.width
        height: parent.height * 0.1
        //            color: Qt.rgba(0.5,0.5,0.5,0.3)
        anchors.bottom: rec_task_control.top
        Row {
            spacing: 15 * rate
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 15 * rate
            Button {
                id: btn_not_match
                text: qsTr("not match")//不匹配
                font.pixelSize: 10 * rate
                width: 75 * rate
                height: 22 * rate
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: btn_not_match.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                }
                onClicked: {
                    isMatched = false
                    can_work = false
                    monitor_page.choose_marker.visible = true
                    btn_not_match.visible = false
                    btn_match.visible = false
                    btn_resure.visible = true
                    note_text.visible = true
                }
            }
            
            Button {
                id: btn_match
                text: qsTr("match")//匹配
                font.pixelSize: 10 * rate
                width: 75 * rate
                height: 22 * rate
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: btn_match.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                }
                onClicked: {
                    isMatched = true
                    can_work = true
                    rec_checked_location.visible = false
                    monitor_page.choose_marker.visible = false
                }
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
            Button {
                id: btn_resure
                text:  qsTr("resure")//确认
                visible: false
                font.pixelSize: 10 * rate
                width: 75 * rate
                height: 22 * rate
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: btn_match.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                }
                onClicked: {
                    isMatched = true
                    can_work = true
                    rec_checked_location.visible = false
                    monitor_page.choose_marker.visible = false
                }
            }
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
