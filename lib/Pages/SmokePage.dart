import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../MyHomePage.dart';

class SmokePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 30, left: 30, bottom: 5, right: 30),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: context.watch<SharedData>().isNightMode
                      ? Colors.tealAccent
                      : Colors.orangeAccent,
                  width: 1,
                ),
              ),
              child: Text("MQ-2",
                  style: Theme.of(context).textTheme.displayLarge)),
        ),
        Expanded(
          child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left: 30, bottom: 30, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: context.watch<SharedData>().isNightMode
                      ? Colors.tealAccent
                      : Colors.orangeAccent,
                  width: 1,
                ),
              ),
              child: Text("MQ-135",
                  style: Theme.of(context).textTheme.displayLarge)),
        ),
      ]),
    ));
  }
}
