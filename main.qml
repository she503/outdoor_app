﻿import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "customControl"

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    property bool connect_to_server: false

    Component.onCompleted: {
        connect_to_server = socket_manager.connectToServer()
    }

    property Component fail_connect_page: FaildToConnectPage{
        onSuccessToConnect: {
            stack_view.replace(login_page)
        }
    }

    property Component welcome_page: WelcomePage {
        onFinishAnimation: {
            if (!connect_to_server) {
                stack_view.replace(fail_connect_page)
            } else {
                stack_view.replace(login_page)
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
            stack_view.replace(main_page)
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
