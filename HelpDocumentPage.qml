import QtQuick 2.0
import QtQuick.Controls 2.2
import QtWebView 1.0
//import QtWebkit 3.0

Rectangle {
    id: root
    color: "transparent"
//    Timer {
//        running: true
//        repeat: true
//        interval: 100
//        onTriggered: {
//            console.log(webVie1.loadProgress)
//            webVie1.visible = true
//        }
//    }

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
            color: "white"
            WebView {
                id: webVie1
                visible: false
                anchors.fill: parent
//                url: "qrc:/res/html/test.html"
                url: "file:///android_asset/test.html"
                onLoadProgressChanged: {
                    if (loadProgress == 100) {
                        busy.running = false
                        webVie1.visible = true
                    } else {
                        busy.running = true
                    }
                }

            }
            BusyIndicator{
                id: busy
                running: false
                width: parent.height * 0.2
                height: width
                anchors.centerIn: parent
                Timer{
                    running: busy.running
                    onTriggered: {
                        if (webVie1.loadProgress == 100) {
                            busy.running = false
                            webVie1.visible = true
                        }
                    }
                }
            }
        }

    }
}
