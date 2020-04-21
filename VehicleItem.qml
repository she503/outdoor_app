import QtQuick 2.0
// do not update this file, especially the param
Rectangle {
    id: root
    z: 0
    height: 240
    width: height * 3
    property real border_ratio: 0.05
    color: "transparent"
    antialiasing: true
    transformOrigin: Item.Center

    Rectangle{
        id: rect
        width: parent.width * 0.3
        height: parent.height
        anchors.left: parent.left
        color: "transparent"
    }
    Rectangle{
        id: car
        width: parent.width * 0.7
        height: parent.height
        anchors.left: rect.right
        color: "transparent"
        Image {
            smooth: true
            anchors.fill: parent
            source: "qrc:/res/pictures/car.png"
        }
//        Canvas {
//            id: canvas
//            anchors.fill: parent
//            z: 1

//            onPaint: {
//                var ctx = getContext("2d")
//                ctx.clearRect(0, 0, width, height)
//                ctx.save()

//                ctx.scale(width * 1.0 / 480.0, height * 1.0 / 240.0)
//                ctx.translate(240 , 120);

//                var line_width = 240 * border_ratio
//                var line_width_half = line_width * 0.5
//                ctx.lineWidth = line_width

//                ctx.strokeStyle = "#FFFF00"
//                ctx.fillStyle = Qt.rgba(0, 255, 0, 0.5)
//                ctx.beginPath()
//                ctx.moveTo(-240 + line_width_half, -120 + line_width_half)
//                ctx.lineTo(240 - line_width_half, -120 + line_width_half)
//                ctx.lineTo(240 - line_width_half, 120 - line_width_half)
//                ctx.lineTo(-240 + line_width_half, 120 - line_width_half)
//                ctx.closePath()
//                ctx.fill()
//                ctx.stroke()
//                ctx.closePath()

//                ctx.strokeStyle = "#FF0000"

//                ctx.beginPath()
//                ctx.moveTo(-120, 0)
//                ctx.lineTo(240, -120)
//                ctx.stroke()
//                ctx.closePath()

//                ctx.beginPath()
//                ctx.moveTo(-120, 0)
//                ctx.lineTo(240, 120)
//                ctx.stroke()
//                ctx.closePath()

//                ctx.fillStyle = "#FFFF00"
//                ctx.strokeStyle = "#FFFF00"
//                ctx.beginPath();
//                ctx.arc(-120, 0, 20, 0, 2 * Math.PI);
//                ctx.fill()
//                ctx.stroke()
//                ctx.closePath();

//                ctx.restore()
//            }
//        }


    }
}
