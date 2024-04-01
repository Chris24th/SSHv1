import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../MyHomePage.dart';

class SmokePage extends StatefulWidget {
  const SmokePage({super.key});

  @override
  State<SmokePage> createState() => _SmokePageState();
}

class _SmokePageState extends State<SmokePage> {
  List<String> selectedDates = [];
  late Timer _timer;
  late List<_SmokeData> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchDataPeriodically();
  }

  Future<List<_SmokeData>> fetchSmokeData() async {
    final response = await http.get(
      Uri.parse('https://flask-api-mu.vercel.app/get_data'),
    );
    if (response.statusCode == 200 && mounted) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<_SmokeData> smokeDataList = [];

      // Convert JSON data to _SmokeData objects
      responseData.forEach((dateStr, data) {
        DateTime? date = DateTime.tryParse(dateStr.split("+")[0]); // Parse date
        double mq2Level =
            double.tryParse(data['mq2_gas_level'].split(" ")[0]) ??
                0; // Parse mq2Level
        double mq135Level =
            double.tryParse(data['mq135_gas_level'].split(" ")[0]) ??
                0; // Parse mq135Level
        smokeDataList.add(_SmokeData(date as DateTime, mq2Level, mq135Level));
      });

      // Sort the list by date in descending order
      smokeDataList.sort((a, b) => b.date.compareTo(a.date));

      // Get dates every 7 data points
      selectedDates.clear();
      for (int i = 0; i < 49; i += 7) {
        final date = smokeDataList[i].date;
        final String formattedTime = '${date.hour}:${date.minute}';
        selectedDates.add(formattedTime);
      }

      return smokeDataList
          .take(49)
          .toList(); // Return the latest 10 data points
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

  Future<void> _fetchDataPeriodically() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      List<_SmokeData> newData = await fetchSmokeData();
      setState(() {
        _data = newData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            flex: 2,
            child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: context.watch<SharedData>().isNightMode
                        ? [Colors.teal.shade200, Colors.teal]
                        : [Colors.orangeAccent, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.watch<SharedData>().isNightMode
                        ? Colors.tealAccent
                        : Colors.orangeAccent,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Text("MQ-2 Gas Level Chart",
                        style: TextStyle(
                            fontFamily: "Madimi_One",
                            fontSize: 20,
                            color:
                                // context.watch<SharedData>().isNightMode
                                //     ? Colors.black:
                                Colors.white)),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SfSparkLineChart.custom(
                            labelStyle: TextStyle(
                                fontFamily: 'Madimi_One',
                                fontSize: 10,
                                color: Colors.deepOrange,
                                backgroundColor: Colors.white),
                            color: Colors.white,
                            axisLineColor: Colors.white,
                            highPointColor: Colors.red,
                            trackball: const SparkChartTrackball(
                                activationMode: SparkChartActivationMode.tap),
                            marker: const SparkChartMarker(
                              displayMode: SparkChartMarkerDisplayMode.all,
                            ),
                            labelDisplayMode: SparkChartLabelDisplayMode.high,
                            xValueMapper: (int index) =>
                                _data[index].date.toString(),
                            yValueMapper: (int index) => _data[index].mq2Level,
                            dataCount: _data.length,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: selectedDates.map((time) {
                        return Text(
                          time,
                          style: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ],
                ))),
        Expanded(
            flex: 2,
            child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: context.watch<SharedData>().isNightMode
                        ? [Colors.teal.shade200, Colors.teal]
                        : [Colors.orangeAccent, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.watch<SharedData>().isNightMode
                        ? Colors.tealAccent
                        : Colors.orangeAccent,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Text("MQ-135 Gas Level Chart",
                        style: TextStyle(
                            fontFamily: "Madimi_One",
                            fontSize: 20,
                            color:
                                // context.watch<SharedData>().isNightMode
                                //     ? Colors.black:
                                Colors.white)),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SfSparkLineChart.custom(
                            labelStyle: TextStyle(
                                fontFamily: 'Madimi_One',
                                fontSize: 10,
                                color: Colors.deepOrange,
                                backgroundColor: Colors.white),
                            color: Colors.white,
                            axisLineColor: Colors.white,
                            highPointColor: Colors.red,
                            trackball: const SparkChartTrackball(
                                activationMode: SparkChartActivationMode.tap),
                            marker: const SparkChartMarker(
                              displayMode: SparkChartMarkerDisplayMode.all,
                            ),
                            labelDisplayMode: SparkChartLabelDisplayMode.high,
                            xValueMapper: (int index) =>
                                _data[index].date.toString(),
                            yValueMapper: (int index) =>
                                _data[index].mq135Level,
                            dataCount: _data.length,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: selectedDates.map((time) {
                        return Text(
                          time,
                          style: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ],
                ))),
      ]),
    ));
  }
}

class _SmokeData {
  final DateTime date;
  final double mq2Level;
  final double mq135Level;

  _SmokeData(this.date, this.mq2Level, this.mq135Level);
}
