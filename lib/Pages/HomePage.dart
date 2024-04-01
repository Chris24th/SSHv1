import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../MyHomePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  late Map<String, dynamic> _responseData = {};
  double _currentTempData = 0;
  double _currentMq2Data = 0;
  double _currentMq135Data = 0;
  String message = "This is a test message!";
  List<String> recipents = ["+639274478614", "09274478614"];

  @override
  void initState() {
    super.initState();
    _fetchDataPeriodically();
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://flask-api-mu.vercel.app/get_data')); // Replace with your API endpoint
    if (response.statusCode == 200 && mounted) {
      setState(() {
        _responseData = json.decode(response.body);
      });

      String latestTimestamp = _responseData.keys.reduce((a, b) {
        return DateTime.parse(a).isAfter(DateTime.parse(b)) ? a : b;
      });

      if (_responseData.containsKey(latestTimestamp)) {
        setState(() {
          _currentTempData = double.tryParse(_responseData[latestTimestamp]
                      ['temperature']
                  .split(" ")[0]) ??
              0;
          _currentMq2Data = double.tryParse(_responseData[latestTimestamp]
                      ['mq2_gas_level']
                  .split(" ")[0]) ??
              0;
          _currentMq135Data = double.tryParse(_responseData[latestTimestamp]
                      ['mq135_gas_level']
                  .split(" ")[0]) ??
              0;
        });
      }
    } else {
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _fetchDataPeriodically() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //CAMERA
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 5),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.watch<SharedData>().isNightMode
                        ? Colors.tealAccent
                        : Colors.orangeAccent,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CAMERA',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    ElevatedButton(
                        child: const Text("test sms"),
                        onPressed: () => _sendSMS)
                  ],
                ),
              ),
            ),
            //TEMP AND GAS
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
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
                        child: Column(
                          children: [
                            Text(
                              "TEMPERATURE",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Expanded(
                                child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 30,
                                  maximum: 40,
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                      startValue: 30,
                                      endValue: 40,
                                      gradient: SweepGradient(
                                          colors: context
                                                  .watch<SharedData>()
                                                  .isNightMode
                                              ? <Color>[
                                                  Colors.tealAccent,
                                                  Colors.teal
                                                ]
                                              : <Color>[
                                                  Colors.orange,
                                                  Colors.deepOrange
                                                ]),
                                    ),
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                      value: _currentTempData ?? 0,
                                      needleStartWidth: 4,
                                      needleEndWidth: 4,
                                      enableAnimation: true,
                                      animationType: AnimationType.ease,
                                      animationDuration: 1000,
                                      needleColor: context
                                              .watch<SharedData>()
                                              .isNightMode
                                          ? Colors.tealAccent
                                          : Colors.deepOrange,
                                      knobStyle: KnobStyle(
                                          color: context
                                                  .watch<SharedData>()
                                                  .isNightMode
                                              ? Colors.tealAccent
                                              : Colors.deepOrange),
                                    ),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      widget: Text(
                                        '$_currentTempData °C',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: context
                                                  .watch<SharedData>()
                                                  .isNightMode
                                              ? Colors.tealAccent
                                              : Colors.deepOrange,
                                        ),
                                      ),
                                      angle: 90,
                                      positionFactor: 1.1,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                          ],
                        )),
                  ),
                  //GAS
                  Expanded(
                    flex: 3,
                    child: Container(
                        height: double.maxFinite,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 5),
                        child: Column(
                          children: [
                            Text(
                              "GAS LEVELS",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Expanded(
                                child: Row(children: [
                              //MQ2
                              Expanded(
                                  child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 100,
                                    maximum: 3000,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 100,
                                        endValue: 3000,
                                        gradient: SweepGradient(
                                            colors: context
                                                    .watch<SharedData>()
                                                    .isNightMode
                                                ? <Color>[
                                                    Colors.tealAccent,
                                                    Colors.teal
                                                  ]
                                                : <Color>[
                                                    Colors.orange,
                                                    Colors.deepOrange
                                                  ]),
                                      ),
                                    ],
                                    pointers: <GaugePointer>[
                                      NeedlePointer(
                                        value: _currentMq2Data ?? 0,
                                        needleStartWidth: 4,
                                        needleEndWidth: 4,
                                        enableAnimation: true,
                                        animationType: AnimationType.ease,
                                        animationDuration: 1000,
                                        needleColor: context
                                                .watch<SharedData>()
                                                .isNightMode
                                            ? Colors.tealAccent
                                            : Colors.deepOrange,
                                        knobStyle: KnobStyle(
                                            color: context
                                                    .watch<SharedData>()
                                                    .isNightMode
                                                ? Colors.tealAccent
                                                : Colors.deepOrange),
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          'MQ-2:\n${_currentMq2Data.toInt()}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: context
                                                    .watch<SharedData>()
                                                    .isNightMode
                                                ? Colors.tealAccent
                                                : Colors.deepOrange,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        angle: 90,
                                        positionFactor: 1.2,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                              //MQ135
                              Expanded(
                                  child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 1000,
                                    maximum: 3000,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 1000,
                                        endValue: 3000,
                                        gradient: SweepGradient(
                                            colors: context
                                                    .watch<SharedData>()
                                                    .isNightMode
                                                ? <Color>[
                                                    Colors.tealAccent,
                                                    Colors.teal
                                                  ]
                                                : <Color>[
                                                    Colors.orange,
                                                    Colors.deepOrange
                                                  ]),
                                      ),
                                    ],
                                    pointers: <GaugePointer>[
                                      NeedlePointer(
                                        value: _currentMq135Data ?? 0,
                                        needleStartWidth: 4,
                                        needleEndWidth: 4,
                                        enableAnimation: true,
                                        animationType: AnimationType.ease,
                                        animationDuration: 1000,
                                        needleColor: context
                                                .watch<SharedData>()
                                                .isNightMode
                                            ? Colors.tealAccent
                                            : Colors.deepOrange,
                                        knobStyle: KnobStyle(
                                            color: context
                                                    .watch<SharedData>()
                                                    .isNightMode
                                                ? Colors.tealAccent
                                                : Colors.deepOrange),
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          'MQ-135:\n${_currentMq135Data.toInt()}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: context
                                                    .watch<SharedData>()
                                                    .isNightMode
                                                ? Colors.tealAccent
                                                : Colors.deepOrange,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        angle: 90,
                                        positionFactor: 1.2,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ])),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
