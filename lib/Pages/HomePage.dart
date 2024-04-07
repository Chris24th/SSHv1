import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
  final String userID = "001";

  @override
  void initState() {
    super.initState();
    _fetchDataPeriodically();
  }

  Future<void> _fetchData() async {
    final response = await http
        .get(Uri.parse('https://flask-api-mu.vercel.app/get_userdata/$userID'));

    if (response.statusCode == 200 && mounted) {
      setState(() {
        _responseData = json.decode(response.body);
      });

      // Check if the "user_id" key exists
      if (_responseData.containsKey('user_id')) {
        final userId = _responseData['user_id'];
        // skip it
      }

      // Get the list of keys (timestamps) from the JSON response, excluding the "user_id" key
      List<String> timestamps =
          _responseData.keys.where((key) => key != 'user_id').toList();

      // Sort the timestamps in descending order
      timestamps.sort((a, b) {
        final dateTimeA = DateTime.parse(a);
        final dateTimeB = DateTime.parse(b);
        return dateTimeB.compareTo(dateTimeA);
      });

      // Get the latest timestamp
      String latestTimestamp = timestamps.first;

      // Extract the sensor data using the latest timestamp
      if (_responseData.containsKey(latestTimestamp)) {
        final sensorData = _responseData[latestTimestamp];
        setState(() {
          _currentTempData = sensorData['temperature'];
          _currentMq2Data = sensorData['mq2_value'];
          _currentMq135Data = sensorData['mq135_value'];
        });
      } else {
        // Handle the case where the expected keys are not found
        _currentTempData = 0;
        _currentMq2Data = 0;
        _currentMq135Data = 0;
      }
    } else {
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}');
    }
  }

  String? _getLatestTimestamp(Set<String> timestamps) {
    if (timestamps.isEmpty) {
      return null;
    }
    // Convert timestamps to DateTime objects and find the maximum
    return timestamps
        .map((timestamp) => DateTime.parse(timestamp))
        .reduce((a, b) => a.isAfter(b) ? a : b)
        .toString();
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
