import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: root
    color: "transparent"
    clip: true

    MappingMenu {
        id: mapping_menu
        onSigChooseBtnNumber: {
            if (num === 1 || num === 2) {
                stack.tlReplace(map_message)
            }
        }

    }

    MappingStartPage {
        id: map_message

    }

    Image {
        anchors.fill: parent
        source: "qrc:/res/ui/background/small_background.png"
    }

    StackView {
        id: stack
        width: parent.width * 0.9
        height:  parent.height * 0.9
        anchors.centerIn: parent
        initialItem: mapping_menu
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
