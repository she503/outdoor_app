import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as Control_14
Rectangle {
    id: root

    Control_14.SplitView {
        id: split_view
        anchors.fill: parent
        orientation: Qt.Horizontal
        Rectangle {
            id: rect_left
            width: parent.width * 0.2
            height: parent.height
            ListView {
                id: list_view
                anchors.fill: parent
                spacing: height * 0.001
                delegate: Rectangle {
                    width: list_view.width
                    height: list_view.height / 8
                    color: "blue"
                    Row {
                        id: row
                        anchors.fill: parent
                        Image {
                            id: img_logo
                            width: parent.width * 0.2
                            height: parent.height
                            source: source
                        }

                        Text {
                            text: name
                            objectName: obj_name
                            width: parent.width * 0.5
                            height: parent.height
                            font.bold: true
                            verticalAlignment: Text.AlignVCenter
                        }
                        Image {
                            id: img_right
                            width: parent.width * 0.2
                            height: parent.height
                            source: ""
                        }
                        spacing: width * 0.03
                    }
                }
                model: ListModel {
                    ListElement {
                        obj_name: "one"
                        name: qsTr("one")
                        source: ""
                    }
                    ListElement {
                        obj_name: "tow"
                        name: qsTr("tow")
                        source: ""
                    }
                }
            }
        }
        Rectangle {
            id: rect_right
            width: parent.width * 0.8
            height: parent.height
            color:"green"
        }
    }

}
