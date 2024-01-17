import 'package:flutter/material.dart';
import 'package:sshv1/Pages/Login.dart';

import '../MyHomePage.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "\nWe've sent a code to the provided number.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Code',
                    hintText: 'Enter the code',
                    prefixIcon: const Icon(Icons.numbers_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                  child: const Text('Verify'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class VerifyPage extends StatefulWidget {
//   const VerifyPage({super.key});
//
//   @override
//   State<VerifyPage> createState() => _VerifyPageState();
// }
//
// class _VerifyPageState extends State<VerifyPage> {
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }
