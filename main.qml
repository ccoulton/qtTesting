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
        spacing: root.width * .15
        anchors.centerIn: parent
        Keys.onSpacePressed: accelerating = true
        Keys.onReleased: {
            if (event.key === Qt.Key_Space) {
                speedometer.accelerating   = false;
                event.accepted = true;
            }
        }
        CircularGauge {
            id: tachometer
            tickmarksVisible: true
            width: height
            height: root.height * .5
            value: valueSource.rpm
            maximumValue: 8
            style: CircularGaugeStyle {
                tickmarkStepSize: 1
                minorTickmarkCount: 1
                minimumValueAngle: -130
                maximumValueAngle: 130
            }

            anchors.verticalCenter: parent.verticalCenter
        }

        CircularGauge{
            id:speedometer
            anchors.verticalCenter: parent.verticalCenter
            width: height
            maximumValue: 150
            height: root.height * 0.5
            //controls
            value: accelerating ? maximumValue: 0
            property bool accelerating: false
            //styling
            style: CircularGaugeStyle {
                labelInset: outerRadius * 0.2
                tickmarkStepSize: 20
                minorTickmarkCount: 3
                maximumValueAngle: 125
                minimumValueAngle: -125

            }

            CircularGauge {
                id: fuelGauge
                maximumValue: 1
                value: valueSource.fuel
                width: parent.width *.7
                height: parent.height *.7
                anchors.bottom: parent.bottom
                anchors.horizontalCenter:parent.horizontalCenter
                style: CircularGaugeStyle {
                    minimumValueAngle: 215
                    maximumValueAngle: 145
                    tickmarkStepSize: .25
                    minorTickmark: null
                    tickmarkLabel: Text {
                        text: styleData.value === 1? 'F':
                              styleData.value === (0.5)? "1/2":
                              styleData.value === 0? 'E':''
                        color: styleData.value ===0? "red":"white"
                    }
                }
            }

            CircularGauge {
                id:subspeedometer
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width *.7
                height: parent.height *.7
                maximumValue: 240
                style: CircularGaugeStyle {
                    needle: null
                    tickmarkLabel: Text {
                        text: styleData.value
                        color:"grey"
                    }
                    tickmark: Rectangle {
                        implicitHeight: outerRadius*.03
                        implicitWidth: outerRadius*.03
                        visible: styleData.value % 20 == 0
                        color: "grey"
                    }

                    tickmarkStepSize: 20
                    minorTickmarkCount: 0
                    minimumValueAngle: -125
                    maximumValueAngle: 125
                }
            }
        }
    }
}
