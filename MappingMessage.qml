import QtQuick 2.0
import QtQuick.Controls 2.2
import  QtGraphicalEffects 1.0

Rectangle {
    id: root
    color: "transparent"

    property string pro_message: ""

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

    function setOneTaskPercent(message,percent) {
        message_list_model.get(0).mapping_time = Qt.formatDateTime(new Date(), "hh:mm:ss")
        message_list_model.get(0).mapping_message = message + ": " + percent + "%"
    }

    function setMessage(flag, command,message) {
        message_list_model.insert(0,{"mapping_time": Qt.formatDateTime(new Date(), "hh:mm:ss"),
                                      "mapping_flag": flag,
                                      "mapping_command": root.getCommandString(command),
                                      "mapping_message": message})
    }

    Component.onCompleted: {
        message_list_model.insert(0,{"mapping_time": "1",
                                      "mapping_flag": false,
                                      "mapping_command": "2",
                                      "mapping_message": "message"})
    }


    Connections {
        target: mapping_manager
        onEmitmappingProgressInfo: {
            if (root.pro_message != message) {
                root.setMessage(true, 4, message)
                root.pro_message = message
            } else {
                root.setOneTaskPercent(message, progress)
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
                    opacity: 0.5
                    color: "transparent"
                    LinearGradient {
                        anchors.fill: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(300, 0)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: model.mapping_flag ? "#7CFC00" : "red"  }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }
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
                            text: "[19:01:23.123]"//model.mapping_time
                            font.pixelSize: height * 0.3
                            font.bold: true
                            color: "black"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
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
                            color: "white"
                            horizontalAlignment: Text.AlignLeft
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
