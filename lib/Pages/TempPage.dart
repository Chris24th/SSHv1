import 'package:flutter/material.dart';

class TempPage extends StatelessWidget {
  // final DatabaseHelper dbHelper = DatabaseHelper();
  // String formattedDateTime =
  //     DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  // testImp() async {
  //   await dbHelper.insertUser({
  //     'password': 'your_password',
  //     'phoneNumber': 1234567890,
  //     'username': 'your_username',
  //     'isVerified': 1,
  //   });
  //   await dbHelper.insertSensor({
  //     'userID': 1,
  //     'tempVal': 25.0,
  //     'mq135Val': 0.5,
  //     'isImpactDetected': 0,
  //     'timeRead': formattedDateTime,
  //   });
  //   final List<Map<String, dynamic>> users = await dbHelper.getUsers();
  //   final List<Map<String, dynamic>> sensors = await dbHelper.getSensors();
  //   print('Users: $users');
  //   print('Sensors: $sensors');
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: const Text("Temperature Chart"),
              ),
            ),
            // ElevatedButton(onPressed: testImp, child: Text('Test DB')),
          ]),
    ));
  }
}
