import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../MyHomePage.dart';

class SmokePage extends StatefulWidget {
  const SmokePage({super.key});

  @override
  State<SmokePage> createState() => _SmokePageState();
}

class _SmokePageState extends State<SmokePage> {
  @override
  Widget build(BuildContext context) {
    SharedData sharedData = context.watch<SharedData>();
    return Material(
        child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            flex: 2,
            child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                padding: const EdgeInsets.only(
                    top: 20, bottom: 5, left: 10, right: 10),
                margin: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: context.watch<SharedData>().isNightMode
                        ? [Colors.teal.shade300, Colors.teal]
                        : [Colors.orangeAccent, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.watch<SharedData>().isNightMode
                        ? Colors.tealAccent
                        : Colors.orangeAccent,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Text("Flammable Gas Level Chart",
                        style: TextStyle(
                            fontFamily: "Madimi_One",
                            fontSize: 20,
                            color:
                                // context.watch<SharedData>().isNightMode
                                //     ? Colors.black:
                                Colors.white)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SfSparkLineChart.custom(
                          labelStyle: const TextStyle(
                              fontFamily: 'Madimi_One',
                              fontSize: 12,
                              color: Colors.deepOrange,
                              backgroundColor: Colors.white),
                          color: Colors.white,
                          axisLineColor: Colors.white,
                          highPointColor: Colors.red,
                          trackball: const SparkChartTrackball(
                              activationMode: SparkChartActivationMode.tap),
                          marker: const SparkChartMarker(
                            displayMode: SparkChartMarkerDisplayMode.all,
                          ),
                          labelDisplayMode: SparkChartLabelDisplayMode.high,
                          xValueMapper: (int index) =>
                              sharedData.smokeDataList[index].date.toString(),
                          yValueMapper: (int index) =>
                              sharedData.smokeDataList[index].mq2Level,
                          dataCount: sharedData.smokeDataList.length,
                        ),
                      ),
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: sharedData.selectedDates.map((time) {
                        return Text(
                          time,
                          style: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ],
                ))),
        Expanded(
            flex: 2,
            child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                padding: const EdgeInsets.only(
                    top: 20, bottom: 5, left: 10, right: 10),
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: context.watch<SharedData>().isNightMode
                        ? [Colors.teal.shade300, Colors.teal]
                        : [Colors.orangeAccent, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.watch<SharedData>().isNightMode
                        ? Colors.tealAccent
                        : Colors.orangeAccent,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Text("Air Quality Chart",
                        style: TextStyle(
                            fontFamily: "Madimi_One",
                            fontSize: 20,
                            color:
                                // context.watch<SharedData>().isNightMode
                                //     ? Colors.black:
                                Colors.white)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SfSparkLineChart.custom(
                          labelStyle: const TextStyle(
                              fontFamily: 'Madimi_One',
                              fontSize: 12,
                              color: Colors.deepOrange,
                              backgroundColor: Colors.white),
                          color: Colors.white,
                          axisLineColor: Colors.white,
                          highPointColor: Colors.red,
                          trackball: const SparkChartTrackball(
                              activationMode: SparkChartActivationMode.tap),
                          marker: const SparkChartMarker(
                            displayMode: SparkChartMarkerDisplayMode.all,
                          ),
                          labelDisplayMode: SparkChartLabelDisplayMode.high,
                          xValueMapper: (int index) =>
                              sharedData.smokeDataList[index].date.toString(),
                          yValueMapper: (int index) =>
                              sharedData.smokeDataList[index].mq135Level,
                          dataCount: sharedData.smokeDataList.length,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: sharedData.selectedDates.map((time) {
                        return Text(
                          time,
                          style: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ],
                ))),
      ]),
    ));
  }
}
