import QtQuick 2.0
import QtQuick.Controls 2.2

ListView {
    signal mainPageChanged(var current_index)


    id: list_view
    //            anchors.fill: parent
    spacing: height * 0.002
    currentIndex: 0
    highlight: Rectangle {color: "transparent"}
    clip: true
    highlightFollowsCurrentItem: false
    delegate: ItemDelegate {
        id: item
        height: list_view.height / 5
        width: height * 2.5
        property real id_num: model.id_num
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            Image {
                id: img_background
                source: model.focus_source
                opacity: list_view.currentIndex == item.id_num ? 1 : 0.3
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
            }
        }

        onClicked: {
            list_view.currentIndex = index
            list_view.mainPageChanged(list_view.currentIndex)
        }
    }
    model: ListModel {
        ListElement {
            id_num: 0
            focus_source: "qrc:/res/pictures/home.png"
        }
        ListElement {
            id_num: 1
            focus_source: "qrc:/res/pictures/user.png"
        }
        ListElement {
            id_num: 2
            focus_source: "qrc:/res/pictures/task.png"
        }
        ListElement {
            id_num: 3
            focus_source: "qrc:/res/pictures/help.png"
        }
        ListElement {
            id_num: 4
            focus_source: "qrc:/res/pictures/about.png"
        }
    }
}
