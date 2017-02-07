import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Pickers 1.3
import Qt.WebSockets 1.0
import QtQuick.Layouts 1.1

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "dialer.liu-xiao-guo"

    width: units.gu(60)
    height: units.gu(85)

    function interpreteData(data) {
        var json = JSON.parse(data)
        console.log("Websocket data: " + data)

        console.log("value: " + json.data)
        mainHand.value = json.data
    }

    WebSocket {
        id: socket
        url: input.text
        onTextMessageReceived: {
            console.log("something is received!: " + message);
            interpreteData(message)
        }

        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log("Error: " + socket.errorString)
            } else if (socket.status == WebSocket.Open) {
                // socket.sendTextMessage("Hello World....")
            } else if (socket.status == WebSocket.Closed) {
            }
        }
        active: true
    }

    Page {
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("dialer")
        }

        Item {
            anchors {
                top: pageHeader.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Column {
                anchors.fill: parent
                spacing: units.gu(1)
                anchors.topMargin: units.gu(2)

                Dialer {
                    id: dialer
                    size: units.gu(30)
                    minimumValue: 0
                    maximumValue: 1000
                    anchors.horizontalCenter: parent.horizontalCenter

                    DialerHand {
                        id: mainHand
                        onValueChanged: console.log(value)
                    }
                }


                TextField {
                    id: input
                    width: parent.width
                    text: "ws://192.168.1.106:4001"
                }

                Label {
                    id: value
                    text: mainHand.value
                }
            }
        }
    }
}
