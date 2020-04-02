import QtQuick 2.0
import QtQuick.Controls 2.2
import "CustomControl"



Rectangle {
    id: root

    color: "transparent"

    property string map_name: ""
    property string work_time: ""
    property string progress: ""
    property string title_color: "white"
    property string font_color: "lightgreen"

    signal sigBackBtnPress()
    signal sigStopBtnPress()
    signal sigEndingBtnPress()

    Connections {
        target: map_task_manager
        onUpdateTaskProcessInfo: {
            root.progress = progress * 100;

        }
    }

    Column{
        anchors.fill: parent
        Rectangle {
            id: rect_info
            width: parent.width
            height: parent.height * 0.4
            color: "transparent"
            TLInfoDisplayPage {
                id: tl_info_display
                anchors.fill: parent
            }
        }
        Rectangle {
            id: rect_btns
            width: parent.width
            height: parent.height * 0.1
            color: "transparent"
            Row {
                property real btn_spacing: parent.width * 0.03
                spacing: btn_spacing / 3
                height: parent.height
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    id: btn_back
                    source: "qrc:/res/pictures/back.png"
                    width: (parent.width -  parent.btn_spacing)/ 3
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.sigBackBtnPress()

                        }
                    }
                }
                Image {
                    id: btn_stop
                    width: (parent.width -  parent.btn_spacing)/ 3
                    height: parent.height
                    source: "qrc:/res/pictures/progress_start.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.sigStopBtnPress()

                        }
                    }
                }
                Image {
                    id: btn_ending
                    width:  (parent.width -  parent.btn_spacing)/ 3
                    height: parent.height
                    source: "qrc:/res/pictures/power_on.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.sigEndingBtnPress()
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rect_logo
            width: parent.width
            height: parent.height * 0.1
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/logo_2.png"
                fillMode: Image.PreserveAspectFit
            }
        }
        Rectangle {
            id: rect_task_progress
            width: parent.width
            height: parent.height * 0.4
            color: "transparent"
            Column {
                anchors.fill: parent
                Rectangle {
                    id: rect_map_name
                    width: parent.width
                    height: parent.height * 0.3
                    color: "transparent"
                    Text {
                        id: text_1
                        text: qsTr("Current map name: ")
                        width: parent.width * 0.7
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: width / 10
                        color: root.title_color
                    }
                    Text {
                        id: text_map_name
                        text: root.map_name
                        width: parent.width * 0.3
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: width / 10
                        anchors.left: text_1.right
                        color: root.font_color
                    }
                }

                Rectangle {
                    id: rect_work_time
                    width: parent.width
                    height: parent.height * 0.3
                    color: "transparent"
                    Text {
                        id: text_2
                        text: qsTr("Work time: ")
                        width: parent.width * 0.7
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: width / 10
                        color: root.title_color
                    }
                    Text {
                        id: text_work_time
                        text: root.work_time
                        width: parent.width * 0.3
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: width / 6
                        anchors.left: text_2.right
                        color: root.font_color
                    }

                }

                Rectangle {
                    id: rect_progress
                    width: parent.width
                    height: parent.height * 0.3
                    color: "transparent"
                    Text {
                        id: text_3
                        text: qsTr("task persent: ")
                        width: parent.width * 0.7
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: width / 10
                        color: root.title_color
                    }
                    Text {
                        id: text_progress
                        text: root.progress + "%"
                        width: parent.width * 0.3
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: width / 6
                        anchors.left: text_3.right
                        color: root.font_color
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
}

//Rectangle {
//    id: rec_left
//    height: parent.height
//    width: height / 5 * 2.4
//    color: "transparent"
//    Rectangle {
//        id: rec_turn_view
//        visible: false
//        anchors.fill: parent
//        color: "transparent"
//        Rectangle {
//            id: rec_pic_car
//            width: parent.width
//            height:  parent.height * 0.5
//            anchors.top: rect_info_display.bottom
//            anchors.left: parent.left
//            color: "transparent"
//            Rectangle {
//                id: rec_power_control
//                width: parent.width
//                height: parent.height * 0.3
//                color: "transparent"
//                Row {
//                    anchors.fill: parent
//                    Rectangle {
//                        width: parent.width / 3
//                        height: parent.height
//                        color: "transparent"
//                        Image {
//                            id: pic_back
//                            width: 60 * rate * ratio
//                            height: 60 * rate * ratio
//                            source: "qrc:/res/pictures/back.png"
//                            anchors.centerIn: parent
//                            fillMode: Image.PreserveAspectFit
//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: {
//                                    dialog_machine_back.open()
//                                }
//                            }
//                        }
//                    }
//                    Rectangle {
//                        id: rec_machine_state
//                        width: parent.width / 3
//                        height: parent.height
//                        color: "transparent"
//                        Image {
//                            id: pic_ok
//                            visible: !has_error
//                            width: 50 * rate * ratio
//                            height: 50 * rate * ratio
//                            source: "qrc:/res/pictures/finish.png"
//                            anchors.centerIn: parent
//                            fillMode: Image.PreserveAspectFit
//                        }
//                        Image {
//                            id: pic_warn
//                            visible: has_error
//                            width: 50 * rate * ratio
//                            height: 50 * rate * ratio
//                            source: "qrc:/res/pictures/warn.png"
//                            anchors.centerIn: parent
//                            fillMode: Image.PreserveAspectFit
//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: {
//                                    dialog_machine_warn.open()
//                                }
//                            }
//                        }
//                    }
//                    Rectangle {
//                        id: rec_progress_state
//                        width: parent.width / 3
//                        height: parent.height
//                        color: "transparent"
//                        property bool is_processing: false
//                        Image {
//                            id: pic_task_stop
//                            visible: !rec_progress_state.is_processing
//                            width: 50 * rate * ratio
//                            height: 50 * rate * ratio
//                            source: "qrc:/res/pictures/progress_stop.png"
//                            anchors.centerIn: parent
//                            fillMode: Image.PreserveAspectFit
//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: {
//                                    if (rec_progress_state.is_processing) {
//                                        rec_progress_state.is_processing = false
//                                    } else {
//                                        rec_progress_state.is_processing = true
//                                    }
//                                }
//                            }
//                        }
//                        Image {
//                            id: pic_task_start
//                            visible: rec_progress_state.is_processing
//                            width: 60 * rate * ratio
//                            height: 60 * rate * ratio
//                            source: "qrc:/res/pictures/progress_start.png"
//                            anchors.centerIn: parent
//                            fillMode: Image.PreserveAspectFit
//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: {
//                                    if (rec_progress_state.is_processing) {
//                                        rec_progress_state.is_processing = false
//                                    } else {
//                                        rec_progress_state.is_processing = true
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            Rectangle {
//                id: rec_car_icon
//                width: parent.width
//                height: parent.height * 0.7
//                anchors.top: rec_power_control.bottom
//                color: "transparent"
//                Image {
//                    id: pic_car
//                    source: "qrc:/res/pictures/logo.png"
//                    width: 120 * rate * ratio
//                    height: 120 * rate * ratio
//                    anchors.centerIn:  parent
//                    fillMode: Image.PreserveAspectFit
//                }
//            }
//        }
//    }
//}
