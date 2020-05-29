import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root
    color: "transparent"
    property real pos_x: 1.0
    property real pos_y: 1.0
    property real pos_theta: 0.0
    property bool is_focus: false
    property var clicked_point: [Number.NEGATIVE_INFINITY,Number.NEGATIVE_INFINITY]
    rotation: pos_theta * 180 / Math.PI
    onYChanged: {
        if(clicked_point[0] >= x && clicked_point[0] <= x + width &&
                clicked_point[1] >= y && clicked_point[1] <= y + width ) {
            img.source = "qrc:/res/ui/task/qidian_choose.png"
            root.z = 20
            map_task_manager.setInitPos(pos_x,pos_y,pos_theta)
        } else {
            img.source = "qrc:/res/ui/task/qidian_no.png"
            root.z = 20
        }
    }


    Image {
        id: img
        anchors.fill: parent
        source: "qrc:/res/ui/task/qidian_no.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
