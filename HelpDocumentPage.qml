import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root

    Image {
        id: name
        width: parent.width
        height: parent.height
        source: "qrc:/res/pictures/document.png"
        fillMode: Image.PreserveAspectFit
    }
}
