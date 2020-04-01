import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    property Component main_page: MainPage {
    }

    property Component login_page: LoginPage {
        width: root.width
        height: root.height
        onSuccessToLogin: {
            stack_view_main.replace(main_page)
        }
    }

    StackView {
        id: stack_view_main
        anchors.fill: parent
        initialItem: login_page

        replaceEnter: Transition {

        }
        replaceExit: Transition {

        }
    }

}
