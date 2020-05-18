import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import "homemade_components"
//todo
Rectangle {
     signal centerBtnPress()

    id: root
    color: "transparent"

    TLInfoDisplayPage {
        id: rect_info_display
        width: parent.width
        height: parent.height
        onSigCenterBtnClicked: {
            root.centerBtnPress()
        }
    }
}
