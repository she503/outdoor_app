import QtQuick 2.0
import QtQuick.Controls 2.2

Dialog {
    id: dialog_info
    property bool is_single_btn: false
    property string dia_title: ""
    property string dia_title_color: ""
    property string dia_image_source: ""
    signal okClicked()
    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
    }
    contentItem: Rectangle {
        color: "transparent"
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "qrc:/res/pictures/background_glow2.png"
        }
        Rectangle {
            width: parent.width * 0.8
            height: parent.height * 0.7
            anchors.centerIn: parent
            Column {
                width: parent.width
                height: parent.height
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.3
                    Label {
                        text: qsTr(dia_title)
                        font.pixelSize: 15 * rate
                        color:dia_title_color
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.5
                    Image {
                        source: dia_image_source
                        anchors.fill: parent
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                    }
                }
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.2
                    Row {
                        spacing: 10 * rate
                        anchors.centerIn: parent

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
                                        dialog_info.close()
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
}
