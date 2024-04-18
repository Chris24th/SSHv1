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
  int calculateMq135(int raw) {
    double mq135Percent = ((raw - 300) / 3000) * 100;
    return mq135Percent > 0.0 ? mq135Percent.toInt() : 0;
  }

  int calculateMq2(int raw) {
    double mq2Percent = ((raw + 100) / 2000) * 100;
    return mq2Percent > 0.0 ? mq2Percent.toInt() : 0;
  }

  // void showCustomToast(String message) {
  //   final sharedData = Provider.of<SharedData>(context, listen: false);
  //   final usersData = sharedData.usersData;
  //
  //   List<String> alertsForUser = [];
  //
  //   usersData.forEach((userId, userData) {
  //     bool hasAlert = false;
  //
  //     if (userData['impact_detected'] == true) {
  //       alertsForUser.add('Impact/fall detected');
  //       hasAlert = true;
  //     }
  //
  //     double temperature = userData['temperature'];
  //     if (temperature > 36) {
  //       alertsForUser.add('High temperature: $temperature');
  //       hasAlert = true;
  //     }
  //
  //     double mq135Value = userData['mq135_value'];
  //     if (mq135Value > 1800) {
  //       alertsForUser
  //           .add('Bad Air Quality: ${calculateMq135(mq135Value.toInt())}%');
  //       hasAlert = true;
  //     }
  //
  //     double mq2Value = userData['mq2_value'];
  //     if (mq2Value > 900) {
  //       alertsForUser.add('Flammable Gas: ${calculateMq2(mq2Value.toInt())}%');
  //       hasAlert = true;
  //     }
  //
  //     if (hasAlert) {
  //       final userName = userData['name'];
  //       final alertsMessage = alertsForUser.join('\n');
  //       final snackBar = SnackBar(
  //         content: Text(
  //           '$userName: $alertsMessage',
  //           style: TextStyle(fontFamily: 'Lato'),
  //         ),
  //         duration: const Duration(seconds: 60),
  //         backgroundColor:
  //             sharedData.isNightMode ? Colors.teal : Colors.orangeAccent,
  //         action: SnackBarAction(
  //           label: 'See info',
  //           onPressed: () {
  //             sharedData.selectedHelmID = userId;
  //             sharedData.selectedName = userName;
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => MyHomePage()));
  //           },
  //           textColor: Colors.white,
  //         ),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       alertsForUser.clear();
  //     }
  //   });
  // }

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
              "${sharedData.selectedName}'s Helmet",
              style: const TextStyle(
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
                            style: Theme.of(context).textTheme.displayMedium,
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
                            style: Theme.of(context).textTheme.displayMedium,
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
                                                    '${calculateMq135(sharedData.mq135Value).toString()} %',
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
                                          value: calculateMq135(
                                                  sharedData.mq135Value)
                                              .toDouble(),
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
                                              stops: const <double>[
                                                0.25,
                                                0.75
                                              ]),
                                        ),
                                        MarkerPointer(
                                          value: calculateMq135(
                                                      sharedData.mq135Value)
                                                  .toDouble() -
                                              3,
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
                            style: Theme.of(context).textTheme.displayMedium,
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
                                                    '${calculateMq2(sharedData.mq2Value).toString()} %',
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
                                          value:
                                              calculateMq2(sharedData.mq2Value)
                                                  .toDouble(),
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
                                              stops: const <double>[
                                                0.25,
                                                0.75
                                              ]),
                                        ),
                                        MarkerPointer(
                                          value:
                                              calculateMq2(sharedData.mq2Value)
                                                      .toDouble() -
                                                  3,
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
            children: <Widget>[
              Text(
                'Available Helmets:',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 10),
              // Loop over the map entries and create a widget for each entry
              ...sharedData.usersData.entries.map((entry) {
                String key = entry.key;
                Map<String, dynamic> value = entry.value;
                return ListTile(
                  tileColor: sharedData.selectedHelmID == key
                      ? !sharedData.isNightMode
                          ? Colors.orange.shade100
                          : Colors.teal.shade900
                      : null,
                  title: Row(children: [
                    Text('${value['name']}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 20),
                    TextButton(
                        child: Text(
                            sharedData.selectedHelmID == key
                                ? 'Selected'
                                : 'Select',
                            style: const TextStyle(
                                fontFamily: 'MadimiOne',
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline)),
                        onPressed: () => setState(() {
                              sharedData.selectedName = '${value['name']}';
                              sharedData.selectedHelmID = key;
                              sharedData.temperature = value['temperature'];
                              sharedData.mq135Value = value['mq135_value'];
                              sharedData.mq2Value = value['mq2_value'];
                            }))
                  ]),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.thermostat,
                          color: value['temperature'] < 35
                              ? (sharedData.isNightMode
                                  ? Colors.tealAccent
                                  : Colors.orange)
                              : Colors.red),
                      Text(': ${value['temperature']}'),
                      const SizedBox(width: 10),
                      Icon(Icons.air,
                          color: calculateMq135(value['mq135_value']) < 50
                              ? (sharedData.isNightMode
                                  ? Colors.tealAccent
                                  : Colors.orange)
                              : Colors.red),
                      Text(': ${calculateMq135(value['mq135_value'])}%'),
                      const SizedBox(width: 10),
                      Icon(Icons.local_fire_department_outlined,
                          color: calculateMq2(value['mq2_value']) < 50
                              ? (sharedData.isNightMode
                                  ? Colors.tealAccent
                                  : Colors.orange)
                              : Colors.red),
                      Text(': ${calculateMq2(value['mq2_value'])}%'),
                      const SizedBox(width: 10),
                      Icon(Icons.broken_image_outlined,
                          color: value['impact_detected'] == false
                              ? (sharedData.isNightMode
                                  ? Colors.tealAccent
                                  : Colors.orange)
                              : Colors.red),
                      Text(value['impact_detected'] == true
                          ? ': IMPACT/FALL!!'
                          : ': No impact/fall'),
                    ],
                  ),
                );
              }).toList(),
            ],
          )
          // const SizedBox(height: 15)
        ])));
  }
}
