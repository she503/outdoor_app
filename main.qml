import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    property bool turn_task_page: false
    property Component task_settings_page: TaskSettingsPage { }
    property Component main_page: MainPage { }
    property Component login_page: LoginPage {
        width: root.width
        height: root.height
        onSuccessToLogin: {
            stack_view.replace(main_page)
        }
    }

    onTurn_task_pageChanged: {
        if (turn_task_page) {
            stack_view.replace(task_settings_page)
//            socket_manager.sendAllPower(true)
        } else {
            stack_view.replace(main_page)
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
