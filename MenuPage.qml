import QtQuick 2.0
import QtQuick.Controls 2.2

ListView {
    id: root
    signal mainPageChanged(var current_index)

    property int _level: account_manager.getCurrentUserLevel()
    property bool _monitor_error: false

    spacing: height / 7 / 7
    currentIndex: 0
    highlight: Rectangle {color: "transparent"}
    clip: true
    highlightFollowsCurrentItem: true
    delegate: ItemDelegate {
        id: item
        z:1
        height: root._level <= 1 ? root.height / 5 : root.height / 6
        width: parent.width
        property real id_num: model.id_num
        Rectangle {
            anchors.fill: parent
            //color: item.focus ? "#191970" : "transparent"
            color: "transparent"

            Image {
                id: img_background
                z:1
                source:item.focus ? model.focus_source: model.no_focus_source
                anchors.fill: parent
                opacity: item.focus ? 1: 0.3
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
            }
        }

        onClicked: {

            if (root._monitor_error && item.id_num === 1) {
//                index = list_view.currentIndex
            } else {
                root.currentIndex = index
                root.mainPageChanged(model.id_num)
            }
        }
    }
    model: ListModel {
        id: user_lit_model
        Component.onCompleted: {
            root._level = account_manager.getCurrentUserLevel()
            if (root._level <= 1) {
                user_lit_model.append({"id_num": 0, "no_focus_source": "qrc:/res/pictures/home.png", "focus_source": "qrc:/res/pictures/home.png"})
                user_lit_model.append({"id_num": 1, "no_focus_source": "qrc:/res/pictures/task.png", "focus_source": "qrc:/res/pictures/task.png"})
                user_lit_model.append({"id_num": 2, "no_focus_source": "qrc:/res/pictures/help.png", "focus_source": "qrc:/res/pictures/help.png"})
                user_lit_model.append({"id_num": 3, "no_focus_source": "qrc:/res/pictures/about.png", "focus_source": "qrc:/res/pictures/about.png"})
            } else {
                user_lit_model.append({"id_num": 0, "no_focus_source": "qrc:/res/pictures/home.png", "focus_source": "qrc:/res/pictures/home.png"})
                user_lit_model.append({"id_num": 4, "no_focus_source": "qrc:/res/pictures/user.png", "focus_source": "qrc:/res/pictures/user.png"})
                user_lit_model.append({"id_num": 1, "no_focus_source": "qrc:/res/pictures/task.png", "focus_source": "qrc:/res/pictures/task.png"})
                user_lit_model.append({"id_num": 2, "no_focus_source": "qrc:/res/pictures/help.png", "focus_source": "qrc:/res/pictures/help.png"})
                user_lit_model.append({"id_num": 3, "no_focus_source": "qrc:/res/pictures/about.png", "focus_source": "qrc:/res/pictures/about.png"})
                //user_lit_model.append({"id_num": 5, "no_focus_source": "qrc:/res/ui/menu/mapping_off.png", "focus_source": "qrc:/res/ui/menu/mapping_on.png"})
            }
        }
    }
}
