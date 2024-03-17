import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DBData extends StatefulWidget {
  const DBData({super.key});

  @override
  State<DBData> createState() => DBDataState();
}

class DBDataState extends State<DBData> {
  List<String> selectedDates = [];
  late Timer _timer;
  late List<MyData> myData = [];

  List<MyData> getMyData() {
    return myData;
  }

  @override
  void initState() {
    super.initState();
    fetchDataPeriodically();
  }

  Future<List<MyData>> fetchMyData() async {
    final response = await http.get(
      Uri.parse('https://flask-api-mu.vercel.app/get_data'),
    );
    if (response.statusCode == 200 && mounted) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<MyData> mq2DataList = [];

      // Convert JSON data to MyData objects
      responseData.forEach((dateStr, data) {
        DateTime? date = DateTime.tryParse(dateStr.split("+")[0]); // Parse date
        double mq2 = double.tryParse(data['mq2_gas_level'].split(" ")[0]) ??
            0; // Parse mq2
        mq2DataList.add(MyData(
            accelMag: 0,
            mq2Val: mq2,
            mq135Val: 0,
            tempVal: 0,
            time: date as DateTime));
      });

      // Sort the list by date in descending order
      mq2DataList.sort((a, b) => b.time.compareTo(a.time));

      // Get dates every 7 data points
      selectedDates.clear();
      for (int i = 0; i < mq2DataList.length; i += 7) {
        final date = mq2DataList[i].time;
        final String formattedTime = '${date.hour}:${date.minute}';
        selectedDates.add(formattedTime);
      }

      return mq2DataList.take(49).toList(); // Return the latest 10 data points
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

  Future<List<MyData>> fetchDataPeriodically() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      List<MyData> newData = await fetchMyData();
      setState(() {
        myData = newData; // Update the data variable
      });
    });
    return myData;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyData {
  double tempVal;
  double mq2Val;
  double mq135Val;
  DateTime time;
  int accelMag;

  MyData({
    required this.tempVal,
    required this.mq2Val,
    required this.mq135Val,
    required this.time,
    required this.accelMag,
  });
}
