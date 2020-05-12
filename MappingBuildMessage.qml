import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root

    property real rect_radius: 10
    // TIME CMD MESSAGE ERROR_lEVEL
    property var mapping_message: [["1", "2", "3", "0"], ["4", "5", "6", "1"], ["7", "8", "9", "2"]]

    width: parent.width * 0.987
    height: parent.height * 0.98
    anchors.centerIn: parent
    color: "transparent"
    radius: rect_radius

    //test
//    Timer {
//        id: test_timer
//        running: true
//        interval: 1000
//        repeat: true
//        onTriggered: {
//            var time = Qt.formatDateTime(new Date(), "hh:mm:ss")
//            mapping_message.unshift([time, "w", "e", "0"])
//            message_list_model.clear()
//            message_list_model.addMappingMessage()
//        }
//    }

    Column {
        anchors.fill: parent
        Rectangle {
            id: rect_attr
            width: parent.width
            height: parent.height * 0.1
            color: "lightblue"
            radius: rect_radius
            Row {
                anchors.fill: parent
                Rectangle {
                    width: parent.width * 0.2
                    height: parent.height
                    radius: rect_radius
                    color: "transparent"
                    Text {
                        text: qsTr("Time")
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: parent.height * 0.4
                    }
                }
                Rectangle {
                    id: rect_split1
                    width: parent.width * 0.001
                    height: parent.height
                    color: "#B0E0E6"
                }
                Rectangle {
                    width: parent.width * 0.2
                    height: parent.height
                    radius: rect_radius
                    color: "transparent"
                    Text {
                        text: qsTr("Command")
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: parent.height * 0.4
                    }
                }
                Rectangle {
                    id: rect_split2
                    width: parent.width * 0.001
                    height: parent.height
                    color: "#B0E0E6"
                }
                Rectangle {
                    width: parent.width * 0.6
                    height: parent.height
                    radius: rect_radius
                    color: "transparent"
                    Text {
                        text: qsTr("Content")
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: parent.height * 0.4
                    }
                }
            }
        }

        Rectangle {
            id: rect_message_info
            width: parent.width
            height: parent.height * 0.9
            color: "transparent"
            ListView {
                id: list_mapping_build_message
                clip: true
                width: parent.width
                height: parent.height
                currentIndex: 0
                orientation:ListView.Vertical
                spacing: height * 0.005
                delegate: ItemDelegate {
                    id: item_message
                    width: parent.width
                    height: ListView.height
                    property real id_num: model.id_num
                    background: Rectangle {
                        anchors.fill: parent
                        color: list_mapping_build_message.currentIndex === item_message.id_num ?
                                   "#00cc00" : "lightgrey"
                        radius: rect_radius * 0.3
                    }
                    Row {
                        anchors.fill: parent
                        Rectangle {
                            width: item_message.width * 0.2
                            height: parent.height
                            color: "transparent"
                            Text {
                                id: text_time
                                clip: true
                                anchors.fill: parent
                                text: model.mapping_time
                                font.pixelSize: height * 0.3
                                font.bold: true
                                color: Number(model.error_level) === 0 ? "green" : "red"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                            }
                        }
                        Rectangle {
                            id: rect_split3
                            width: parent.width * 0.001
                            height: parent.height
                            color: "#B0E0E6"
                        }
                        Rectangle {
                            width: item_message.width * 0.2
                            height: parent.height
                            color: "transparent"
                            Text {
                                id: text_command
                                clip: true
                                anchors.fill: parent
                                text: model.mapping_command
                                font.pixelSize: height * 0.3
                                font.bold: true
                                color: Number(model.error_level) === 0 ? "green" : "red"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                            }
                        }
                        Rectangle {
                            id: rect_split4
                            width: parent.width * 0.001
                            height: parent.height
                            color: "#B0E0E6"
                        }
                        Rectangle {
                            width: item_message.width * 0.6
                            height: parent.height
                            color: "transparent"
                            Text {
                                id: text_string
                                clip: true
                                anchors.fill: parent
                                text: model.mapping_content
                                font.pixelSize: height * 0.3
                                font.bold: true
                                color: Number(model.error_level) === 0 ? "green" : "red"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
                model: ListModel {
                    id: message_list_model
                    function addMappingMessage() {
                        for(var i = 0; i < mapping_message.length; ++i) {
                            message_list_model.append({"id_num": i,
                                                          "mapping_time" : mapping_message[i][0],
                                                          "mapping_command" : mapping_message[i][1],
                                                          "mapping_content" : mapping_message[i][2],
                                                          "error_level" : mapping_message[i][3]})
                        }
                    }
                    Component.onCompleted: {
                        addMappingMessage()
                    }
                }
            }
        }
    }
}
