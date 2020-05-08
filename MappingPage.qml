import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: root
    color: "transparent"
    property Component choose_page: ChooseIndoorOutdoor{
        onSigChooseSuccess: {

        }
    }

    Image {
        anchors.fill: parent
        source: "qrc:/res/pictures/background_glow1.png"
    }
    StackView {
        id: stack
        anchors.fill: parent
        initialItem: choose_page
        function tlReplace(item) {
            if (stack.currentItem === item) {
                return;
            } else {
                replace(item)
            }
        }
        replaceEnter: Transition {

        }
        replaceExit: Transition {

        }
    }


}
