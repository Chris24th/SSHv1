import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../MyHomePage.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    SharedData sharedData = context.watch<SharedData>();
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //CAMERA
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 5),
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
                      'CAMERA',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),
            //TEMP AND GAS
            const SizedBox(height: 20),
            // Expanded(
            //   flex: 3,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       //TEMP
            //       Expanded(
            //         flex: 2,
            //         child: Container(
            //             height: double.maxFinite,
            //             padding: const EdgeInsets.all(5),
            //             margin: const EdgeInsets.only(right: 5),
            //             child: Column(
            //               children: [
            //                 Text(
            //                   "TEMPERATURE",
            //                   style: Theme.of(context).textTheme.displayLarge,
            //                 ),
            //                 Expanded(
            //                     child: SfRadialGauge(
            //                   axes: <RadialAxis>[
            //                     RadialAxis(
            //                       minimum: 30,
            //                       maximum: 40,
            //                       ranges: <GaugeRange>[
            //                         GaugeRange(
            //                           startValue: 30,
            //                           endValue: 40,
            //                           gradient: SweepGradient(
            //                               colors: context
            //                                       .watch<SharedData>()
            //                                       .isNightMode
            //                                   ? <Color>[
            //                                       Colors.tealAccent,
            //                                       Colors.teal
            //                                     ]
            //                                   : <Color>[
            //                                       Colors.orange,
            //                                       Colors.deepOrange
            //                                     ]),
            //                         ),
            //                       ],
            //                       pointers: <GaugePointer>[
            //                         NeedlePointer(
            //                           value: sharedData.temperature ?? 0,
            //                           needleStartWidth: 4,
            //                           needleEndWidth: 4,
            //                           enableAnimation: true,
            //                           animationType: AnimationType.ease,
            //                           animationDuration: 1000,
            //                           needleColor: context
            //                                   .watch<SharedData>()
            //                                   .isNightMode
            //                               ? Colors.tealAccent
            //                               : Colors.deepOrange,
            //                           knobStyle: KnobStyle(
            //                               color: context
            //                                       .watch<SharedData>()
            //                                       .isNightMode
            //                                   ? Colors.tealAccent
            //                                   : Colors.deepOrange),
            //                         ),
            //                       ],
            //                       annotations: <GaugeAnnotation>[
            //                         GaugeAnnotation(
            //                           widget: Text(
            //                             '${sharedData.temperature} °C',
            //                             style: TextStyle(
            //                               fontSize: 20,
            //                               fontWeight: FontWeight.bold,
            //                               color: context
            //                                       .watch<SharedData>()
            //                                       .isNightMode
            //                                   ? Colors.tealAccent
            //                                   : Colors.deepOrange,
            //                             ),
            //                           ),
            //                           angle: 90,
            //                           positionFactor: 1.1,
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 )),
            //               ],
            //             )),
            //       ),
            //       //GAS
            //       Expanded(
            //         flex: 3,
            //         child: Container(
            //             height: double.maxFinite,
            //             padding: const EdgeInsets.all(5),
            //             margin: const EdgeInsets.only(right: 5),
            //             child: Column(
            //               children: [
            //                 Text(
            //                   "GAS LEVELS",
            //                   style: Theme.of(context).textTheme.displayLarge,
            //                 ),
            //                 Expanded(
            //                     child: Row(children: [
            //                   //MQ2
            //                   Expanded(
            //                       child: SfRadialGauge(
            //                     axes: <RadialAxis>[
            //                       RadialAxis(
            //                         minimum: 100,
            //                         maximum: 3000,
            //                         ranges: <GaugeRange>[
            //                           GaugeRange(
            //                             startValue: 100,
            //                             endValue: 3000,
            //                             gradient: SweepGradient(
            //                                 colors: context
            //                                         .watch<SharedData>()
            //                                         .isNightMode
            //                                     ? <Color>[
            //                                         Colors.tealAccent,
            //                                         Colors.teal
            //                                       ]
            //                                     : <Color>[
            //                                         Colors.orange,
            //                                         Colors.deepOrange
            //                                       ]),
            //                           ),
            //                         ],
            //                         pointers: <GaugePointer>[
            //                           NeedlePointer(
            //                             value: sharedData.mq2Value ?? 0,
            //                             needleStartWidth: 4,
            //                             needleEndWidth: 4,
            //                             enableAnimation: true,
            //                             animationType: AnimationType.ease,
            //                             animationDuration: 1000,
            //                             needleColor: context
            //                                     .watch<SharedData>()
            //                                     .isNightMode
            //                                 ? Colors.tealAccent
            //                                 : Colors.deepOrange,
            //                             knobStyle: KnobStyle(
            //                                 color: context
            //                                         .watch<SharedData>()
            //                                         .isNightMode
            //                                     ? Colors.tealAccent
            //                                     : Colors.deepOrange),
            //                           ),
            //                         ],
            //                         annotations: <GaugeAnnotation>[
            //                           GaugeAnnotation(
            //                             widget: Text(
            //                               'MQ-2:\n${sharedData.mq2Value.toInt()}',
            //                               style: TextStyle(
            //                                 fontSize: 15,
            //                                 fontWeight: FontWeight.bold,
            //                                 color: context
            //                                         .watch<SharedData>()
            //                                         .isNightMode
            //                                     ? Colors.tealAccent
            //                                     : Colors.deepOrange,
            //                               ),
            //                               textAlign: TextAlign.center,
            //                             ),
            //                             angle: 90,
            //                             positionFactor: 1.2,
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   )),
            //                   //MQ135
            //                   Expanded(
            //                       child: SfRadialGauge(
            //                     axes: <RadialAxis>[
            //                       RadialAxis(
            //                         minimum: 1000,
            //                         maximum: 3000,
            //                         ranges: <GaugeRange>[
            //                           GaugeRange(
            //                             startValue: 1000,
            //                             endValue: 3000,
            //                             gradient: SweepGradient(
            //                                 colors: context
            //                                         .watch<SharedData>()
            //                                         .isNightMode
            //                                     ? <Color>[
            //                                         Colors.tealAccent,
            //                                         Colors.teal
            //                                       ]
            //                                     : <Color>[
            //                                         Colors.orange,
            //                                         Colors.deepOrange
            //                                       ]),
            //                           ),
            //                         ],
            //                         pointers: <GaugePointer>[
            //                           NeedlePointer(
            //                             value: sharedData.mq135Value ?? 0,
            //                             needleStartWidth: 4,
            //                             needleEndWidth: 4,
            //                             enableAnimation: true,
            //                             animationType: AnimationType.ease,
            //                             animationDuration: 1000,
            //                             needleColor: context
            //                                     .watch<SharedData>()
            //                                     .isNightMode
            //                                 ? Colors.tealAccent
            //                                 : Colors.deepOrange,
            //                             knobStyle: KnobStyle(
            //                                 color: context
            //                                         .watch<SharedData>()
            //                                         .isNightMode
            //                                     ? Colors.tealAccent
            //                                     : Colors.deepOrange),
            //                           ),
            //                         ],
            //                         annotations: <GaugeAnnotation>[
            //                           GaugeAnnotation(
            //                             widget: Text(
            //                               'MQ-135:\n${sharedData.mq135Value.toInt()}',
            //                               style: TextStyle(
            //                                 fontSize: 15,
            //                                 fontWeight: FontWeight.bold,
            //                                 color: context
            //                                         .watch<SharedData>()
            //                                         .isNightMode
            //                                     ? Colors.tealAccent
            //                                     : Colors.deepOrange,
            //                               ),
            //                               textAlign: TextAlign.center,
            //                             ),
            //                             angle: 90,
            //                             positionFactor: 1.2,
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   )),
            //                 ])),
            //               ],
            //             )),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
