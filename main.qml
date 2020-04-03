import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "CustomControl"

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    property Component main_page: MainPage { }
    property Component welcome_page: WelcomePage {
        onTimeToClose: {
            if (socket_manager.judgeIsConnected()) {
                stack_view_main.replace(login_page)
            } else {
                stack_view_main.replace(login_page.connect_fail_view)
            }
        }
    }

    LoginPage {
        id: login_page
        visible: false
        width: root.width
        height: root.height
        onSuccessToLogin: {
            stack_view_main.replace(main_page)
        }
    }
    StackView {
        id: stack_view_main
        anchors.fill: parent
        initialItem: welcome_page

        replaceEnter: Transition {
            ScaleAnimator {
                target: login_page
                from: 0
                to: 1
                duration: 100
                running: running
            }
        }
        replaceExit: Transition {

        }
    }
}
