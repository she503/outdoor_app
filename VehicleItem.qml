import QtQuick 2.0
// do not update this file, especially the param
Rectangle {
    id: root
    height: 240
    width: rect_width
    property real border_ratio: 0.05
    color: "transparent"
    antialiasing: true
    transformOrigin: Item.Center
    property bool flag: true
    property var max_x_more_big: max_x > -min_x
    property var min_x: vehicle_info_manager.getVehicleMinX()
    property var min_y: vehicle_info_manager.getVehicleMinY()
    property var max_x: vehicle_info_manager.getVehicleMaxX()
    property var max_y: vehicle_info_manager.getVehicleMaxY()
    property var x_rate_y:vehicle_info_manager.getVehicleWidth() / vehicle_info_manager.getVehicleHeight()
    property var rect_width: max_x_more_big ?
                                 root.height / (max_y - min_y) * (max_x) * 2:
                                 root.height / (max_y - min_y) * (-min_x) * 2

//    Connections {
//        target: status_manager
//        onWorkStatusUpdate: {
//         canvas.requestPaint()
//        }
//    }

    Canvas {
        id: canvas
        width: parent.width
        height: parent.height
        onPaint: {
            var ctx = getContext("2d")
//            ctx.clearRect(0, 0, width, height)

            var pix_scale = root.height / vehicle_info_manager.getVehicleHeight()
            var min_x_pix = min_x * pix_scale
            var min_y_pix = min_y * pix_scale
            var max_x_pix = max_x * pix_scale
            var max_y_pix = max_y * pix_scale

            if (root.flag) {
                if(!root.max_x_more_big) {
                    ctx.translate( -min_x_pix, max_y_pix);
                } else {
                    ctx.translate( max_x_pix, max_y_pix);
                }
                root.flag = false
            }

            var line_width = root.height * root.border_ratio
            var line_width_half = line_width * 0.5

            ctx.save()
            ctx.fillStyle = Qt.rgba(0, 255, 0, 0.5)
            ctx.beginPath()
            ctx.moveTo(min_x_pix , max_y_pix )
            ctx.lineTo(max_x_pix , max_y_pix )
            ctx.lineTo(max_x_pix , min_y_pix )
            ctx.lineTo(min_x_pix , min_y_pix )
            ctx.closePath()
            ctx.fill()
            ctx.restore()

            ctx.save()
            ctx.strokeStyle = "#FFFF00"
            ctx.lineWidth = line_width * 0.2
            ctx.moveTo(min_x_pix , max_y_pix )
            ctx.lineTo(max_x_pix , max_y_pix )
            ctx.lineTo(max_x_pix , min_y_pix )
            ctx.lineTo(min_x_pix , min_y_pix )
            ctx.stroke()
            ctx.restore()

            ctx.save()
            ctx.strokeStyle = "#FF0000"
            ctx.beginPath();
            ctx.moveTo(0 , 0 )
            ctx.lineTo(max_x_pix , max_y_pix )
            ctx.stroke()
            ctx.restore()

            ctx.save()
            ctx.strokeStyle = "#FF0000"
            ctx.beginPath();
            ctx.moveTo(0 , 0 )
            ctx.lineTo(max_x_pix , min_y_pix )
            ctx.stroke()
            ctx.restore()

            ctx.save()
            ctx.fillStyle = "#FFFF00"
            ctx.strokeStyle = "#FFFF00"
            ctx.beginPath();
            ctx.arc(0, 0, max_y_pix / 4, 0, 2 * Math.PI);
            ctx.fill()
            ctx.stroke()
            ctx.restore()

        }
    }
}

