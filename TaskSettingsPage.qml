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
    property var ref_lines: [["Task1#", "Task2#", "Task3#"], ["Task4#", "Task5#", "Task6#"], ["Task7#", "Task8#", "Task9#"]]
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
                height: parent.height * 0.07 * rate
                Rectangle {
                    width: parent.width
                    height: 2
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.topMargin: 1
                    color: "lightblue"
                }
                ListView {
                    id: list_view_areas
                    clip: true
                    anchors.fill: parent
                    model: list_model_areas
                    orientation:ListView.Horizontal
                    boundsBehavior:Flickable.StopAtBounds
                    delegate: RowLayout {
                        id: grid_areas
                        visible: true
                        width: parent.width
                        height: parent.height
                        Repeater {
                            model: attributes
                            Rectangle {
                                width: rec_header_bar.width / (map_areas.length + 2)
                                height: parent.height
                                border.color: "transparent"
//                                color: ListView.isCurrentItem ? "blue" : "red"
                                Image {
                                    id: bac_areas
                                    anchors.fill: parent
                                    source: ListView.isCurrentItem ? "qrc:/res/pictures/map_areas_focus.png": "qrc:/res/pictures/map_areas_normal.png"
                                    Text {
                                        text: qsTr(modelData)
                                        anchors.centerIn: parent
                                        font.pixelSize: 15 * rate * ratio
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    propagateComposedEvents: true
                                    onPressed: {
                                        list_view_areas.currentIndex = index
                                        header_bar_index = index
                                        list_model.clear()
                                        list_model.initListModel()
                                        rec_ref_lines.visible = true
                                        rec_checked_location.visible = true
                                        btn_not_match.visible = true
                                        btn_match.visible = true
                                        note_text.visible = false
                                        btn_resure.visible = false
                                        bac_areas.source = "qrc:/res/pictures/map_areas_focus.png"
//                                        list_model_areas.clear()
//                                        list_model_areas.initListModel()
                                    }
                                    onReleased: {
                                        bac_areas.source = "qrc:/res/pictures/map_areas_normal.png"
                                    }
                                }
                            }
                        }
                    }
                }
                ListModel {
                    id: list_model_areas
                    function initListModel() {
                        var mapAttr = []
                        for (var i = 0; i < map_areas.length; ++i) {
                            mapAttr.push({attrName: map_areas[i]})
                        }
                        var mapElem = {attributes: mapAttr}
                        append(mapElem)
                    }
                    Component.onCompleted: {
                        initListModel()
                    }
                }
            }
            Rectangle {
                id: rec_split
                width: parent.width
                height: 1
                anchors.bottom: rec_header_bar.bottom
                anchors.left: parent.left
                anchors.topMargin: 1
                color: "white"
            }
            Rectangle {
                id: map_view
                width: parent.width
                height: rec_task_page.height - rec_header_bar.height
                anchors.left: parent.left
                anchors.top: rec_split.bottom
                color: "transparent"
                Rectangle {
                    id: rec_ref_lines
                    visible: false
                    z: 1
                    width: parent.width * 0.2
                    height: parent.height
                    Rectangle {
                        width: 1
                        height: parent.height
                        anchors.top: parent.top
                        anchors.right: parent.right
                        color: "lightgrey"
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
                            contentItem: ColumnLayout {
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
                                            implicitWidth: rate * 25 * ratio
                                            implicitHeight: rate * 25 * ratio
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
                            var mapAttr = []
                            for (var i = 0; i < ref_lines[header_bar_index].length; ++i) {
                                mapAttr.push({attrName: ref_lines[header_bar_index][i]})
                            }
                            var mapElem = {attributes: mapAttr}
                            append(mapElem)
                        }
                        Component.onCompleted: {
                            initListModel()
                        }
                    }
                }

                Rectangle {
                    width: map_view.width
                    height: map_view.height
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
                                rec_header_bar.visible = false
                                rec_ref_lines.visible = false
                                rec_split.visible = false
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
                anchors.horizontalCenter: parent.horizontalCenter
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
                            font.pixelSize: 15 * rate * ratio
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
        dia_title_color: "red"
        dia_image_source: "qrc:/res/pictures/sad.png"
        is_single_btn: true
        onOkClicked: {
            dialog_match_warn.close()
        }
    }
    
}
