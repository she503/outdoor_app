import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    property var v_user_level: ""
    property var v_user_name: ""
    property Component main_page: MainPage { }
    property Component login_page: LoginPage {
        width: root.width
        height: root.height
        onSendAccountInfo: {
            root.v_user_level = user_level
            root.v_user_name = user_name
            stack_view.push(main_page)
        }
    }

    StackView {
        id: stack_view
        anchors.fill: parent
        initialItem: login_page
    }

}
