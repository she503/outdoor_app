import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: root

    signal lockScreen()
    signal cannotOperatorTask()
    property bool is_locked: false
    property bool has_error: false
    property var error_list: [Qt.formatDateTime(new Date(), "hh:mm:ss"), "error level", "error code", "error detail"]
    property var error_message_info: [error_list]
    property var error_level: 0//: ["debug", "warn", "error"]
    property var error_text_color: "red"//: ["yellow", "orange", "red"]
    property bool is_first_get_error: false
    onError_levelChanged: {
        if (error_level % 2 == 0 ) {
            error_text_color = "red"
        } else {
            error_text_color = "green"
        }
    }

    Connections {
        target: ros_message_manager
        onUpdateMonitorMessageInfo: {
            message_list_model.clear()
            root.has_error = true
            if (!is_first_get_error) {
                is_first_get_error = true
                timer_btn_errror_flashes.start()
//                timer_btn_errror_open.start()   debug
                draw_error.open()
//                root.cannotOperatorTask()
            }
            for(var i = 0; i < monitor_message.length; ++i) {
                error_list[0] = Qt.formatDateTime(new Date(), "hh:mm:ss")
                error_list[1] = monitor_message[i][0]
                error_list[2] = monitor_message[i][1]
                error_list[3] = monitor_message[i][2]
                message_list_model.append({})
            }
        }
    }

    Button {
        id: btn_lock
        visible: !is_locked
        height: parent.height
        width: height
        anchors.right: parent.right
        background: Rectangle {
            height: parent.height * 2.27
            width: height
            color: "transparent"
            anchors.centerIn: parent
            radius: width / 2
            Image {
                height: parent.height * 0.6
                width: height
                anchors.centerIn: parent
                source: "qrc:/res/pictures/BUTTON-LOCK.png"
                fillMode: Image.PreserveAspectFit
            }
        }
        onClicked: {
            root.lockScreen()
        }
    }

    Button {
        id: btn_error
        visible: has_error
        height: parent.height
        width: height
        anchors.right: btn_lock.left
        anchors.rightMargin: height * 0.2
        background: Rectangle {
            height: parent.height * 1.36
            width: height
            color: "transparent"
            anchors.centerIn: parent
            radius: width / 2
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/BUTTON-WARNING1.png"
                fillMode: Image.PreserveAspectFit
            }
        }
        onClicked: {
            message_list_model.clear()
            addMessageListData()
            if(draw_error.visible){
                draw_error.close()
            }else{
                draw_error.open()
            }
        }
    }


    Drawer {
        id: draw_error
        visible: false
        width: parent.width
        height: parent.height
        modal: true
        dim: false
        edge: Qt.RightEdge
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle{
            opacity: 0.6
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient
                {
                    GradientStop{position: 0.3; color:"grey"}
                    GradientStop{position: 1; color:"black"}
                }
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                draw_error.close()
            }
        }
        Rectangle {
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/background_glow1.png"
            }
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.6
            x: (parent.width - width ) / 2
            y: (parent.height - height) / 2
            color: "transparent"
            Rectangle {
                width: parent.width * 0.9
                height: parent.height * 0.88
                anchors.centerIn: parent
                color: "transparent"
                Rectangle {
                    id: rec_message_head
                    width: parent.width
                    height: parent.height * 0.1
                    color: "transparent"
                    border.width: 1
                    border.color: Qt.rgba(100, 100, 200, 0.6)
                    Image {
                        id: img_exit
                        height: parent.height * 0.7
                        width: height
                        anchors {
                            right: parent.right
                            rightMargin: parent.height * 0.2
                            verticalCenter: parent.verticalCenter
                        }
                        source: "qrc:/res/pictures/exit.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                draw_error.close()
                            }
                        }
                    }
                    Image {
                        id: pic_error_icon
                        height: parent.height * 0.6
                        width: parent.height
                        source: "qrc:/res/pictures/BUTTON-WARNING1.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: qsTr("error message:")
                        width: parent.width
                        height: parent.height
                        anchors.left: pic_error_icon.right
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: parent.height * 0.6
                    }
                }
                Rectangle {
                    id: rec_message_info
                    width: parent.width
                    height: parent.height * 0.9
                    anchors.top: rec_message_head.bottom
                    border.width: 1
                    border.color: Qt.rgba(100, 100, 100, 0.6)
                    color: "transparent"
                    ListView {
                        id: list_error_message
                        clip: true
                        width: parent.width
                        height: parent.height
                        orientation:ListView.Vertical
                        spacing: height * 0.02
                        delegate: ItemDelegate {
                            id: item_message
                            width: parent.width
                            height: ListView.height
                            property bool is_active: false
                            background: Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                            }
                            Row {
                                anchors.fill: parent
                                Repeater {
                                    model: error_list
                                    Rectangle {
                                        width: index === 3 ? item_message.width * 0.4 : item_message.width * 0.2
                                        height: parent.height
                                        color: "transparent"
                                        Text {
                                            id: error_text
                                            clip: true
                                            anchors.fill: parent
                                            anchors.left: parent.left
                                            anchors.leftMargin: parent.width * 0.05
                                            text: modelData
                                            font.pixelSize: height * 0.3
                                            font.bold: true
                                            color: error_text_color
                                            horizontalAlignment: Text.AlignLeft
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.Wrap
                                        }
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
    }
    function addMessageListData()
    {
        for (var i = 0; i < error_message_info.length; ++i) {
            message_list_model.append({"error_message_text": error_message_info[i]})
        }
    }
    Timer {
        id: timer_btn_errror_flashes
        running: false
        repeat: true
        interval: 800
        onTriggered: {
            if (has_error) {
                btn_error.opacity = btn_error.opacity === 0 ? 1 : 0
            } else {
                timer_btn_errror_flashes.stop()
                btn_error.visible = false
            }
        }
    }
    Timer {
        id: timer_btn_errror_open
        running: false
        repeat: true
        interval: 5000
        onTriggered: {
            if (has_error) {
                draw_error.open()
            } else {
                timer_btn_errror_open.stop()
                btn_error.visible = false
            }
        }
    }
}
