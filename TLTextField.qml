import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

TextField {
    id: root

    property color checkedColor: "#2B99B9"
    property string pic_name: ""
    property real btn_radius: 0

    signal doubleClicked()

    placeholderText: qsTr("enter the context.")
    font.family: "Arial"
    font.pixelSize: height * 0.5
//    verticalAlignment: Text.AlignBottom
//    antialiasing: true
    leftPadding: font.pixelSize * 2

    background: Rectangle {
        radius: root.btn_radius
        color: root.enabled ? "transparent" : "#F4F6F6"
        border.color: root.enabled ? root.checkedColor : "#D5DBDB"
        border.width: 2
        opacity: root.enabled ? 1 : 0.7

        layer.enabled: root.hovered
        layer.effect: DropShadow {
            id: dropShadow
            transparentBorder: true
            color: root.checkedColor
            samples: 20
        }
        Image {
            id: pic_login
            asynchronous: true
            smooth: true
            width: (root.leftPadding > parent.height ? parent.height : root.leftPadding) * 0.5
            height: width
            anchors {
                left: parent.left
                leftMargin: parent.width * 0.04
                verticalCenter: parent.verticalCenter
            }
            source: root.pic_name
        }
    }

    cursorDelegate: Rectangle {
        width: 1
        height: root.contentHeight
        color: root.checkedColor
        visible: root.focus
        anchors.verticalCenter: parent.verticalCenter

        Timer {
            interval: 600
            repeat: true
            running: root.focus
            onRunningChanged: parent.visible = running
            onTriggered: parent.visible = !parent.visible
        }
    }

    onDoubleClicked: selectAll()

    onPressed: {
        _private.isCheckDoubleClickedEvent++

        if (! _checkDoubleClickedEventTimer.running)
            _checkDoubleClickedEventTimer.restart()
    }

    Item {
        id: _private
        property int isCheckDoubleClickedEvent: 0

        Timer {
            id: _checkDoubleClickedEventTimer
            running: false
            repeat: false
            interval: 500
            onTriggered: {
                if (_private.isCheckDoubleClickedEvent >= 2) {
                    /* Double Clicked Event */
                    root.doubleClicked()
                }

                stop()
                _private.isCheckDoubleClickedEvent = 0
            }
        }
    }
}
