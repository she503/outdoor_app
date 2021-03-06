import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item  {
    id: root
    Button {
        id: btn_error
        visible: has_error
        anchors.fill: parent
        background: Rectangle {
            implicitWidth: 83
            implicitHeight: 37
            color: "transparent"
            radius: width / 2
            Image {
                anchors.fill: parent
                source: "qrc:/res/pictures/warn.png"
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
                        id: pic_error_icon
                        height: parent.height * 0.6
                        width: parent.height
                        source: "qrc:/res/pictures/warn.png"
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
                                        width: rec_message_info.width / error_list.length
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
                                        }
                                    }
                                }
                            }
                            //                            onPressed: {
                            //                                list_error_message.currentIndex = index
                            //                                item_message.is_active = !item_message.is_active
                            //                            }
                            //                            onReleased:  {
                            //                                list_error_message.currentIndex = index
                            //                                item_message.is_active = !item_message.is_active
                            //                            }
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
        id:test_timer
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            error_level+= 1
            error_list[0] = Qt.formatDateTime(new Date(), "hh:mm:ss")
            addMessageListData()
            if (has_error) {
                has_error = false
            } else {
                has_error = true
            }
        }
    }
}
