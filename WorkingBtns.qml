import QtQuick 2.0
import QtQuick.Controls 2.2
Rectangle {
    id: rect_btns
    width: parent.width
    height: parent.height * 0.1
    color: "transparent"
    Row {
        property real btn_spacing: parent.width * 0.03
        spacing: btn_spacing / 6
        height: parent.height
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            id: btn_back
            source: "qrc:/res/pictures/BUTTON-HOME.png"
            width: (parent.width -  parent.btn_spacing)/ 4
            height: parent.height
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
            width: (parent.width -  parent.btn_spacing)/ 4
            height: parent.height
            source: _is_pause ? "qrc:/res/pictures/BUTTON-START.png" :
                                "qrc:/res/pictures/BUTTON-PAUSE.png"
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
                    pause_stop_message.x = (parent.parent.parent.parent.width - width ) / 2
                    pause_stop_message.y =  (parent.parent.parent.parent.height - height ) / 2
                    y: (parent.parent.parent.parent.height - height ) / 2
                    if (status === 0 ) {
                        if (!btn_stop._is_pause) {
                            pause_stop_message.dia_title = qsTr("Error")
                            pause_stop_message.dia_content = qsTr("faild to start the task")
                            pause_stop_message.status = 0
                            pause_stop_message.open()
                        } else if (btn_stop._is_pause) {
                            pause_stop_message.dia_title = qsTr("Error")
                            pause_stop_message.dia_content = qsTr("faild to stop the task")
                            pause_stop_message.status = 0
                            pause_stop_message.open()
                        }
                    } else if (status === 1 ) {

                        btn_stop._is_pause = !is_pause
                    }
                }
            }
        }
        Image {
            id: btn_ending
            width:  (parent.width -  parent.btn_spacing)/ 4
            height: parent.height
            source: "qrc:/res/pictures/BUTTON-STOP.png"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    task_auto_achived.open()

                }
            }
        }

        Rectangle {
            width: height// (parent.width -  parent.btn_spacing)/ 4
            height: parent.height
            color: "#4169E1"
            radius: height
            border.color: "#D3D3D3"
            border.width: 2
            Image {
                id: btn_clean_work
                width: parent.height * 0.8
                height: parent.height* 0.8
                anchors.centerIn: parent
                source: "qrc:/res/pictures/clean_on.png"

                fillMode: Image.PreserveAspectFit
                property bool clean_work: true
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
        }
    }
}
