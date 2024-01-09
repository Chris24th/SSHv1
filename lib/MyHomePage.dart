import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Pages/HomePage.dart';
import 'Pages/Settings.dart';
import 'Pages/SmokePage.dart';
import 'Pages/TempPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  // Define your pages/screens here
  final List<Widget> _pages = [
    HomePage(),
    TempPage(),
    SmokePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    SharedData sharedData = context.watch<SharedData>();
    return Scaffold(
      backgroundColor: sharedData.isNightMode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                color: context.watch<SharedData>().isNightMode
                    ? Colors.white70
                    : Colors.black54,
                size: 60,
              ),
              SizedBox(width: 15),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: sharedData.isNightMode ? Colors.white : Colors.black,
                  ),
                  children: <TextSpan>[
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
        toolbarHeight: 80,
        // backgroundColor: sharedData.isNightMode ? Colors.teal : Colors.orange,
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove the shadow
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_outlined),
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
            sharedData.isNightMode ? Colors.tealAccent : Colors.orange,
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

  bool get isNightMode => _isNightMode;

  set isNightMode(bool value) {
    _isNightMode = value;
    notifyListeners();
  }
}
