import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    property Component main_page: MainPage { }

    LoginPage {
        id: login_page
        width: root.width
        height: root.height
        onSuccessToLogin: {
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
