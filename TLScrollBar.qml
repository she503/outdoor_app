import QtQuick 2.0
import QtQuick.Controls 2.2
ScrollBar {
    id: vbar
    hoverEnabled: true
    active: hovered || pressed
    orientation: Qt.Vertical
    size: 0.1
    policy: ScrollBar.AsNeeded
    contentItem: Rectangle {
        implicitWidth: 4
        implicitHeight: 2
        radius: width / 2
        color: vbar.pressed ? "#ffffaa" : "lightyellow"
    }
}
