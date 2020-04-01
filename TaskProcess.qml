import QtQuick 2.0
import QtQuick.Controls 2.2
import "CustomControl"

Rectangle {
    id: process_page
    color: "transparent"
    property var current_map: "Map1#"
    property var text_process: [1, 80, 20]
    property var data_unit: [qsTr("h"), qsTr("%"), qsTr("min")]
    property var obj_name_process: [qsTr("Worked hours: "), qsTr("progress percent: "), qsTr("Estimated time: ")]
    property real rate: Math.min(width, height) / 400
    onText_processChanged: {
        list_model_process.clear()
        addProcessdata()
    }
    Timer {
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            var arrayA = text_process
            for (var i = 0; i < text_process.length; ++i) {
                arrayA[i] += 1
            }
            text_process = arrayA
        }
    }

    signal backToHomePage()

    Rectangle {
        id: rect_info
        width: parent.width
        height: parent.height * 0.3
        color: "transparent"
        TLInfoDisplayPage {
            id: tl_info_display
            anchors.fill: parent
        }
    }
    Rectangle {
        id: rec_control_page
        width: parent.width
        height:  parent.height * 0.4
        anchors.top: rect_info.bottom
        anchors.left: parent.left
        color: "transparent"
        Rectangle {
            id: rec_power
            width: parent.width
            height: parent.height * 0.4
            color: "transparent"
            Row {
                anchors.fill: parent
                Rectangle {
                    width: parent.width / 3
                    height: parent.height
                    color: "transparent"
                    Image {
                        id: pic_back
                        height: parent.height * 0.95
                        width: height
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
                    color: "transparent"
                    Image {
                        id: pic_ok
                        visible: !has_error
                        height: parent.height * 0.8
                        width: height
                        source: "qrc:/res/pictures/finish.png"
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                    }
                    Image {
                        id: pic_warn
                        visible: has_error
                        height: parent.height * 0.8
                        width: height
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
                    color: "transparent"
                    property bool is_processing: false
                    Image {
                        id: pic_task_stop
                        visible: !rec_progress_state.is_processing
                        height: parent.height * 0.8
                        width: height
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
                        height: parent.height
                        width: height
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
            id: rect_logo
            width: parent.width
            height: parent.height * 0.6
            anchors.top: rec_power.bottom
            color: "transparent"
            Image {
                id: pic_car
                source: "qrc:/res/pictures/logo_2.png"
                height: parent.height * 1.5
                width: height
                anchors.centerIn:  parent
                fillMode: Image.PreserveAspectFit
            }
        }
    }
    Rectangle {
        id: rec_progress_nfo
        width: parent.width
        height: parent.height * 0.3
        anchors.top: rec_control_page.bottom
        color: "transparent"
        Text {
            id: text_current_map
            width: parent.width
            height: parent.height * 0.3
            color: "white"
            text: qsTr("Current map: " + " " + current_map)
            font.pixelSize: rate * rec_progress_nfo.height * 0.2
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: rec_progress_nfo.height * 0.1
        }
        Column {
            width: parent.width
            height: parent.height * 0.7
            anchors.top: text_current_map.bottom
            Repeater {
                model: list_model_process
                Rectangle {
                    width: parent.width
                    height: parent.height / 3
                    color: "transparent"
                    Text {
                        anchors {
                            top: parent.top
                            left: parent.left
                            leftMargin: rec_progress_nfo.height * 0.1
                        }
                        text: qsTr(obj_name_process_info + "  " + text_process_info + " " + data_unit_ifo)
                        font.pixelSize: rate * rec_progress_nfo.height * 0.2
                        color: "white"
                    }
                }
            }
            ListModel {
                id: list_model_process
            }
        }
    }
    function addProcessdata()
    {
        for (var i = 0; i < text_process.length; ++i) {
            list_model_process.append({"obj_name_process_info": obj_name_process[i],
                                          "text_process_info": text_process[i], "data_unit_ifo": data_unit[i]})
        }
    }

    TLDialog {
        id: dialog_machine_warn
        width: root.width * 0.4
        height: root.height * 0.3
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("Warn!")
        dia_title_color: "red"
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
        dia_title_color: "#4F94CD"
        dia_image_source: "qrc:/res/pictures/smile.png"
        onOkClicked: {
            backToHomePage()
            dialog_machine_back.close()
        }
        onCencelClicked: {
            dialog_machine_back.close()
        }
    }
}

