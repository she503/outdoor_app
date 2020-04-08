import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    color: "transparent"
    property string url_name: "http://www.tonglurobot.com/"
    signal attrChanged(var current_index)
    onAttrChanged: {
        if (current_index === 0) {
            stack_attr.replace(col_car_info)
        } else if (current_index === 1) {
            stack_attr.replace(col_device_info)
        }
        btn_back.visible = true
    }

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
                height: parent.height * 0.3
                color: "transparent"
                Image {
                    height: parent.height * 0.6
                    width: parent.width * 0.6
                    anchors.centerIn: parent
                    source: "qrc:/res/pictures/logo_2.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
            Rectangle {
                id: rec_car_info
                width: parent.width * 0.6
                height: parent.height * 0.5
                anchors {
                    top: rec_company_info.bottom
//                    horizontalCenter: parent.horizontalCenter
                    left: parent.left
                    leftMargin: height * 0.5
                }
                color: "transparent"
                Rectangle {
                    id: btn_back
                    visible: false
                    anchors.right: rec_car_info.left
                    height: parent.height * 0.15
                    width: height
                    color: "transparent"
                    Image {
                        source: "qrc:/res/pictures/back.png"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                btn_back.visible = false
                                stack_attr.replace(stack_attr.initialItem)
                            }
                        }
                    }
                }

                ListView {
                    id: list_view_attr
                    spacing: height * 0.002
                    currentIndex: 0
                    highlight: Rectangle {color: "transparent"}
                    clip: true
                    highlightFollowsCurrentItem: false
                    delegate: ItemDelegate {
                        id: item
                        height: list_view_attr.height / 2
                        width: height * 2.5
                        property real id_num: model.id_num
                        anchors.horizontalCenter: parent.horizontalCenter
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            opacity: list_view_attr.currentIndex == item.id_num ? 1 : 0.3
                            Text {
                                id: attr_car
                                clip: true
                                anchors.centerIn: parent
                                text: model.btn_text
                                width: parent.width * 0.5
                                height: parent.height * 0.6
                                font.bold: false
                                font.pixelSize: height * 0.4
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                            }
                            Image {
                                height: parent.height * 0.3
                                width: height
                                source: "qrc:/res/pictures/arrow-right.png"
                                anchors.left: attr_car.right
                                anchors.leftMargin: parent.height * 0.1
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Image.AlignVCenter
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                        onClicked: {
                            list_view_attr.currentIndex = index
                            attrChanged(list_view_attr.currentIndex)
                        }
                    }
                    model: ListModel {
                        id: list_model_attr
                        ListElement {
                            id_num: 0
                            btn_text: qsTr("car information")
                            focus_source: "qrc:/res/pictures/home.png"
                        }
                        ListElement {
                            id_num: 1
                            btn_text: qsTr("device information")
                            focus_source: "qrc:/res/pictures/user.png"
                        }
                    }
                }

                StackView {
                    id: stack_attr
                    anchors.fill: parent
                    initialItem: list_view_attr

                    replaceEnter: Transition {

                    }
                    replaceExit: Transition {

                    }
                }

                // car information
                Column {
                    id: col_car_info
                    visible: false
                    width: parent.width
                    height: parent.height
                    anchors.left: parent.left
                    anchors.leftMargin: height * 0.15
                    Repeater {
                        id: repeater_car
                        clip: true
                        delegate: Rectangle {
                            width: parent.width
                            height: parent.height / repeater_car.count
                            color: "transparent"
                            Text {
                                id: text_car
                                clip: true
                                text: model.name
                                width: parent.width * 0.5
                                height: parent.height * 0.6
                                font.bold: false
                                font.pixelSize: height * 0.6
                                anchors.verticalCenter: parent.verticalCenter
                                //                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                color: "#8B8386"
                            }
                            Text {
                                anchors {
                                    left: text_car.right
                                    leftMargin: parent.width * 0.1
                                    verticalCenter: parent.verticalCenter
                                }
                                width: parent.width * 0.5
                                height: parent.height * 0.6
                                font.bold: true
                                font.pixelSize: height * 0.6
                                text: content
                            }
                        }
                        model: ListModel {
                            ListElement {
                                name: qsTr("Vehicle number:")
                                content: qsTr("zz01a")
                            }
                            ListElement {
                                name: qsTr("Car type:")
                                content: qsTr("SC50-A")
                            }
                            ListElement {
                                name: qsTr("Production Date:")
                                content: qsTr("2020.04.08")
                            }
                            ListElement {
                                name: qsTr("Intelligent driving system version number:")
                                content: qsTr("tergeo 2.0")
                            }
                            ListElement {
                                name: qsTr("Intelligent driving system updated:")
                                content: qsTr("2020.04.08")
                            }
                        }
                    }
                }

                // device information
                Column {
                    id: col_device_info
                    visible: false
                    width: parent.width
                    height: parent.height
                    anchors.left: parent.left
                    anchors.leftMargin: height * 0.15
                    Repeater {
                        id:repeater_device
                        clip:true
                        delegate: Rectangle {
                            width: parent.width
                            height: parent.height / repeater_device.count
                            color: "transparent"
                            Text {
                                id: text_device
                                clip: true
                                text: model.name
                                width: parent.width * 0.5
                                height: parent.height * 0.6
                                font.bold: false
                                font.pixelSize: height * 0.6
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignLeft
                                color: "#8B8386"
                            }
                            Text {
                                anchors {
                                    left: text_device.right
                                    leftMargin: parent.width * 0.1
                                    verticalCenter: parent.verticalCenter
                                }
                                width: parent.width * 0.5
                                height: parent.height * 0.6
                                font.bold: true
                                font.pixelSize: height * 0.6
                                text: content
                            }
                        }
                        model: ListModel {
                            ListElement {
                                name: qsTr("Device name:")
                                content: qsTr("RK-3288")
                            }
                            ListElement {
                                name: qsTr("operating system:")
                                content: qsTr("Android")
                            }
                            ListElement {
                                name: qsTr("Software version number:")
                                content: qsTr("Android 9.1.1")
                            }
                            ListElement {
                                name: qsTr("Software update:")
                                content: qsTr("2020.04.08")
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: rec_connect_us
                width: parent.width
                height: parent.height * 0.2
                anchors {
                    top: rec_car_info.bottom
                }
                color: "transparent"
                Button {
                    id: btn_url
                    width: parent.width * 0.2
                    height: parent.height * 0.3
                    anchors.centerIn: parent
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

            }

        }
    }
}
