import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyHomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Smart Safety Helmet App',
      theme: ThemeData(
        primarySwatch: context.watch<SharedData>().isNightMode
            ? Colors.teal
            : Colors.orange,
        brightness: context.watch<SharedData>().isNightMode
            ? Brightness.dark
            : Brightness.light,
        fontFamily: 'Lato',
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 20,
              color: context.watch<SharedData>().isNightMode
                  ? Colors.tealAccent
                  : Colors.orange,
              fontFamily: 'Madimi_One'),
          displayMedium: TextStyle(
              fontSize: 17,
              color: context.watch<SharedData>().isNightMode
                  ? Colors.tealAccent
                  : Colors.orange,
              fontFamily: 'Madimi_One'),
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: context.watch<SharedData>().isNightMode
                ? Colors.white
                : Colors.black87,
            elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
        ),
      ),
      home: MyHomePage(),
    );
  }
}
