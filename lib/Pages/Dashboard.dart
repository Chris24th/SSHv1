import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../MyHomePage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController _textEditingController = TextEditingController();
  int _editingIndex = -1;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> updateName(String documentId, String newName) async {
    final String apiUrl =
        'https://flask-api-mu.vercel.app/update_name/$documentId';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': newName,
        }),
      );
    } catch (e) {
      print('Exception caught: $e');
    }
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
            height: 45,
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
              sharedData.selectedName == ''
                  ? 'No Helmet Selected'
                  : "${sharedData.selectedName}'s Helmet",
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
                                      minimum: 20,
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
                                                    '${sharedData.temperature.toString()}°C',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 23)),
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
                                                      Colors.teal,
                                                      Colors.tealAccent
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
                                                    '${sharedData.mq135Value.toString()} %',
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
                                          value: sharedData.mq135Value,
                                          width: 15,
                                          pointerOffset: -5,
                                          cornerStyle: CornerStyle.bothCurve,
                                          gradient: SweepGradient(
                                              colors: sharedData.isNightMode
                                                  ? <Color>[
                                                      Colors.teal,
                                                      Colors.tealAccent
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
                                          value: sharedData.mq135Value - 3,
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
                                                    '${sharedData.mq2Value.toString()} %',
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
                                          value: sharedData.mq2Value,
                                          width: 15,
                                          pointerOffset: -5,
                                          cornerStyle: CornerStyle.bothCurve,
                                          gradient: SweepGradient(
                                              colors: sharedData.isNightMode
                                                  ? <Color>[
                                                      Colors.teal,
                                                      Colors.tealAccent
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
                                          value: sharedData.mq2Value - 3,
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.thermostat,
                    color: sharedData.isNightMode
                        ? Colors.tealAccent
                        : Colors.orange),
                const Text(': Temperature'),
                const SizedBox(width: 35),
                Icon(Icons.air,
                    color: sharedData.isNightMode
                        ? Colors.tealAccent
                        : Colors.orange),
                const Text(': Bad Air Quality'),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.local_fire_department_outlined,
                    color: sharedData.isNightMode
                        ? Colors.tealAccent
                        : Colors.orange),
                const Text(': Flammable gas'),
                const SizedBox(width: 25),
                Icon(Icons.healing_rounded,
                    color: sharedData.isNightMode
                        ? Colors.tealAccent
                        : Colors.orange),
                const Text(': Fall/Impact')
              ]),
              const SizedBox(height: 10),
              // Loop over the map entries and create a widget for each entry...sharedData.usersData.entries.map((entry) {

//--------------------------------------------------------------------------------------------------

              ...sharedData.usersData.entries.map((entry) {
                String key = entry.key;
                int index = int.parse(key);
                Map<String, dynamic> value = entry.value;
                //---------------------------------------
                String input = value['lastUpdated'];
                List<String> chunks = [];
                int startIndex = 0;
                while (startIndex < input.length) {
                  int endIndex = startIndex + 23;
                  if (endIndex > input.length) {
                    endIndex = input.length;
                  }
                  chunks.add(input.substring(startIndex, endIndex));
                  startIndex = endIndex;
                }
                //---------------------------------------
                DateTime lastUpdatedDateTime = DateTime.parse(chunks.first);
// Get the current datetime and subtract one minute
                DateTime oneMinuteAgo =
                    DateTime.now().subtract(const Duration(minutes: 1));
// Compare the two dates
                bool isActive = lastUpdatedDateTime.isAfter(oneMinuteAgo);
                if (isActive) {
                  return ListTile(
                    tileColor: sharedData.selectedHelmID == key
                        ? !sharedData.isNightMode
                            ? Colors.orange.shade100
                            : Colors.teal.shade900
                        : null,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _editingIndex == index
                                ? TextField(
                                    controller: _textEditingController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter name',
                                    ),
                                  )
                                : Text(
                                    '${value['name']}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: _editingIndex == index
                                ? Icon(Icons.save)
                                : Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _editingIndex =
                                    _editingIndex == index ? -1 : index;
                                if (_editingIndex == index) {
                                  _textEditingController.text =
                                      '${value['name']}';
                                }
                              });
                              updateName(key, _textEditingController.text);
                            },
                          ),
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
                                    sharedData.selectedName =
                                        '${value['name']}';
                                    sharedData.selectedHelmID = key;
                                    sharedData.temperature =
                                        value['temperature'];
                                    sharedData.mq135Value =
                                        value['mq135_value'];
                                    sharedData.mq2Value = value['mq2_value'];
                                  }))
                        ]),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.thermostat,
                            color: value['temperature'] < 40
                                ? (sharedData.isNightMode
                                    ? Colors.tealAccent
                                    : Colors.orange)
                                : Colors.red),
                        Text(': ${value['temperature']}'),
                        const SizedBox(width: 10),
                        Icon(Icons.air,
                            color: value['mq135_value'] < 50
                                ? (sharedData.isNightMode
                                    ? Colors.tealAccent
                                    : Colors.orange)
                                : Colors.red),
                        Text(': ${value['mq135_value']}%'),
                        const SizedBox(width: 10),
                        Icon(Icons.local_fire_department_outlined,
                            color: value['mq2_value'] < 50
                                ? (sharedData.isNightMode
                                    ? Colors.tealAccent
                                    : Colors.orange)
                                : Colors.red),
                        Text(': ${value['mq2_value']}%'),
                        const SizedBox(width: 10),
                        Icon(Icons.healing_rounded,
                            color: value['impact_detected'] == false ||
                                    value['impact_detected'] == 0
                                ? (sharedData.isNightMode
                                    ? Colors.tealAccent
                                    : Colors.orange)
                                : Colors.red),
                        Text(value['impact_detected'] == true ||
                                value['impact_detected'] == 1
                            ? ': IMPACT/FALL!!'
                            : ': None'),
                      ],
                    ),
                  );
                } else {
                  return ListTile(
                      title: Text("${value['name']}'s Helmet status: Offline"));
                }
              }).toList(),
            ],
          ),
          const SizedBox(height: 70)
        ])));
  }
}
