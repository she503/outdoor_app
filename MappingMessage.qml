import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root
    color: "transparent"

    function getCommandString(command) {
        var str = ""
        if (command === 1) {
            str = qsTr("start")
        } else if(command === 2) {
            str = qsTr("reset")
        } else if(command === 3) {
            str = qsTr("stop")
        } else if(command === 4) {
            str = qsTr("mapping")
        }
        return str;
    }

    function setPercent(percent) {
        message_list_model.get(0).mapping_time = Qt.formatDateTime(new Date(), "hh:mm:ss")
        message_list_model.get(0).mapping_message = "Current Mapping Percent: " + percent
    }

    function setMessage(flag, command,message) {
        message_list_model.insert(0,{"mapping_time": Qt.formatDateTime(new Date(), "hh:mm:ss"),
                                       "mapping_flag": flag,
                                       "mapping_command": root.getCommandString(command),
                                       "mapping_message": message})
    }

    Connections {
        target: mapping_manager
        onEmitmappingProgressInfo: {
            root.setPercent(progress)
        }
    }

    Rectangle {
        id: rect_temp
        width: parent.width
        height: parent.height * 0.07
        color: rect_attr.color
//        border.color: "green"
        anchors.top: parent.top
        anchors.topMargin: height
    }
    Column {
        clip: true
        anchors.fill: parent

        Rectangle {
            id: rect_attr
            width: parent.width
            height: parent.height * 0.125
            color: "lightblue"
//            border.color: "green"
            clip: true
            radius: height * 0.3
            Row {
                anchors.fill: parent
                clip: true
                Rectangle {
                    width: parent.width * 0.2
                    height: parent.height
                    color: "transparent"
                    clip: true
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
                    clip: true
                }
                Rectangle {
                    width: parent.width * 0.2
                    height: parent.height
                    color: "transparent"
                    clip: true
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
                    clip: true
                }
                Rectangle {
                    width: parent.width * 0.6
                    height: parent.height
                    color: "transparent"
                    clip: true
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
            clip: true
            ListView {
                id: list_message
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
                    background: Rectangle {
                        anchors.fill: parent
                        color: model.mapping_flag ? "#7CFC00" : "red"
                        opacity: 0.4
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
                                color: "black"
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
                                color: "black"
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
                                text: model.mapping_message
                                font.pixelSize: height * 0.3
                                font.bold: true
                                color: "black"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
                model: ListModel {
                    id: message_list_model
                }
            }
        }
    }
}
