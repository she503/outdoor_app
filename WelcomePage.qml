import QtQuick 2.6
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
Page {
    id: page
    signal timeToClose()

    Rectangle {
        id: rec_pic
        anchors.fill: parent
        opacity: 0
        color: "transparent"
        Image {
            id: pic_logo
            width: parent.width * 0.7
            height: parent.height * 0.7
            anchors.centerIn: parent
            source: "qrc:/res/pictures/logo_2.png"
            asynchronous: false
            fillMode: Image.PreserveAspectFit
        }
    }

    NumberAnimation {
        target: rec_pic
        easing.amplitude: 1
        easing.type: Easing.InOutSine
        property: "opacity"
        from: 0
        to: 1
        duration: 1200
        running: true
        onStopped: {
             page.timeToClose()
        }
    }
}
