import 'package:flutter/material.dart';

class TempPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Temperature chart Page'),
          ]),
    ));
  }
}
