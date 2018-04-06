import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Window{
    id: root
    visible: true
    width: 1024
    height: 600
    color: "#161626"
    title: "Qt Dashboard Demo"
    Item {
        id: valueSource
        property real mph: 0
        property real rpm: 1
        property real fuel: 0.85
        property string gear: {
            var g;
            return ((mph == 0)? "P":(mph < 20)?"1":(mph < 30)?"2":(mph < 50)?"3":(mph < 65)?"4":"5");
        }
        property real temp: 0.6
        property bool start: true
    }
    Row {
        id: gauges
        spacing: container.width * .02
        anchors.centerIn: parent

        CircularGauge {
            id: tachometer
            width: height
            height: root.height * .25 - gauges.spacing
            value: valueSource.rpm
            maximumValue: 8
            anchors.verticalCenter: parent.verticalCenter
        }

        CircularGauge{
            id:speedometer
            value: accelerating ? maximumValue: 0
            anchors.verticalCenter: parent.verticalCenter
            property bool accelerating: false
            maximumValue: 120
            width: height
            height: Container.height * 0.5
            Keys.onSpacePressed: accelerating = true
            Keys.onReleased: {
                if (Qt.Key_Space === event.key) {
                    accelerating   = false;
                    event.accepted = true;
                }
            }
            Component.onCompleted: forceActiveFocus()
            Behavior on value {
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }

}
