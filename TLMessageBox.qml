import QtQuick 2.0
import QtQuick.Controls 2.2

Dialog {
    id: root
    width: 300
    height: 200

    property int dia_type: 0 // "success" : 1;     "faild" : 0
    property string dia_title: "error"
    property string dia_text: ""
    onDia_typeChanged: {
        if (dia_type === 0) {
            img_background.source = "qrc:/res/pictures/error_background.png"
        } else {
            img_background.source = "qrc:/res/pictures/success_background.png"
        }
    }

    background: Rectangle {
        color: "transparent"
        Image {
            id: img_background
            anchors.fill: parent
            source: "qrc:/res/pictures/error_background.png"
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
            color: root.dia_type === 0 ? "red" : "green"
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


        ScrollView {
            id: flick
            width: parent.width * 0.8
            height: parent.height * 0.7
            clip: true
            z: 10

            anchors{
                top: rect_split.bottom
                topMargin: parent.height * 0.02
                horizontalCenter: parent.horizontalCenter
            }
            TextArea {
                id: content
                text: "   " + root.dia_text//root.dia_content
                color: "black"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: width * 0.1
                wrapMode: TextEdit.Wrap
                focus: false
                readOnly: true
            }
            ScrollBar.vertical: TLScrollBar { visible: root.dia_text.length > 50 }
        }

        Rectangle {
            id: rect_btn
            width: parent.width * 0.8
            height: parent.height * 0.3
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            TLButton {
                id: btn_cancle
                width:parent.width * 0.35
                height: parent.height * 0.5
                anchors{
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin:  (parent.width - width) / 2
                }
                btn_text: qsTr("OK")
                onClicked: {
                    root.close()
                }
            }
        }
    }

}
