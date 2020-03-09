import QtQuick 2.0
import QtQuick.Controls 2.2
import QtWebView 1.0
//import QtWebkit 3.0

Rectangle {
    id: root

    Rectangle {
        anchors.fill: parent
        WebView {
            id: webVie1
            anchors.fill: parent
            url: {
                if (account_manager.isAndroid) {
                    "qrc:/res/html/test.html"
//                    "file:///android_asset/test.html"
                } else {
                    "qrc:/res/html/test.html"
                }
            }
        }
    }

}
