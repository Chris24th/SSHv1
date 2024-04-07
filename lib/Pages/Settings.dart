import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ContactPage.dart';
import './Login.dart';
import '../MyHomePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final int mobiNumber = 09274478614;

  @override
  Widget build(BuildContext context) {
    SharedData sharedData = context.watch<SharedData>();
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mobiNumber.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            )
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(sharedData.isNightMode
                ? Icons.nights_stay_outlined
                : Icons.nights_stay),
            const Text(
              'Night Mode',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Switch(
              activeColor: Colors.tealAccent,
              value: context.watch<SharedData>().isNightMode,
              onChanged: (value) {
                context.read<SharedData>().isNightMode = value;
              },
            ),
          ],
        ),
        const SizedBox(height: 100),
        TextButton(
            child: const Text('Contact Us'),
            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactPage()),
                  )
                })
      ],
    ));
  }
}
