import QtQuick 2.0
import QtQuick.Controls 2.2

Dialog {
    id: root
    width: 300
    height: 200

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    property int status: 0 // "success" : 1;     "faild" : 0

    property bool cancel: true
    property string cancel_text: "OK"

    property bool ok: false
    property string ok_text: ""

    property string dia_title: ""
    property string dia_content: ""
    property string dia_background: status === 0 ? "qrc:/res/pictures/error_background.png" :
                                               "qrc:/res/pictures/success_background.png"

    signal okClicked()
    signal cancelClicked()
    background: Rectangle {
        color: "transparent"
        Image {
            anchors.fill: parent
            source: root.dia_background
        }
    }

    contentItem: Rectangle {
        width: parent.width * 0.8
        height: parent.height * 0.9
        anchors.centerIn: parent
        color: "transparent"
        Text {
            id: title
            width: parent.width * 0.8
            height: parent.height * 0.1
            color: status === 0 ? "red" : "green"
            text: root.dia_title
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height * 0.7
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.02
        }
        Rectangle {
            id: rect_split
            width: parent.width * 0.8
            height: parent.height * 0.01
            anchors.top: title.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color:"#B0E0E6"
            opacity: 0.5
        }


        Flickable {
            id: flick
            width: parent.width * 0.8
            height: parent.height * 0.7
            contentWidth: width
            contentHeight: content.paintedHeight
            clip: true
            anchors{
                top: rect_split.bottom
                topMargin: parent.height * 0.02
                horizontalCenter: parent.horizontalCenter
            }
            TextEdit {
                id: content
                anchors.fill: parent
                text: "   " + root.dia_content//root.dia_content
                color: "black"
                width: flick.width
                height: flick.height
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: width * 0.1
                wrapMode: TextEdit.Wrap
                activeFocusOnPress: false
                focus: false
            }
        }

//        TextEdit {
//            id: content
//            text: "   " + root.dia_content//root.dia_content
//            color: "black"
//            width: parent.width * 0.8
//            height: parent.height * 0.5
//            horizontalAlignment: Text.AlignLeft
//            verticalAlignment: Text.AlignVCenter
//            font.pixelSize: width * 0.1
//            anchors{
//                top: rect_split.bottom
//                topMargin: parent.height * 0.02
//                horizontalCenter: parent.horizontalCenter
//            }
//            wrapMode: Text.Wrap
//        }
        Rectangle {
            id: rect_btn
            width: parent.width * 0.8
            height: parent.height * 0.3
            anchors.bottom: parent.bottom
//            anchors.bottomMargin: -parent.height * 0.01
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            TLButton {
                id: btn_cancle
                visible: root.cancel
                width:parent.width * 0.35
                height: parent.height * 0.5
                anchors{
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin:  btn_ok.visible ? 0 : (parent.width - width) / 2
                }
                btn_text: root.cancel_text
                onClicked: {
                    root.close()
                    cancelClicked()
                }
            }
            TLButton {
                id: btn_ok
                visible: root.ok
                width: parent.width * 0.35
                height: parent.height * 0.5
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                btn_text: root.ok_text
                onClicked: {
                    okClicked()
                }
            }

        }
    }

}

//Dialog {
//    id: dialog_info
//    property bool is_single_btn: false
//    property string dia_title: ""
//    property string dia_title_color: ""
//    property string dia_image_source: ""
//    signal okClicked()

//    signal cencelClicked()
//    background: Rectangle {
//        anchors.fill: parent
//        color: "transparent"
//    }
//    contentItem: Rectangle {
//        color: "transparent"
//        anchors.fill: parent
//        Image {
//            anchors.fill: parent
//            source: "qrc:/res/pictures/success_background.png"
//        }
//        Rectangle {
//            width: parent.width * 0.8
//            height: parent.height * 0.7
//            anchors.centerIn: parent
//            Column {
//                width: parent.width
//                height: parent.height
//                Rectangle {
//                    width: parent.width
//                    height: parent.height * 0.3
//                    Label {
//                        anchors.fill: parent
//                        text: qsTr(dia_title)
//                        font.pixelSize: height * 0.5
//                        color:dia_title_color
//                        anchors.centerIn: parent
//                        font.bold: true
//                    }
//                }
//                Rectangle {
//                    width: parent.width
//                    height: parent.height * 0.5
//                    Image {
//                        source: dia_image_source
//                        anchors.fill: parent
//                        anchors.centerIn: parent
//                        fillMode: Image.PreserveAspectFit
//                    }
//                }
//                Rectangle {
//                    width: parent.width
//                    height: parent.height * 0.2


//                    Rectangle {
//                        id: btn_no
//                        width: parent.width * 0.5
//                        height: parent.height
//                        visible: !is_single_btn
//                        color: "transparent"
//                        Image {
//                            anchors.fill: parent
//                            source: "qrc:/res/pictures/btn_style2.png"
//                            fillMode: Image.PreserveAspectFit
//                            horizontalAlignment: Image.AlignHCenter
//                            verticalAlignment: Image.AlignVCenter
//                            Text {
//                                anchors.fill: parent
//                                color: "black"
//                                text: qsTr("No")
//                                font.pixelSize: height * 0.8
//                                font.family: "Arial"
//                                font.weight: Font.Thin
//                                horizontalAlignment: Text.AlignHCenter
//                                verticalAlignment: Text.AlignVCenter
//                            }
//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: {
//                                    cencelClicked()// dialog_info.close()
//                                }
//                            }
//                        }
//                    }
//                    Rectangle {
//                        width: parent.width * 0.5
//                        height: parent.height
//                        color: "transparent"
//                        anchors.left: btn_no.right
//                        Image {
//                            anchors.fill: parent
//                            source: "qrc:/res/pictures/btn_style2.png"
//                            fillMode: Image.PreserveAspectFit
//                            horizontalAlignment: Image.AlignHCenter
//                            verticalAlignment: Image.AlignVCenter
//                            Text {
//                                text: qsTr("Ok")
//                                anchors.fill: parent
//                                color: "black"
//                                font.pixelSize: height * 0.8
//                                font.family: "Arial"
//                                font.weight: Font.Thin
//                                horizontalAlignment: Text.AlignHCenter
//                                verticalAlignment: Text.AlignVCenter
//                            }
//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: {
//                                    okClicked()
//                                }
//                            }
//                        }
//                    }

//                }
//            }
//        }
//    }
//}
