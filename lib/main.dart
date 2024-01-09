import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyHomePage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedData(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Safety Helmet',
        theme: ThemeData(
          primarySwatch: context.watch<SharedData>().isNightMode
              ? Colors.teal
              : Colors.orange,
          brightness: context.watch<SharedData>().isNightMode
              ? Brightness.dark
              : Brightness.light,
        ),
        home: MyHomePage()
        // LoginPage(),
        );
  }
}
