import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../MyHomePage.dart';

class TempPage extends StatefulWidget {
  const TempPage({super.key});

  @override
  State<TempPage> createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  @override
  Widget build(BuildContext context) {
    SharedData sharedData = context.watch<SharedData>();
    return Material(
        child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: 45,
          padding: const EdgeInsets.all(5),
          margin:
              const EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
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
        Container(
            height: 430,
            width: double.maxFinite,
            padding:
                const EdgeInsets.only(top: 20, bottom: 15, left: 10, right: 10),
            margin: const EdgeInsets.all(15),
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
            child: Column(children: [
              const Text("Temperature Chart",
                  style: TextStyle(
                      fontFamily: "Madimi_One",
                      fontSize: 25,
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
                          fontSize: 15,
                          color: Colors.deepOrange,
                          backgroundColor: Colors.white,
                        ),
                        color: Colors.white,
                        axisLineColor: Colors.white,
                        highPointColor: Colors.red,
                        trackball: const SparkChartTrackball(
                          activationMode: SparkChartActivationMode.tap,
                        ),
                        marker: const SparkChartMarker(
                          displayMode: SparkChartMarkerDisplayMode.all,
                        ),
                        labelDisplayMode: SparkChartLabelDisplayMode.high,
                        xValueMapper: (int index) => sharedData
                            .temperatureDataList[index].date
                            .toString(),
                        yValueMapper: (int index) =>
                            sharedData.temperatureDataList[index].temperature,
                        dataCount: sharedData.temperatureDataList.length,
                      ))),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: sharedData.selectedDates.map((time) {
                  return Text(
                    time,
                    style: const TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
            ])),
      ]),
    ));
  }
}
