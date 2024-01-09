import 'package:flutter/material.dart';

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
          children: [
            const Text(
              "We've sent a code to the provided number.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: 'Code',
                hintText: 'Enter the sent code',
                prefixIcon: Icon(Icons.numbers_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text('Verify'),
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
