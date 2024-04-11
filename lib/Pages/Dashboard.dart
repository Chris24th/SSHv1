import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../MyHomePage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedHelm = 'John Doe';

  int calculateMq135() {
    SharedData sharedData = context.watch<SharedData>();
    double mq135Percent = ((sharedData.mq135Value - 1400) / 3000) * 100;
    return mq135Percent > 0 ? mq135Percent.toInt() : 0;
  }

  int calculateMq2() {
    SharedData sharedData = context.watch<SharedData>();
    double mq2Percent = ((sharedData.mq2Value - 300) / 2000) * 100;
    return mq2Percent > 0 ? mq2Percent.toInt() : 0;
  }

  @override
  Widget build(BuildContext context) {
    SharedData sharedData = context.watch<SharedData>();
    return Material(
        child: Center(
            child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          Container(
            padding: const EdgeInsets.all(5),
            margin:
                const EdgeInsets.only(top: 10, bottom: 5, left: 50, right: 50),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: sharedData.isNightMode
                    ? [Colors.teal.shade200, Colors.teal]
                    : [Colors.orangeAccent, Colors.orange],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$selectedHelm's Helmet",
              style: TextStyle(
                fontFamily: "Madimi_One",
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //TEMP
                  Expanded(
                    flex: 2,
                    child: Container(
                        height: double.maxFinite,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 5),
                        child: Column(children: [
                          Text(
                            "Temperature",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Expanded(
                              flex: 2,
                              child: SfRadialGauge(
                                enableLoadingAnimation: true,
                                axes: <RadialAxis>[
                                  RadialAxis(
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 0.8,
                                      maximum: 50,
                                      axisLineStyle: const AxisLineStyle(
                                          cornerStyle: CornerStyle.startCurve,
                                          thickness: 5),
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            angle: 90,
                                            widget: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                    '${sharedData.temperature.toString()} °C',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 25)),
                                              ],
                                            )),
                                      ],
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          value: sharedData.temperature,
                                          width: 15,
                                          pointerOffset: -5,
                                          cornerStyle: CornerStyle.bothCurve,
                                          gradient: SweepGradient(
                                              colors: sharedData.isNightMode
                                                  ? <Color>[
                                                      Colors.tealAccent,
                                                      Colors.teal
                                                    ]
                                                  : <Color>[
                                                      Colors.orangeAccent,
                                                      Colors.orange
                                                    ],
                                              stops: <double>[0.25, 0.75]),
                                        ),
                                        MarkerPointer(
                                          value: sharedData.temperature - 2,
                                          color: Colors.white,
                                          markerType: MarkerType.circle,
                                        ),
                                      ]),
                                ],
                              ))
                        ])),
                  ),
                  //AIR QUALITY
                  Expanded(
                    flex: 2,
                    child: Container(
                        height: double.maxFinite,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 5),
                        child: Column(children: [
                          Text(
                            "Air Quality",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Expanded(
                              flex: 2,
                              child: SfRadialGauge(
                                enableLoadingAnimation: true,
                                axes: <RadialAxis>[
                                  RadialAxis(
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 0.8,
                                      maximum: 100,
                                      axisLineStyle: const AxisLineStyle(
                                          cornerStyle: CornerStyle.startCurve,
                                          thickness: 5),
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            angle: 90,
                                            widget: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                    '${calculateMq135().toString()} %',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 25)),
                                              ],
                                            )),
                                      ],
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          value: calculateMq135().toDouble(),
                                          width: 15,
                                          pointerOffset: -5,
                                          cornerStyle: CornerStyle.bothCurve,
                                          gradient: SweepGradient(
                                              colors: sharedData.isNightMode
                                                  ? <Color>[
                                                      Colors.tealAccent,
                                                      Colors.teal
                                                    ]
                                                  : <Color>[
                                                      Colors.orangeAccent,
                                                      Colors.orange
                                                    ],
                                              stops: <double>[0.25, 0.75]),
                                        ),
                                        MarkerPointer(
                                          value:
                                              calculateMq135().toDouble() - 3,
                                          color: Colors.white,
                                          markerType: MarkerType.circle,
                                        ),
                                      ]),
                                ],
                              ))
                        ])),
                  ),
                  //FLAMMABLE GAS
                  Expanded(
                    flex: 2,
                    child: Container(
                        height: double.maxFinite,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 5),
                        child: Column(children: [
                          Text(
                            "Flammable gas",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Expanded(
                              flex: 2,
                              child: SfRadialGauge(
                                enableLoadingAnimation: true,
                                axes: <RadialAxis>[
                                  RadialAxis(
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 0.8,
                                      maximum: 100,
                                      axisLineStyle: const AxisLineStyle(
                                          cornerStyle: CornerStyle.startCurve,
                                          thickness: 5),
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            angle: 90,
                                            widget: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                    '${calculateMq2().toString()} %',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 25)),
                                              ],
                                            )),
                                      ],
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          value: calculateMq2().toDouble(),
                                          width: 15,
                                          pointerOffset: -5,
                                          cornerStyle: CornerStyle.bothCurve,
                                          gradient: SweepGradient(
                                              colors: sharedData.isNightMode
                                                  ? <Color>[
                                                      Colors.tealAccent,
                                                      Colors.teal
                                                    ]
                                                  : <Color>[
                                                      Colors.orangeAccent,
                                                      Colors.orange
                                                    ],
                                              stops: <double>[0.25, 0.75]),
                                        ),
                                        MarkerPointer(
                                          value: calculateMq2().toDouble() - 3,
                                          color: Colors.white,
                                          markerType: MarkerType.circle,
                                        ),
                                      ]),
                                ],
                              ))
                        ])),
                  ),
                ],
              )),
          Column(
            children: [
              Container(
                  child: Text('Registered Helmets:',
                      style: Theme.of(context).textTheme.displayLarge)),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('Name'),
                Text('Online status'),
                Text('Temperature'),
                Text('Air Quality'),
                Text('Flammable gas'),
                Text('Impact'),
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('Name'),
                Text('Online status'),
                Text('Temperature'),
                Text('Air Quality'),
                Text('Flammable gas'),
                Text('Impact'),
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('Name'),
                Text('Online status'),
                Text('Temperature'),
                Text('Air Quality'),
                Text('Flammable gas'),
                Text('Impact'),
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('Name'),
                Text('Online status'),
                Text('Temperature'),
                Text('Air Quality'),
                Text('Flammable gas'),
                Text('Impact'),
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('Name'),
                Text('Online status'),
                Text('Temperature'),
                Text('Air Quality'),
                Text('Flammable gas'),
                Text('Impact'),
              ])
            ],
          )
          // const SizedBox(height: 15)
        ])));
  }
}
