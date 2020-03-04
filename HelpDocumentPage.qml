import QtQuick 2.0
import QtQuick.Controls 2.2
import QtWebView 1.0

Rectangle {
    id: root

    WebView {
       id: webVie1;
       anchors.fill: parent;
       url: "qrc:/res/html/test.html";
    }
}
