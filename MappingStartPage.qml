import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    radius: 3
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        color: "white"
        samples: 20
    }
    VehicleItem {

    }

    Connections {
        target: mapping_manager
        onEmitmappingProgressInfo: {

        }
    }
}
