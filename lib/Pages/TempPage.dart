import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../MyHomePage.dart';

class TempPage extends StatefulWidget {
  const TempPage({super.key});

  @override
  State<TempPage> createState() => _TempPageState();
}

class _TemperatureData {
  final DateTime date;
  final double temperature;

  _TemperatureData(this.date, this.temperature);
}

class _TempPageState extends State<TempPage> {
  List<String> selectedDates = [];
  late Timer _timer;
  late List<_TemperatureData> _data = []; // Initialize data variab

  @override
  void initState() {
    super.initState();
    _fetchDataPeriodically();
  }

  Future<List<_TemperatureData>> fetchTemperatureData() async {
    final response = await http.get(
      Uri.parse('https://flask-api-mu.vercel.app/get_data'),
    );
    if (response.statusCode == 200 && mounted) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<_TemperatureData> temperatureDataList = [];

      // Convert JSON data to _TemperatureData objects
      responseData.forEach((dateStr, data) {
        DateTime? date = DateTime.tryParse(dateStr.split("+")[0]); // Parse date
        double temperature =
            double.tryParse(data['temperature'].split(" ")[0]) ??
                0; // Parse temperature
        temperatureDataList
            .add(_TemperatureData(date as DateTime, temperature));
      });

      // Sort the list by date in descending order
      temperatureDataList.sort((a, b) => b.date.compareTo(a.date));

      // Get dates every 7 data points
      selectedDates.clear();
      for (int i = 0; i < temperatureDataList.length; i += 7) {
        final date = temperatureDataList[i].date;
        final String formattedTime = '${date.hour}:${date.minute}';
        selectedDates.add(formattedTime);
      }

      return temperatureDataList
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
      List<_TemperatureData> newData = await fetchTemperatureData();
      setState(() {
        _data = newData; // Update the data variable
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(50),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: context.watch<SharedData>().isNightMode
                  ? [Colors.tealAccent, Colors.teal]
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
          child: Column(children: [
            const Text("Temperature Chart",
                style: TextStyle(
                    fontFamily: "Madimi_One",
                    fontSize: 25,
                    color:
                        // context.watch<SharedData>().isNightMode
                        //     ? Colors.black:
                        Colors.white)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SfSparkLineChart.custom(
                labelStyle: TextStyle(
                    // fontFamily: 'Madimi_One',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.redAccent,
                    backgroundColor: context.watch<SharedData>().isNightMode
                        ? Colors.black
                        : Colors.white),
                color:
                    // context.watch<SharedData>().isNightMode
                    //     ? Colors.black:
                    Colors.white,
                axisLineColor:
                    // context.watch<SharedData>().isNightMode
                    //     ? Colors.black:
                    Colors.white,
                highPointColor: Colors.red,
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                marker: const SparkChartMarker(
                  displayMode: SparkChartMarkerDisplayMode.all,
                ),
                labelDisplayMode: SparkChartLabelDisplayMode.high,
                xValueMapper: (int index) => _data[index].date.toString(),
                yValueMapper: (int index) => _data[index].temperature,
                dataCount: _data.length,
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
          ])),
    ));
  }
}
