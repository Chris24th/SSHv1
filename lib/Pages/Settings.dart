import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ContactPage.dart';
import '../MyHomePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String mobiNumber = '09274478614';
  bool isEditing = false;
  bool isValidNumber = true;

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
            isEditing
                ? SizedBox(
                    width: 150,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          mobiNumber = value;
                          isValidNumber = _validateMobileNumber(value);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter mobile number',
                        errorText:
                            isValidNumber ? null : 'Invalid mobile number',
                      ),
                    ),
                  )
                : Text(
                    mobiNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
            TextButton(
              onPressed: isValidNumber
                  ? () {
                      setState(() {
                        isEditing ? isEditing = false : isEditing = true;
                      });
                    }
                  : null,
              child: isEditing ? const Text('Save') : const Text('Edit'),
            ),
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

  bool _validateMobileNumber(String value) {
    // Regular expression pattern to validate 11-digit number
    final pattern = r'^[0-9]{11}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
