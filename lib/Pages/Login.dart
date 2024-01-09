import 'package:flutter/material.dart';

import 'Verify.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool keepLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo or header here

            SizedBox(height: 20),

            // Email text field
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone number',
                hintText: 'Enter your 11-digit phone number',
                prefixIcon: Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                setState(() {
                  keepLoggedIn = !keepLoggedIn;
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    shape: const OvalBorder(),
                    value: keepLoggedIn,
                    onChanged: (value) {
                      setState(() {
                        keepLoggedIn = value ?? false;
                      });
                    },
                  ),
                  Text('Keep me logged in'),
                ],
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VerifyPage()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
