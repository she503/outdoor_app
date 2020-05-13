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
        height: root._level <= 1 ? root.height / 4 : root.height / 7
        width: parent.width
        property real id_num: model.id_num
        Rectangle {
            anchors.fill: parent
            color: item.focus ? "#191970" : "transparent"

            Image {
                id: img_background
                z:1
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
            root._level = account_manager.getCurrentUserLevel()
            if (root._level <= 1) {
                user_lit_model.append({"id_num": 0, "focus_source": "qrc:/res/ui/menu/home.png"})
                user_lit_model.append({"id_num": 1, "focus_source": "qrc:/res/ui/menu/clean.png"})
                user_lit_model.append({"id_num": 2, "focus_source": "qrc:/res/ui/menu/help.png"})
                user_lit_model.append({"id_num": 3, "focus_source": "qrc:/res/ui/menu/about.png"})
            } else {
                user_lit_model.append({"id_num": 0, "focus_source": "qrc:/res/ui/menu/home.png"})
                user_lit_model.append({"id_num": 4, "focus_source": "qrc:/res/ui/menu/user.png"})
                user_lit_model.append({"id_num": 1, "focus_source": "qrc:/res/ui/menu/clean.png"})
                user_lit_model.append({"id_num": 5, "focus_source": "qrc:/res/ui/menu/mapping.png"})
                user_lit_model.append({"id_num": 2, "focus_source": "qrc:/res/ui/menu/help.png"})
                user_lit_model.append({"id_num": 3, "focus_source": "qrc:/res/ui/menu/about.png"})
            }
        }
    }




}
