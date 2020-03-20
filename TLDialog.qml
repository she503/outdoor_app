import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    id: dialog_info
    property bool is_single_btn: false
    property string dia_title: ""
    property string dia_image_source: ""
    signal okClicked()
    contentItem: Rectangle {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "qrc:/res/pictures/background_glow2.png"
        }
        Rectangle {
            width: parent.width * 0.8
            height: parent.height * 0.7
            anchors.centerIn: parent
            ColumnLayout {
                width: parent.width
                height: parent.height
                Label {
                    text: qsTr(dia_title)
                    font.pixelSize: 15 * rate
                    anchors.horizontalCenter: parent.horizontalCenter
                    Layout.alignment: Qt.AlignCenter
                }
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.2
                    anchors.centerIn: parent
                    color: "transparent"
                    Image {
                        source: dia_image_source
                        anchors.fill: parent
                        Layout.alignment: Qt.AlignCenter
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Row {
                    spacing: 20
                    width: parent.width
                    height: parent.height * 0.7
                    Layout.alignment: Qt.AlignCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: 50 * rate
                        height: 25 * rate
                        visible: !is_single_btn
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/res/pictures/btn_style2.png"
                            fillMode: Image.PreserveAspectFit
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                            Text {
                                anchors.centerIn: parent
                                color: "white"
                                text: qsTr("No")
                                font.pixelSize: 12 * rate
                                font.family: "Arial"
                                font.weight: Font.Thin
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                }
                            }
                        }
                    }
                    Rectangle {
                        width: 50 * rate
                        height: 25 * rate
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/res/pictures/btn_style2.png"
                            fillMode: Image.PreserveAspectFit
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                            Text {
                                text: qsTr("Ok")
                                anchors.centerIn: parent
                                color: "white"
                                font.pixelSize: 12 * rate
                                font.family: "Arial"
                                font.weight: Font.Thin
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
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
    }
}
