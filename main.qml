import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    property bool has_error: false
    property Component main_page: MainPage {
        onBackToHomePage: {
            stack_view.replace(main_page)
        }
    }

    property Component login_page: LoginPage {
        width: root.width
        height: root.height
        onSuccessToLogin: {
            stack_view.replace(main_page)
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (has_error) {
                has_error = false
            } else {
                has_error = true
            }
        }
    }
    StackView {
        id: stack_view
        anchors.fill: parent
        initialItem: login_page

        replaceEnter: Transition {

        }
        replaceExit: Transition {

        }
    }

}
