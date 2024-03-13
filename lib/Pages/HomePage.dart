import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://flask-api-mu.vercel.app/get_data')); // Replace with your API endpoint
    print('fetching...');
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      print('Response data: ${response.body}');
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}');
    }
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
            ElevatedButton(
                onPressed: () {
                  fetchData();
                },
                child: const Text("Test Firebase")),
            Expanded(
                flex: 5,
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 5),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: const Text("ESP32-CAM"))),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: const Text("TEMPERATURE"),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.maxFinite,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: const Text("SMOKE"),
                      ),
                    ),
                  ],
                ))
          ]),
    ));
  }
}
