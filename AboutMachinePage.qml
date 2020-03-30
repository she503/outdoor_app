import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    color: "transparent"
    property string url_name: "http://www.tonglurobot.com/"
    Rectangle {
        id: rec_glow_background
        height: parent.width > parent.height ? parent.height * 0.9 : parent.width * 0.9 * 0.787
        width: parent.width > parent.height ? parent.height * 0.9 * 1.27 : parent.width * 0.9
        anchors.centerIn: parent
        color: "transparent"
        Image {
            anchors.fill: parent
            source: "qrc:/res/pictures/background_glow1.png"
        }
        Rectangle {
            width: parent.width * 0.88
            height: parent.height * 0.85
            anchors.centerIn: parent
            color: Qt.rgba(255, 255, 255, 0.5)
            Rectangle {
                id: rec_company_info
                width: parent.width
                height: parent.height * 0.6
                color: "transparent"
                Image {
                    height: parent.height / 2
                    width: parent.width / 2
                    anchors.centerIn: parent
                    source: "qrc:/res/pictures/logo_2.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
            Rectangle {
                id: rec_car_info
                width: parent.width
                height: parent.height * 0.4
                anchors {
                    top: rec_company_info.bottom
                }
                color: "transparent"
                Button {
                    id: btn_url
                    width: parent.width * 0.2
                    height: parent.height * 0.3
                    anchors.horizontalCenter: parent.horizontalCenter
                    contentItem: Text {
                        text: qsTr("contact us")
                        color: "grey"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: width * 0.2
                    }
                    background: Rectangle {
                        implicitWidth: 83
                        implicitHeight: 37
                        color: btn_url.down ? "lightblue" : "#7EC0EE"
                        radius: width / 2
                    }
                    onReleased: {
                        Qt.openUrlExternally(url_name)
                    }
                }

                Column {
                    visible: false
                    width: parent.width
                    height: parent.height
                    Repeater {
                        delegate: Rectangle {
                            width: parent.width
                            height: parent.height / (list_model.count )
                            color: "transparent"
                            Text {
                                id: model_name
                                clip: true
                                text: model.name
                                objectName: model.name
                                width: parent.width * 0.4
                                height: parent.height * 0.6
                                font.bold: false
                                font.pixelSize: height * 0.9
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: "#8B8386"
                            }
                            Text {
                                anchors {
                                    left: model_name.right
                                    leftMargin: parent.width * 0.05
                                }
                                width: parent.width * 0.35
                                height: parent.height * 0.6
                                font.bold: true
                                font.pixelSize: height * 0.9

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
}
