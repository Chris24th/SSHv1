import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../MyHomePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  late Map<String, dynamic> _responseData = {};

  @override
  void initState() {
    super.initState();
    _fetchDataPeriodically();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://flask-api-mu.vercel.app/get_data')); // Replace with your API endpoint
    if (response.statusCode == 200 && mounted) {
      setState(() {
        _responseData = json.decode(response.body);
      });
    } else {
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}');
    }
  }

  void _fetchDataPeriodically() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 5),
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
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                        height: double.maxFinite,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 5),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(10),
                        //   border: Border.all(
                        //     color: Colors.grey,
                        //     width: 1,
                        //   ),
                        // ),
                        child: Column(
                          children: [
                            Text(
                              "Temperature",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            SizedBox(height: 20),
                            Text(
                              '${_responseData.isEmpty ? '-' : _responseData.values.last['temperature']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      padding: EdgeInsets.all(10),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Colors.grey,
                      //     width: 1,
                      //   ),
                      // ),
                      child: Column(children: [
                        Text(
                          "Gas Levels",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: 18),
                        Text(
                            'MQ135: ${_responseData.isEmpty ? '-' : _responseData.values.last['mq135_gas_level']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text(
                            'MQ2: ${_responseData.isEmpty ? '-' : _responseData.values.last['mq2_gas_level']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ]),
                    ),
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
