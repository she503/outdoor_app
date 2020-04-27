import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "CustomControl"

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    property Component fail_connect_page: FaildToConnectPage{
        onSuccessToConnect: {
            stack_view.replace(login_page)
        }
    }
    property Component welcome_page: WelcomePage {
        onTimeToClose: {
            if (!socket_manager.judgeIsConnected()) {
                stack_view.push(fail_connect_page)
            } else {
                stack_view.push(login_page)
            }
        }
    }
    property Component main_page: MainPage {}

    LoginPage {
        id: login_page
        visible: false
        width: root.width
        height: root.height
        onSuccessToLogin: {
            stack_view.push(main_page)
        }
    }
    StackView {
        id: stack_view
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
