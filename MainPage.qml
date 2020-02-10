import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as Control_14
Rectangle {
    id: root

    signal mainPageChanged(var current_index)

    onMainPageChanged: {
        console.info(current_index)
    }

    Control_14.SplitView {
        id: split_view
        anchors.fill: parent
        orientation: Qt.Horizontal
        Rectangle {
            id: rect_left
            width: parent.width * 0.25
            height: parent.height
            color: "white"
            ListView {
                id: list_view
                anchors.fill: parent
                spacing: height * 0.002
                currentIndex: -1
                delegate: ItemDelegate {
                    width: list_view.width
                    height: list_view.height / 8
                    highlighted: ListView.isCurrentItem
                    Row {
                        id: row
                        anchors.fill: parent
                        Image {
                            id: img_logo
                            width: parent.width * 0.2
                            height: parent.height
                            source: sourcee
                            fillMode: Image.PreserveAspectFit
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                        }

                        Rectangle {
                            width: parent.width * 0.5
                            height: parent.height

                            Text {
                                id: model_name
                                clip: true
                                text: "  " + model.name
                                objectName: model.obj_name
                                width: parent.width
                                height: parent.height * 0.6
                                font.bold: true
                                font.pixelSize: height * 0.7
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                id: description
                                text: " " + model.text_description
                                clip: true
                                width: parent.width
                                height: parent.height * 0.3
                                font.pixelSize: height * 0.5
                                anchors {
                                    top: model_name.bottom
                                }
                            }
                            color: "transparent"
                        }
                        Image {
                            id: img_right
                            width: parent.width * 0.2
                            height: parent.height
                            source: "qrc:/res/pictures/arrow-right.png"
                            fillMode: Image.PreserveAspectFit
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                        }
                    }
                    onClicked: {
                        list_view.currentIndex = index
                        mainPageChanged(list_view.currentIndex)
                    }
                }
                model: ListModel {
                    ListElement {
                        obj_name: "home"
                        name: qsTr("home")
                        text_description: qsTr("homeeeee")
                        sourcee: "qrc:/res/pictures/home.png"
                    }
                    ListElement {
                        obj_name: "user"
                        name: qsTr("user")
                        text_description: qsTr("userrrr")
                        sourcee: "qrc:/res/pictures/user.png"
                    }
                    ListElement {
                        obj_name: "setting"
                        name: qsTr("setting")
                        text_description: qsTr("setting ")
                        sourcee: "qrc:/res/pictures/setting.png"
                    }
                    ListElement {
                        obj_name: "help"
                        name: qsTr("help")
                        text_description: qsTr("helppp")
                        sourcee: "qrc:/res/pictures/help.png"
                    }
                    ListElement {
                        obj_name: "about"
                        name: qsTr("about")
                        text_description: qsTr("abouttttt")
                        sourcee: "qrc:/res/pictures/about.png"
                    }
                }

            }
        }
        Rectangle {
            id: rect_right
            width: parent.width * 0.75
            height: parent.height
            color:"transparent"
            StackView {
                id: stack_view
                anchors.fill: parent
//                initialItem:
            }
        }
    }



}
