import QtQuick 2.9
import QtQuick.Controls 2.2
import "../map_task_manager"
Rectangle {
    id: root

    property real vehicle_width: vehicle_info_manager.getVehicleWidth()
    property real  vehicle_height: vehicle_info_manager.getVehicleHeight()

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
            ctx.lineJoin="round";
//            for(var i = 0; i < )
        }
        VehicleItem {
            id: vehicle
            width: vehicle_width
            height: vehicle_height
        }
    }

}
