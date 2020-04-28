import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    visible: true
    color: "transparent"

    property string bord_color: "#87CEFA"
    property string center_color: "#00BFFF"
    property real checked_num: -1
    onChecked_numChanged: {
        if (checked_num === -1) {
            radio_nomal.state = "nomal_unchecked"
            radio_admin.state = "admin_unchecked"
        }
    }

    Rectangle {
        id: radio_admin
        width: parent.width * 0.5
        height: parent.height
        color: "transparent"
        Rectangle {
                id: rect_radio_btn
                width: parent.width * 0.2
                height: width
                radius: height / 2
                border.width: 1
                border.color: root.bord_color
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: text_admin.left
                    rightMargin: parent.width * 0.1
                }
                color: "transparent"
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    color: root.bord_color
                    samples: 10
                }

                Rectangle {
                    id: admin_center
                    smooth: true
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: width
                    radius: width / 2
                    color: center_color
                    visible: false
                }
            }

        Text {
            id: text_admin
            width: parent.width * 0.4
            height: parent.height
            font.pixelSize: height
            color: "#87CEFA"
            anchors{
                right: parent.right
                leftMargin: parent.width * 0.1
            }
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            text: qsTr("admin")
        }
        anchors.left: parent.left
        state: "admin_state"
        states: [
            State{
                name: "admin_checked"
                PropertyChanges{
                    target: admin_center; visible: true
                }
                PropertyChanges{
                    target: nomal_center; visible: false
                }
                PropertyChanges{
                    target: root; checked_num: 2
                }
            },
            State{
                name: "admin_unchecked"
                PropertyChanges{
                    target: admin_center; visible: false
                }
                PropertyChanges{
                    target: nomal_center; visible: true
                }
                PropertyChanges{
                    target: root; checked_num: 1
                }
            }
        ]
        MouseArea{
            id: mouseArea1
            anchors.fill: parent
            onClicked: {
                radio_admin.state = "admin_checked"
                radio_nomal.state = "nomal_unchecked"
            }
        }
    }

    Rectangle {
        id: radio_nomal
        width: parent.width * 0.5
        height: parent.height
        color: "transparent"
        Rectangle {
            id: rect_radio_nomal
                width: parent.width * 0.2
                height: width
                radius: height / 2
                border.width: 1
                border.color: root.bord_color
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    color: root.bord_color
                    samples: 10
                }

                Rectangle {
                    id: nomal_center
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: width
                    radius: width / 2
                    color: center_color
                    visible: false
                }
            }

        Text {
            width: parent.width * 0.7
            height: parent.height
            font.pixelSize: height
            color: "#87CEFA"
            anchors{
                left: rect_radio_nomal.right
                leftMargin: parent.width * 0.1
            }
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            text: qsTr("nomal")
        }
        anchors{
            top: parent.top
        left: radio_admin.right
        leftMargin: parent.width * 0.1
        }
        state: "nomal_state"
        states: [
            State{
                name: "nomal_checked"
                PropertyChanges{
                    target: nomal_center; visible: true
                }
                PropertyChanges{
                    target: admin_center; enabled: false;
                }
                PropertyChanges{
                    target: root; checked_num: 1
                }
            },
            State{
                name: "nomal_unchecked"
                PropertyChanges{
                    target: nomal_center; visible: false
                }
                PropertyChanges{
                    target: admin_center; enabled: true;
                }
                PropertyChanges{
                    target: root; checked_num: 2
                }
            }
        ]
        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            onClicked: {
                radio_nomal.state = "nomal_checked"
                radio_admin.state = "admin_unchecked"
            }
        }
    }

}
