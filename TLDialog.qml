import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    id: dialog_info
    property bool is_single_btn: false
    property string dia_title: ""
    property string dia_info_text: ""
    signal okClicked()
    contentItem: Rectangle {
        anchors.fill: parent
        color: "#C5F2F2"
        border.width: 0.5
        border.color: "#97D0D1"
        ColumnLayout {
            width: parent.width
            height: parent.height
            Label {
                text: qsTr(dia_title)
                font.pixelSize: 15 * rate
            }
            Label {
                text: qsTr(dia_info_text)
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: 10 * rate
            }
            Row {
                spacing: 20
                width: parent.width
                height: parent.height * 0.7
                Layout.alignment: Qt.AlignCenter
                Rectangle {
                    width: 50 * rate
                    height: 25 * rate
                    radius: width / 2
                    color: "orange"
                    visible: !is_single_btn
                    Text {
                        text: qsTr("No")
                        font.pixelSize: 12 * rate
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            dialog_info.close()
                        }
                    }
                }
                Rectangle {
                    width: 50 * rate
                    height: 25 * rate
                    radius: width / 2
                    color: "green"
                    Text {
                        text: qsTr("Ok")
                        font.pixelSize: 12 * rate
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            okClicked()
                        }
                    }
                }
            }
        }
    }
}
