import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: root
    color: "transparent"
    clip: true
    ChooseIndoorOutdoor{
        id: choose_page
        onSigChooseSuccess: {
            stack.tlReplace(mapping_start)
        }
    }
    MappingStartPage {
        id: mapping_start
        clip: true
    }

    Image {
        anchors.fill: parent
        source: "qrc:/res/ui/background/map.png"
    }
//    Image {
//        anchors.fill: parent
//        source: "qrc:/res/pictures/background_glow1.png"
//    }
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
