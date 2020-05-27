import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../map_task_manager"

Rectangle {
    id: root
    visible: true
    clip: true
    color: "white"

    property var trajectory_path:[]
    property bool is_frist: true

    property real map_width: 0
    property real map_height: 0
    property real map_rate: 1
    property real min_x: Number.POSITIVE_INFINITY
    property real min_y: Number.POSITIVE_INFINITY

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        color: "white"
        samples: 20

    }


//    function changeCoordinate(x, y) {
//        return [20 * (x - min_x), 20 * (y - min_y)]
//    }

    Connections {
        target: mapping_manager
        onEmitmappingProgressInfo: {

        }
        onEmitTrajectory: {
            trajectory_path = trajectory
            canvas_background.requestPaint()
        }
    }
    MappingMessage {
        id: mapping_message
        width: parent.width
        height: parent.height* 0.1

        anchors {
            left: parent.left
            top: parent.top
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: "white"  }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Rectangle {
        id: map
        width: parent.width
        height: parent.height * 0.8
        color: "transparent"

        Canvas {
            id: canvas_background
            width: parent.width //map_width * map_rate
            height: parent.height //map_height * map_rate

            function drawTrajectory(ctx, trajectory) {

                if (trajectory_path.length <= 0) {
                    return
                }

                ctx.strokeStyle = "#00ff00"
                ctx.fillStyle = "#00ff00"
                for (var i = 0; i < trajectory.length; ++i) {
                    vehicle.rotation =  -trajectory[i][2]
                    vehicle.x = trajectory[i][0] * 10 - vehicle.width / 2 + canvas_background.width / 2
                    vehicle.y = trajectory[i][1] * 10 - vehicle.height / 2 + canvas_background.height / 2
                    map.x = (map.width / 2 - vehicle.x + vehicle.width / 2) * (map.scale)
                    map.y = (map.height / 2 - vehicle.y + vehicle.height / 2) * (map.scale)
                    ctx.save()
                    ctx.beginPath()
                    ctx.translate(canvas_background.width / 2, canvas_background.height / 2)
                    if (trajectory[i][1] * 10 > canvas_background.height / 2) {
                        canvas_background.height +=100
                        map.scale -= map.scale * 0.9
                    }
                    if (trajectory[i][0] * 10 > canvas_background.width / 2) {
                        canvas_background.width +=100
                        map.scale -= map.scale * 0.9
                    }

                    ctx.arc(trajectory[i][0] * 10,trajectory[i][1] * 10,0.5,0,2*Math.PI)
                    ctx.fill()
                    ctx.stroke()
                    ctx.closePath()
                    ctx.restore()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                drawTrajectory(ctx, root.trajectory_path)
            }
            VehicleItem {
                id: vehicle
                z: 2
                visible: true
                opacity: 1
                width: 33//vehicle_info_manager.getVehicleWidth()
                height: 11//vehicle_info_manager.getVehicleHeight()
            }
        }
    }

    PinchArea{
        id:parea
        anchors.fill: parent
        pinch.maximumScale: 8
        pinch.minimumScale: 0.3
        pinch.dragAxis:Pinch.XAndYAxis
        pinch.target: map


        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: map
            onWheel: {
                if(wheel.angleDelta.y > 0 ){
                    map.scale += 0.2
                }else{
                    if (map.scale <= 0) {
                        return
                    }
                    map.scale -= 0.1
                }
            }
            onClicked: {
                var x = map.width / 2 - ( map.width / 2 - mouse.x + map.x) / map.scale
                var y = map.height / 2 - ( map.height / 2 - mouse.y + map.y) / map.scale

            }
            onPressed: {
            }

            onDoubleClicked: {

            }
        }
    }

    MappingStartBtns {
        id: rect_btns
        width: parent.width
        height: parent.height * 0.2
        anchors.top: map.bottom
    }


}



