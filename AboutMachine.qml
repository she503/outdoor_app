import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    Column {
        Repeater {
            delegate: Rectangle {
                width: root.width
                height: root.width * 0.08
                color: "white"
                border.width: 1
                border.color: "lightblue"
                Text {
                    id: model_name
                    clip: true
                    anchors.right: parent.right
                    text: model.name
                    objectName: model.name
                    width: parent.width
                    height: parent.height * 0.6
                    font.bold: true
                    font.pixelSize: height * 0.7
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    anchors.centerIn: parent
                    text: content
                }
            }
            model: ListModel {
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
