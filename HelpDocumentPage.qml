import QtQuick 2.0
import QtQuick.Controls 2.2
import QtWebView 1.0
//import QtWebkit 3.0

Rectangle {
    id: root
    color: "transparent"
    Rectangle {
        id: rec_glow_background
        anchors.fill: parent
        anchors.margins: 5 * rate
        color: "transparent"
        Image {
            anchors.fill: parent
            source: "qrc:/res/pictures/background_glow1.png"
        }
        Rectangle {
            width: parent.width * 0.9
            height: parent.height * 0.88
            anchors.centerIn: parent
            color: "white"
            WebView {
                id: webVie1
                anchors.fill: parent
                url: {
                    if (account_manager.isAndroid) {
                        "qrc:/res/html/test.html"
//                        "file:///android_asset/test.html"
                    } else {
                        "qrc:/res/html/test.html"
                    }
                }
                onLoadProgressChanged: {
                    console.info(loadProgress)
                }
            }
        }
    }
}
