import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    color: "transparent"
    property real rate: Math.min(width, height) / 400

    Rectangle {
        id: rect_up
        width: parent.width
        height: parent.height / 2
        GridLayout {
            id: grid_layout
            rows: 2
            columns: 3
            rowSpacing: 70 * rate
            columnSpacing: 125 * rate

            Image {
                id: pic_battery
                source: "qrc:/res/pictures/battery.png"
                Layout.row: 0
                Layout.column: 0
                sourceSize {
                    width: root.width / 8
                    height: root.height / 8
                }
            }
            Image {
                id: pic_water
                source: "qrc:/res/pictures/water.png"
                Layout.row: 0
                Layout.column: 1
                sourceSize {
                    width: root.width / 8
                    height: root.height / 8
                }
            }
            Image {
                id: pic_drive_mode
                source: "qrc:/res/pictures/button.png"
                Layout.row: 0
                Layout.column: 2
                sourceSize {
                    width: root.width / 8
                    height: root.height / 8
                }
            }
            Image {
                id: pic_car_gear
                source: "qrc:/res/pictures/gear-shift.png"
                Layout.row: 1
                Layout.column: 0
                sourceSize {
                    width: root.width / 8
                    height: root.height / 8
                }
            }
            Image {
                id: pic_car_speed
                source: "qrc:/res/pictures/speed.png"
                Layout.row: 1
                Layout.column: 1
                sourceSize {
                    width: root.width / 8
                    height: root.height / 8
                }
            }
            Image {
                id: pic_brush_state
                source: "qrc:/res/pictures/button.png"
                Layout.row: 1
                Layout.column: 2
                sourceSize {
                    width: root.width / 8
                    height: root.height / 8
                }
            }
        }
    }

    Rectangle {
        id: rect_down
        width: parent.width
        height: parent.height / 2
        anchors.top: rect_up.bottom
        color: "lightblue"

        Image {
            anchors.centerIn: parent
//            source: "qrc:/res/pictures/power_on.png"
            sourceSize {
                width: 50 * root.rate
                height: 50 * root.rate
            }
        }
    }

}
