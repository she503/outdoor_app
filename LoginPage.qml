import QtQuick 2.9
import QtQuick.Controls 2.2
import "homemade_components"

Item{
    id: root

    signal successToLogin()

    property real _login_faild_time: 0
    property string _default_test_user: "root"

    Connections {
        target: account_manager
        onEmitLoginRst: {
            if (status === 1) {
                successToLogin()
            } else if (status == 0) {
                error_message_box.txt_color = "red"
                error_message_box.txt_context = qsTr("Error username or password, Please check it agin.")
                error_message_box.open()
            }
        }
    }

    FontLoader {
        id: font_hanzhen;
        source: "qrc:/res/font/hanzhen.ttf"
    }
    Image {
        id: img_background
        source: "qrc:/res/pictures/login_background.png"
        width: parent.width
        height: parent.height
    }

    Rectangle {
        id: rect_login
        width: parent.width * 0.4
        height: parent.height * 0.4
        color: "transparent"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter

        }
        Image {
            id: name
            source: "qrc:/res/pictures/logo_2.png"
            width: parent.width * 0.4
            height: parent.height * 0.15
            fillMode: Image.PreserveAspectFit
                anchors{
                    top:parent.top
                    topMargin: parent.height * 0.19
                    horizontalCenter: parent.horizontalCenter
                }

        }


        Rectangle {
            id: rect_main
            width: parent.width * 0.8
            height: parent.height * 0.8
            anchors{
                top:parent.top
                topMargin: height * 0.47
                horizontalCenter: parent.horizontalCenter
            }
            color: "transparent"

            Rectangle {
                id: rect_username
                width: parent.width * 0.95
                height: parent.height * 0.23
                color:"transparent"
                anchors{
                    left: parent.left
                    leftMargin: width * 0.1
                    top: parent.top
                    //topMargin: parent.height * 0.04
                }

                TLTextField {
                    id: username
                    width: parent.width * 0.7
                    height: parent.height * 0.8
                    Image {
                        id: login_user
                        source: "qrc:/res/pictures/login_user.png"
                        //fillMode: Image.PreserveAspectFit
                        width: parent.width * 0.15
                        height: parent.height * 0.95
                        anchors.left: parent.left
                    }
                    anchors{
                        left: parent.left
                        leftMargin: parent.width * 0.1
                    }
                    text: root._default_test_user
                    placeholderText: qsTr("enter your username.")
                    validator: RegExpValidator{regExp:/^.[A-Za-z0-9_]{0,11}$/}

                }
            }
            Rectangle {
                id: rect_pwd
                width: parent.width * 0.95
                height: parent.height * 0.25
                color:"transparent"
                anchors{
                    top: rect_username.bottom
                    topMargin: parent.height * 0.06
                    left: parent.left
                    leftMargin: width * 0.1
                }
                TLTextField {
                    id: password
                    width: parent.width * 0.7
                    height: parent.height * 0.8
                    Image {
                        id: login_passwd
                        source: "qrc:/res/pictures/login_passwd.png"
                        width: parent.width * 0.15
                        height: parent.height * 0.95
                        fillMode: Image.PreserveAspectFit
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.01
                    }
                    anchors{
                        left: parent.left
                        leftMargin: parent.width * 0.1
                    }
                    text: root._default_test_user
                    placeholderText: qsTr("enter your password.")
                    validator: RegExpValidator{regExp:/^.[A-Za-z0-9_]{0,11}$/}

                    echoMode: TextInput.Password
                }
            }

            Rectangle{
//                width: rect_login.width * 0.12
//                height: rect_login.height * 0.15
                radius: rect_login.width * 0.02
                width: rect_login.width * 0.3
                height: rect_login.height * 0.12
                color: "#1874CD"
                anchors {
                    top: rect_pwd.bottom
                    topMargin: parent.height * 0.01

                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width * 0.022
                }

//                Image {
//                    id: login_ok
//                    //source: "qrc:/res/pictures/login_ok1.png"
//                    width: parent.width
//                    height: parent.height
//                    width: parent.width * 0.8
//                    height: parent.height * 0.9
//                    fillMode: Image.PreserveAspectFit
                    Text {
                        id: login_button
                        text: qsTr("登   录")
                        font.pixelSize: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: "white"
                    }

//                }
            MouseArea {
                id: btn_ok
                anchors.fill:parent
//                width: rect_login.width * 0.635
//                height: rect_login.height * 0.15
//
//                anchors {
//                    top: rect_pwd.bottom
//                    topMargin: parent.height * 0.02
//
//                    horizontalCenter: parent.horizontalCenter
//                    horizontalCenterOffset: parent.width * 0.022
//                }

                onClicked: {
                    if (root._login_faild_time < 3 ) {
                        account_manager.accountLogin(username.text, password.text)

                    } else {
                        ++ root._login_faild_time
                        message_login_faild.dia_title = qsTr("login failed!")
                        message_login_faild.dia_content = qsTr("Multiple login failures,please contact the administrator!")
                        message_login_faild.open()
                    }
                }
            }
        }
        }
    }
}
