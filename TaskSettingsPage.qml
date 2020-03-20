import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4 as Control_14
import "CustomControl"

Rectangle {
    id: root
    color: "transparent"
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
            Rectangle {
                id: rec_header_bar
                width: parent.width
                height: parent.height * 0.05 * rate
                TabBar {
                    id: header_bar
                    width: parent.width
                    height: parent.height * 0.95
                    position: TabBar.Header
                    Repeater {
                        model: map_areas

                        TabButton {
                            width: header_bar.width / (map_areas.length + 2)
                            height: parent.height
                            indicator: Rectangle {
                                anchors.fill: parent
                                border.color: "transparent"
                                Image {
                                    id: pic_areas_normol
                                    anchors.fill: parent
                                    source: "qrc:/res/pictures/map_areas_normal.png"
                                    Text {
                                        text: qsTr(modelData)
                                        anchors.centerIn: parent
                                    }
                                }
                                Image {
                                    id: pic_areas_focus
                                    visible: false
                                    anchors.fill: parent
                                    source: "qrc:/res/pictures/map_areas_focus.png"
                                    Text {
                                        text: qsTr(modelData)
                                        anchors.centerIn: parent
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: {
                                        header_bar_index = index
                                        pic_areas_focus.visible = true
                                        pic_areas_normol.visible = false
                                        list_model.clear()
                                        list_model.initListModel()
                                    }
                                    onCanceled: {
                                        pic_areas_normol.visible = true
                                        pic_areas_focus.visible = false
                                    }
                                    onReleased: {
                                        pic_areas_normol.visible = true
                                        pic_areas_focus.visible = false
                                    }
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.05
                    anchors.top: header_bar.bottom
                    color: "lightblue"
                }
            }
            Control_14.SplitView {
                id: split_view
                width: parent.width
                height: rec_task_page.height - rec_header_bar.height - 1
                anchors.left: parent.left
                anchors.top: rec_header_bar.bottom
                orientation: Qt.Horizontal
                Rectangle {
                    id: rec_left
                    color: "transparent"
                    width: parent.width * 0.2
                    height: parent.height
                    Layout.minimumWidth: parent.width * 0.1
                    ListView {
                        id: list_view
                        clip: true
                        anchors.fill: parent
                        model: list_model
                        delegate: ItemDelegate {
                            id: list_delegate
                            checkable: true
                            width: parent.width
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
                    Layout.minimumWidth: parent.width * 0.1
                    MonitorPage {
                        id: monitor_page
                        width:parent.width
                        height: parent.height
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
                width: 60 * rate
                height: 30 * rate
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
                                rec_left.visible = false
                                rec_header_bar.visible = false
                                rec_left.width = 0
                                rec_header_bar.height = 0
                                turn_task_page = true
                            } else {
                                dialog_match_warn.open()
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: btn_cancle_task
                width: 60 * rate
                height: 30 * rate
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
            color: "transparent"
            width: rec_glow_background.width
            height: rec_glow_background.height * 0.1
            anchors.bottom: rec_task_control.top
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                width: parent.width * 0.96
                height: parent.height * 0.9
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/res/pictures/background_mached.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 15 * rate
                Rectangle {
                    id: btn_not_match
                    width: 75 * rate
                    height: 22 * rate
                    color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/pictures/btn_style1.png"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        Text {
                            text: qsTr("Not Matched")
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
                                isMatched = false
                                can_work = false
                                monitor_page.choose_marker.visible = true
                                btn_not_match.visible = false
                                btn_match.visible = false
                                btn_resure.visible = true
                                note_text.visible = true
                            }
                        }
                    }
                }
                Rectangle {
                    id: btn_match
                    width: 75 * rate
                    height: 22 * rate
                    color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/pictures/btn_style1.png"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        Text {
                            text: qsTr("Matched")
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
                            }
                        }
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
                Rectangle {
                    id: btn_resure
                    visible: false
                    width: 75 * rate
                    height: 22 * rate
                    color: "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/pictures/btn_style1.png"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        Text {
                            text: qsTr("Resure")
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
                            }
                        }
                    }
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
        dia_image_source: "qrc:/res/pictures/sad.png"
        is_single_btn: true
        onOkClicked: {
            dialog_match_warn.close()
        }
    }
    
}
