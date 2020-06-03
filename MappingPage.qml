import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: root
    color: "transparent"
    clip: true

//    property real choose_menu_num: -1


    Connections {
        target: socket_manager
        onEmitStartMappingSuccess: {
            stack.tlReplace(map_message)
        }
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


        MappingStartPage {
            id: map_message
            width: parent.width
            height: parent.height
            visible: false
            onSigQuite: {
                stack.tlReplace(mapping_menu)
            }

        }
        MappingMenu {
            id: mapping_menu
            width: parent.width
            height: parent.height
            onSigChooseBtnNumber: {
    //            root.choose_menu_num = num

            }

        }

    }


}
