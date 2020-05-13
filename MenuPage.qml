import QtQuick 2.0
import QtQuick.Controls 2.2

ListView {
    id: root
    signal mainPageChanged(var current_index)

    property int _level: 3//account_manager.getCurrentUserLevel()
    property bool _monitor_error: false

    spacing: height * 0.002
    currentIndex: 0
    highlight: Rectangle {color: "transparent"}
    clip: true
    highlightFollowsCurrentItem: false
    delegate: ItemDelegate {
        id: item
        height: root._level <= 1 ? root.height / 4 : root.height / 6
        width: parent.width
        property real id_num: model.id_num
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            Image {
                id: img_background
                source: model.focus_source
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
//            root._level = account_manager.getCurrentUserLevel()
            if (root._level <= 1) {
                user_lit_model.append({"id_num": 0, "focus_source": "qrc:/res/ui/menu/home.png"})
                user_lit_model.append({"id_num": 1, "focus_source": "qrc:/res/ui/menu/task.png"})
                user_lit_model.append({"id_num": 2, "focus_source": "qrc:/res/ui/menu/help.png"})
                user_lit_model.append({"id_num": 3, "focus_source": "qrc:/res/ui/menu/about.png"})
            } else {
                user_lit_model.append({"id_num": 0, "focus_source": "qrc:/res/ui/menu/home.png"})
                user_lit_model.append({"id_num": 4, "focus_source": "qrc:/res/ui/menu/user.png"})
                user_lit_model.append({"id_num": 1, "focus_source": "qrc:/res/ui/menu/task.png"})
                user_lit_model.append({"id_num": 5, "focus_source": "qrc:/res/ui/menu/mapping.png"})
                user_lit_model.append({"id_num": 2, "focus_source": "qrc:/res/ui/menu/help.png"})
                user_lit_model.append({"id_num": 3, "focus_source": "qrc:/res/ui/menu/about.png"})
            }
        }
    }
}
