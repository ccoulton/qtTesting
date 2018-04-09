import QtQuick 2.9
import QtQuick.Window 2.2
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
        //*/
        CircularGauge{
            id:speedometer
            Text {
                id: speedometerLabel
                x: 231
                y: 247
                width: 43
                height: 20
                color: "#ffffff"
                text: qsTr("MPH")
                font.family: "Times New Roman"
                font.pixelSize: 12
            }
            //controls
            property bool accelerating: false
            value: accelerating ? maximumValue: 0
            Keys.onSpacePressed: accelerating = true
            Keys.onReleased: {
                if (Qt.Key_Space === event.key) {
                    accelerating   = false;
                    event.accepted = true;
                }
            }
            //animation *derp*
            Component.onCompleted: forceActiveFocus()
            Behavior on value {
                NumberAnimation {
                    duration: 1000
                }
            }
            //placement
            anchors.verticalCenter: parent.verticalCenter
            width: height
            maximumValue: 150
            height: root.height * 0.5
            //styling
            style: CircularGaugeStyle {
                labelInset: outerRadius * 0.15
                tickmarkStepSize: 20
                minorTickmarkCount: 3
                maximumValueAngle: 125
                minimumValueAngle: -125

            }
            //fuel subgauge
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
                    tickmarkStepSize: .5
                    minorTickmarkCount: 1
                    tickmarkLabel: Text {
                        text: styleData.value === 1? 'F':
                              styleData.value === (0.5)? "1/2":'E'
                        color:styleData.value === 0? "red":"white"
                    }
                }
            }

            //kph sub gauge
            CircularGauge {
                id:subspeedometer
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width *.75
                height: parent.height *.75
                maximumValue: 240
                style: CircularGaugeStyle {
                    needle: null
                    labelInset: outerRadius * 0.125
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

                Text {
                    id: kphMeterlabel
                    x: 160
                    y: 175
                    text: qsTr("KPH")
                    color: "grey"
                    font.pixelSize: 12
                }


            }//*/
        }
    }
}
