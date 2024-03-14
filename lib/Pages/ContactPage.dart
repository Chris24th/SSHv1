import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(onPressed: () {
                Navigator.pop(context);
              }),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Contact Us",
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 20),
                  const Text("Email: brocode.noreply@gmail.com\n"),
                  const Text("Mobile no.: 09123456789"),
                  const SizedBox(height: 50),
                  Text("About Us",
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 20),
                  const Text(
                      "We are Team BroCode. Our aim is to enhance construction safety by implementing Smart Safety Helmet. Through this Mobile App, users can monitor the data collected from the sensors integrated to the Smart Safety Helmet.",
                      textAlign: TextAlign.center),
                ],
              ),
            ],
          )),
    );
  }
}
