import QtQuick 2.9
import QtQuick.Controls 2.2
import "../homemade_components"

Rectangle {
    id: root
    color: "transparent"

    property var p_accounts_info: {}
    property int p_admin_num: 0

    function initAllAccountInfo() {
        root.p_admin_num = 0
        root.p_accounts_info = account_manager.getAllAccountsInfo()
        user_list_model.clear()

        var nomal_level = qsTr("nomal_level")
        var admin_level = qsTr("admin_level")

        for (var key in root.p_accounts_info) {
            if (root.p_accounts_info[key] === 0) {
                console.info("error user level")
            } else if (root.p_accounts_info[key] === 1) {
                user_list_model.append({ "user_name": key, "level": nomal_level, "user_level": root.p_accounts_info[key]})
            } else if (root.p_accounts_info[key] === 2) {
                user_list_model.append({"user_name": key, "level": admin_level, "user_level": root.p_accounts_info[key]})
                ++root.p_admin_num;
                ++btns.p_admin_num;
            }
        }
        list_view_user.currentIndex = -1
        btns.p_is_choose_account = false
    }

    Rectangle {
        id: bg
        height: parent.width > parent.height ? parent.height * 0.9 : parent.width * 0.9 * 0.787
        width: parent.width > parent.height ? parent.height * 0.9 * 1.27 : parent.width * 0.9
        anchors.centerIn: parent
        color: "transparent"
        visible: true
        Image {
            id: im
            anchors.fill: parent
            source: "qrc:/res/pictures/background_glow1.png"
        }
        Rectangle {
            width: parent.width * 0.88
            height: parent.height * 0.85
            anchors.centerIn: parent
            color: Qt.rgba(255, 255, 255, 0.6)
            Rectangle {
                id: rect_top
                width: parent.width
                height: parent.height * 0.16
                color: "transparent"
                Rectangle {
                    width: parent.width * 0.3
                    height: parent.height
                    color: "transparent"
                    anchors.left: parent.left
                    Text {
                        text: qsTr("user lists:") + ":"
                        font.pixelSize: parent.height * 0.4
                        color: "blue"
                        font.bold: true
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            leftMargin: parent.height * 0.2
                        }
                    }
                }

                AddUpdateDeleteBtn {
                    id: btns
                    width: parent.width * 0.7
                    height: parent.height
                    anchors.right: parent.right

                }

                Rectangle {
                    width: parent.width * 0.93
                    height: 0.5
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(0, 0, 0, 0.5)
                }
            }

            Rectangle {
                id: rect_list
                width: parent.width * 0.8
                height: parent.height * 0.8
                clip: true
                color: "transparent"
                anchors {
                    top: rect_top.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                ListView {
                    id: list_view_user
                    width: parent.width
                    height: parent.height
                    currentIndex: -1
                    spacing: height * 0.01

                    anchors {
                        top: parent.top
                        left: parent.left
                        topMargin: parent.height * 0.02
                        leftMargin: parent.height * 0.015
                    }

                    delegate: ItemDelegate {
                        id: item_de
                        width: list_view_user.width
                        height: list_view_user.height * 0.14
                        Rectangle {
                            id: rect_circle
                            width: parent.height * 0.6
                            height: width
                            radius: height / 2
                            border.width: 1
                            border.color: "#87CEFA"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                id: rect_center
                                anchors.centerIn: rect_circle
                                width: parent.width * 0.5
                                height: width
                                radius: width / 2
                                color: "#00BFFF"
                                visible: item_de.focus
                            }
                        }
                        Text {
                            id: text_username
                            anchors {
                                left: rect_circle.right
                                leftMargin: item_de.height * 0.2
                                verticalCenter: item_de.verticalCenter
                            }
                            text: model.user_name
                            font.pixelSize: item_de.height * 0.8
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                        }
                        Text {
                            id: text_level
                            anchors {
                                left: parent.horizontalCenter
                                verticalCenter: item_de.verticalCenter
                            }
                            text: model.level
                            font.pixelSize: item_de.height * 0.8
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: "black" //: "white"
                            property int user_level: model.user_level
                        }
                        Rectangle {
                            width: parent.width
                            height: 0.5
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width * 0.068
                            color: Qt.rgba(0, 0, 0, 0.1)
                        }
                        onClicked: {
                            list_view_user.currentIndex = index
                            btns.p_checked_user_level = text_level.user_level
                            btns.p_checked_user_name = model.user_name
                            btns.p_is_choose_account = true
                        }
                    }
                    model: ListModel {
                        id: user_list_model
                        Component.onCompleted: {
                            root.initAllAccountInfo()
                        }
                    }

                    ScrollBar.vertical: TLScrollBar { visible: user_list_model.count > 5 }
                }
            }
        }
    }

    Connections {
        target: account_manager
        onEmitDeleteAccountRst: {
            if (status === 1) {
                if (root.p_checked_user_level === 2) {
                    --root.p_admin_num
                    --btns.p_admin_num
                }
            }
        }
        onEmitAllAccountInfo: {
            root.initAllAccountInfo()
        }
    }

    TLMessageBox {
        id: message_account
        height: parent.height * 0.5
        width: height * 1.5
        x: (root.width - width) / 2
        y: (root.height - height) / 2
    }
}
