import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    color: "transparent"
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
            width: parent.width * 0.9
            height: parent.height * 0.88
            anchors.centerIn: parent
            color: "white"
            Column {
               anchors.fill: parent
                Repeater {
                    delegate: Rectangle {
                        width: parent.width
                        height: parent.height / (list_model.count )
                        color: "transparent"
                        border.width: 1
                        border.color: "lightblue"
                        Text {
                            id: model_name
                            clip: true
                            anchors.left: parent.left
                            anchors.leftMargin: 5 * rate
                            text: model.name
                            objectName: model.name
                            width: parent.width
                            height: parent.height * 0.6
                            font.bold: true
                            font.pixelSize: 15 * rate
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            anchors.centerIn: parent
                            text: content
                        }
                    }
                    model: ListModel {
                        id: list_model
                        ListElement {
                            name: qsTr("Software version number: ")//软件版本号
                            content: qsTr("1 ")
                        }
                        ListElement {
                            name: qsTr("Vehicle ID: ")//车辆ID
                            content: qsTr("2 ")
                        }
                        ListElement {
                            name: qsTr("xxx: ")
                            content: qsTr(" ")
                        }
                        ListElement {
                            name: qsTr("xxx: ")
                            content: qsTr(" ")
                        }
                        ListElement {
                            name: qsTr("xxxxx: ")
                            content: qsTr(" ")
                        }
                    }
                }
            }
        }
    }
}
