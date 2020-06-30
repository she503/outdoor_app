import QtQuick 2.0
import QtQuick.Controls 2.2
Rectangle {
    id: root

    color: "transparent"
    signal sigBackBtnPress()
    signal sigWorkDown()

    Column {
        property real btn_spacing: parent.width * 0.03
        spacing: btn_spacing / 6
        width: parent.width
        height: parent.height
        Image {
            id: btn_back
            source: "qrc:/res/ui/task/home.png"
            width: parent.width
            height: (parent.height -  parent.btn_spacing)/ 4
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.sigBackBtnPress()
                }
            }
        }
        Image {
            id: btn_stop
            width: parent.width
            height: (parent.height -  parent.btn_spacing)/ 4
            source: _is_pause ? "qrc:/res/ui/task/btn_start.png" :
                                "qrc:/res/ui/task/btn_pause.png"
            fillMode: Image.PreserveAspectFit
            property bool _is_pause: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    map_task_manager.setPauseTaskCommond(!btn_stop._is_pause)
                }
            }
            Connections {
                target: map_task_manager
                onEmitPauseTaskRst: {
                    if (status === 0 ) {

                    } else if (status === 1 ) {
                        btn_stop._is_pause = !is_pause
                    }
                }
            }
        }
        Image {
            id: btn_ending
            width: parent.width
            height: (parent.height -  parent.btn_spacing)/ 4
            source: "qrc:/res/ui/task/btn_stop_task.png"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.sigWorkDown()
                }
            }
        }

        Rectangle {
            width: height
            height: parent.width * 0.85
            color: "#4169E1"
            radius: height
            border.color: "#D3D3D3"
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                id: btn_clean_work
                width: parent.height * 0.8
                height: parent.height* 0.8
                anchors.centerIn: parent
                source: "qrc:/res/pictures/clean_on.png"

                fillMode: Image.PreserveAspectFit
                property bool clean_work: true
                property bool is_first_init: true

            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    map_task_manager.setEnableCleanWork(!btn_clean_work.clean_work)
                }
            }
            Connections{
                target: socket_manager
                onEmitEnableCleanWorkRst: {
                    btn_clean_work.clean_work = flag
                    btn_clean_work.source = btn_clean_work.clean_work ? "qrc:/res/pictures/clean_on.png":
                                                                        "qrc:/res/pictures/clean_off.png"
                }
            }
//            Connections {
//                target: ros_message_manager
//                onUpdateCleaningAgencyInfo: {

//                        btn_clean_work.source = cleaning_agency_state == 1 ? "qrc:/res/pictures/clean_on.png":
//                                                                             "qrc:/res/pictures/clean_off.png"
//                }
//            }
        }

    }
}
