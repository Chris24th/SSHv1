import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../MyHomePage.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isRunning = true;
  late final WebViewController _controller;

  void initState() {
    super.initState();
    final sharedData = Provider.of<SharedData>(context, listen: false);

    sharedData.selectedHelmID == '001'
        ? (_controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.black)
          ..setNavigationDelegate(
            NavigationDelegate(
              onWebResourceError: (WebResourceError error) {
                print('WebView error: ${error.description}');
                // _controller.loadRequest(Uri.parse('http://192.168.103.188/stream'));
                _controller.loadRequest(
                    Uri.parse('https://gar-sound-duly.ngrok-free.app/stream'));
              },
            ),
          )
          ..loadRequest(
              Uri.parse('https://gar-sound-duly.ngrok-free.app/stream')))
        // ..loadRequest(Uri.parse('http://192.168.103.188/stream')))
        : ((_controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(Colors.black)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onWebResourceError: (WebResourceError error) {
                    print('WebView error: ${error.description}');
                  },
                ),
              )))
            .loadRequest(Uri.parse('https://nostream.no'));
  }

  @override
  Widget build(BuildContext context) {
    final sharedData = Provider.of<SharedData>(context, listen: false);
    return Material(
        child: Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        height: 500,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //CAMERA
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.watch<SharedData>().isNightMode
                        ? Colors.tealAccent
                        : Colors.orangeAccent,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LIVE STREAMING CAMERA',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin:
                          const EdgeInsets.only(top: 30, left: 50, right: 50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: sharedData.isNightMode
                              ? [Colors.teal.shade200, Colors.teal]
                              : [Colors.orangeAccent, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        sharedData.selectedName == ''
                            ? 'No Helmet Selected'
                            : "${sharedData.selectedName}'s Helmet",
                        style: const TextStyle(
                          fontFamily: "Madimi_One",
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.watch<SharedData>().isNightMode
                              ? Colors.tealAccent
                              : Colors.orange,
                          width: 3,
                        ),
                      ),
                      margin: EdgeInsets.only(top: 30, bottom: 40),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi), // Flip vertically
                        child: WebViewWidget(
                          controller: _controller,
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}
