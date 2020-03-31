import QtQuick 2.0
import QtQuick.Controls 2.2




Rectangle {
    id: rec_peocess
    width: parent.width
    height:  parent.height * 0.2
    anchors.top: rec_pic_car.bottom
    anchors.left: parent.left
    color: "transparent"
    Column {
        Repeater {
            model: [qsTr("Current map: "), qsTr("Worked hours: "), qsTr("Finished: "), qsTr("Estimated time: ")]
            Rectangle {
                width: rec_peocess.width
                height: rec_peocess.height * 0.25
                color: "transparent"
                Text {
                    anchors {
                        top: parent.top
                        left: parent.left
                        leftMargin: rec_peocess.width * 0.05
                    }
                    text: qsTr(modelData + "  " + text_process[index])
                    font.pixelSize: rate * 15 * ratio
                    color: "white"
                }
            }
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
