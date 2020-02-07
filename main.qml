import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 640
    height: 480

    property real side: Math.min(width, height) / 480
    property bool is_link: false

    onIs_linkChanged: {
        if (is_link){
            stack.replace(main_page)
        } else {
        }
    }
    StackView {
        id: stack
        anchors.fill: parent
        initialItem: login_page
    }
    LoginPage {
        id: login_page
    }
    MainPage {
        id: main_page
        visible: false
    }
}
