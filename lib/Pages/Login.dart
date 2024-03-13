import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../MyHomePage.dart';
import 'Verify.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool keepLoggedIn = false;
  String message = "This is a test message!";
  // String address = "09274478614";
  List<String> recipents = ["09274478614"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.account_circle,
              //   color: context.watch<SharedData>().isNightMode
              //       ? Colors.white70
              //       : Colors.black54,
              //   size: 70,
              // ),
              Image.asset(
                  context.watch<SharedData>().isNightMode
                      ? ('assets/ssh_logo_teal.png')
                      : ('assets/ssh_logo_orange.png'),
                  width: 70,
                  height: 70),
              const SizedBox(width: 15),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    color: context.watch<SharedData>().isNightMode
                        ? Colors.white
                        : Colors.black,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'S',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: 'mart\n'),
                    TextSpan(
                      text: 'S',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: 'afety\n'),
                    TextSpan(
                      text: 'H',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: 'elmet'),
                  ],
                ),
              )
            ]),
        toolbarHeight: 100,
        // backgroundColor: sharedData.isNightMode ? Colors.teal : Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo or header here

            const SizedBox(height: 20),

            // Email text field
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone number',
                hintText: 'Enter your 11-digit phone number',
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

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
                  const Text('Keep me logged in'),
                ],
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  // FirebaseConfig.signInWithPhone("+639274478614", context);
                },
                child: const Text('test sms')),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const VerifyPage()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
