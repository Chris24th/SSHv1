import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Pages/CameraPage.dart';
import 'Pages/Dashboard.dart';
import 'Pages/Settings.dart';
import 'Pages/SmokePage.dart';
import 'Pages/TempPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  late Map<String, dynamic> _responseData = {};
  List<String> selectedDates = [];
  int _currentIndex = 0;
  final currentTime = DateTime.now();

  final _pages = const [
    Dashboard(),
    CameraPage(),
    TempPage(),
    SmokePage(),
    SettingsPage(),
  ];

  //..................................................................................

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the app starts
    _fetchDataPeriodically();
    showCustomToast();
  }

  Future<void> _fetchData() async {
    final sharedData = Provider.of<SharedData>(context, listen: false);
    _responseData = sharedData.responseData;
    // bool isActive = false;

    final String userID = sharedData.selectedHelmID;
    final users = await http
        .get(Uri.parse('https://flask-api-mu.vercel.app/get_all_users'));
    if (users.statusCode == 200 && mounted) {
      final response = await http.get(
          Uri.parse('https://flask-api-mu.vercel.app/get_userdata/$userID'));
      setState(() {
        context.read<SharedData>().setUsersData(json.decode(users.body));
        context.read<SharedData>().setResponseData(json.decode(response.body));
      });

      sharedData.usersData.forEach((userId, userData) {
        String input = userData['lastUpdated'];
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
          sharedData.selectedHelmID = userId;
        }
      });
      List<SmokeData> smokeDataList = [];
      List<TemperatureData> temperatureDataList = [];
      // Get the list of keys (timestamps) from the JSON response, excluding the "user_id" key
      List<String> timestamps = [];

      _responseData.keys.forEach((key) {
        if (key.contains(':')) {
          timestamps.add(key);
        }
      });
      // Sort the timestamps in descending order

      timestamps.sort((a, b) {
        final dateTimeA = DateTime.parse(a);
        final dateTimeB = DateTime.parse(b);
        return dateTimeB.compareTo(dateTimeA);
      });
      // Get the latest timestamp
      String latestTimestamp = timestamps.first;

      // Extract the sensor data using the latest timestamp
      final sensorData = _responseData[latestTimestamp];
      context.read<SharedData>().temperature =
          sensorData['temperature'].toDouble();
      context.read<SharedData>().mq2Value = sensorData['mq2_value'];
      context.read<SharedData>().mq135Value = sensorData['mq135_value'];
      if (sensorData['impact_detected'] == 1 ||
          sensorData['impact_detected'] == true) {
        context.read<SharedData>()._impactDetected = true;
      }
      //...............TEMPERATURE.............................................................
      // Convert JSON data to _TemperatureData objects
      for (String timestamp in timestamps) {
        DateTime date = DateTime.parse(timestamp);
        double temperature = _responseData[timestamp]['temperature'];
        temperatureDataList.add(TemperatureData(date, temperature));
      }
      selectedDates.clear();
      for (int i = 0; i < temperatureDataList.length && i < 49; i += 7) {
        final date = temperatureDataList[i].date;
        final String formattedTime = '${date.hour}:${date.minute}';
        selectedDates.add(formattedTime);
      }
//...............SMOKE................................................................

      // Convert JSON data to _SmokeData objects
      for (String timestamp in timestamps) {
        DateTime date = DateTime.parse(timestamp);
        int mq2Value = _responseData[timestamp]['mq2_value'].toInt();
        int mq135Value = _responseData[timestamp]['mq135_value'].toInt();
        smokeDataList.add(SmokeData(date, mq2Value, mq135Value));
      }
      smokeDataList.sort((a, b) => b.date.compareTo(a.date));
      //.....................END SMOKE..................................................
      context
          .read<SharedData>()
          .setTemperatureDataList(temperatureDataList.take(50).toList());
      context
          .read<SharedData>()
          .setSmokeDataList(smokeDataList.take(50).toList());
      context.read<SharedData>().setSelectedDates(selectedDates);
      showCustomToast();
    } else {
      throw Exception('Failed to load data. Status Code: ${users.statusCode}');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _fetchDataPeriodically() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _fetchData();
    });
  }

  void showCustomToast() {
    final sharedData = Provider.of<SharedData>(context, listen: false);
    final usersData = sharedData.usersData;

    List<String> alertsForUser = [];

    usersData.forEach((userId, userData) {
      bool hasAlert = false;

      if (userData['impact_detected'] == true ||
          userData['impact_detected'] == 1) {
        alertsForUser.add('Impact/fall detected');
        hasAlert = true;
      }

      double temperature = userData['temperature'];
      if (temperature > 40) {
        alertsForUser.add('High temperature: $temperature');
        hasAlert = true;
      }

      double mq135Value = userData['mq135_value'];
      if (mq135Value > 50) {
        alertsForUser.add('Bad Air Quality: ${mq135Value}%');
        hasAlert = true;
      }

      double mq2Value = userData['mq2_value'];
      if (mq2Value > 50) {
        alertsForUser.add('Flammable Gas: ${mq2Value}%');
        hasAlert = true;
      }

      if (hasAlert) {
        final userName = userData['name'];
        final alertsMessage = alertsForUser.join('\n');
        final snackBar = SnackBar(
          content: Text(
            '$userName: $alertsMessage',
            style: TextStyle(
                fontFamily: 'Lato',
                color: sharedData.isNightMode ? Colors.white : Colors.black),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: sharedData.isNightMode
              ? Colors.teal.shade900
              : Colors.orange.shade100,
          action: SnackBarAction(
            label: 'See info',
            onPressed: () {
              sharedData.selectedHelmID = userId;
              sharedData.selectedName = userName;
              _currentIndex = 0;
            },
            textColor: sharedData.isNightMode ? Colors.white : Colors.black,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        alertsForUser.clear();
      }
    });
  }

  //...........................................
  @override
  Widget build(BuildContext context) {
    SharedData sharedData = context.watch<SharedData>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ElevatedButton(
              //     onPressed: () => {showCustomToast()}, child: Text('x')),
              Image.asset(
                context.watch<SharedData>().isNightMode
                    ? 'assets/ssh_logo_teal.png'
                    : 'assets/ssh_logo_orange.png',
                width: 70,
                height: 70,
              ),
              const SizedBox(width: 15),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displayLarge,
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'S',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: 'mart\n'),
                    TextSpan(
                      text: 'S',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: 'afety\n'),
                    TextSpan(
                      text: 'H',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: 'elmet'),
                  ],
                ),
              )
            ]),
        toolbarHeight: 100,
        // backgroundColor: sharedData.isNightMode ? Colors.teal : Colors.orange,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Temperature',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.air_outlined),
            label: 'Smoke',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        backgroundColor: Colors.transparent,
        selectedItemColor:
            sharedData.isNightMode ? Colors.tealAccent : Colors.orangeAccent,
        unselectedItemColor: sharedData.isNightMode
            ? Colors.tealAccent.shade100
            : Colors.orangeAccent.shade100,
        selectedFontSize: 12,
      ),
    );
  }
}

class SharedData with ChangeNotifier {
  bool _isNightMode = false;
  bool _impactDetected = false;
  bool isOnline = false;
  double _temperature = 0;
  double _mq2Value = 0;
  double _mq135Value = 0;
  String _selectedHelmID = '';
  String _selectedName = '';
  List<TemperatureData> _temperatureDataList = [];
  List<SmokeData> _smokeDataList = [];
  List<String> _selectedDates = [];
  Map<String, dynamic> _responseData = {};
  Map<String, dynamic> _usersData = {};
  Map<String, dynamic> _activeUsers = {};

  Map<String, dynamic> get activeUsers => _activeUsers;
  void setActiveUsers(Map<String, dynamic> data) {
    _activeUsers = data;
    notifyListeners();
  }

  bool get isNightMode => _isNightMode;
  set isNightMode(bool value) {
    _isNightMode = value;
    notifyListeners();
  }

  bool get impactDetected => _impactDetected;
  set impactDetected(bool value) {
    _impactDetected = value;
    notifyListeners();
  }

  double get temperature => _temperature;
  set temperature(double value) {
    _temperature = value;
    notifyListeners();
  }

  double get mq2Value => _mq2Value;
  set mq2Value(double value) {
    _mq2Value = value;
    notifyListeners();
  }

  double get mq135Value => _mq135Value;
  set mq135Value(double value) {
    _mq135Value = value;
    notifyListeners();
  }

  String get selectedHelmID => _selectedHelmID;
  set selectedHelmID(String value) {
    _selectedHelmID = value;
    notifyListeners();
  }

  String get selectedName => _selectedName;
  set selectedName(String value) {
    _selectedName = value;
    notifyListeners();
  }

  List<TemperatureData> get temperatureDataList => _temperatureDataList;
  void setTemperatureDataList(List<TemperatureData> data) {
    _temperatureDataList = data;
    notifyListeners();
  }

  List<SmokeData> get smokeDataList => _smokeDataList;
  void setSmokeDataList(List<SmokeData> data) {
    _smokeDataList = data;
    notifyListeners();
  }

  List<String> get selectedDates => _selectedDates;
  void setSelectedDates(List<String> data) {
    _selectedDates = data;
    notifyListeners();
  }

  Map<String, dynamic> get responseData => _responseData;
  void setResponseData(Map<String, dynamic> data) {
    _responseData = data;
    notifyListeners();
  }

  Map<String, dynamic> get usersData => _usersData;
  void setUsersData(Map<String, dynamic> data) {
    _usersData = data;
    notifyListeners();
  }
}

class TemperatureData {
  final DateTime date;
  final double temperature;

  TemperatureData(this.date, this.temperature);
}

class SmokeData {
  final DateTime date;
  final int mq2Level;
  final int mq135Level;

  SmokeData(this.date, this.mq2Level, this.mq135Level);
}
