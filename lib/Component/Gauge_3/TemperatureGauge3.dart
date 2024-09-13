import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TemperatureGauge3 extends StatefulWidget {
  const TemperatureGauge3({super.key});

  @override
  State<TemperatureGauge3> createState() => _TemperatureGauge3State();
}

class _TemperatureGauge3State extends State<TemperatureGauge3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 300,
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.topCenter,
      color: Colors.blue,
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 100,
            lineWidth: 20,
            percent: 0.6,
            progressColor: Colors.grey,
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
            center: const Text(
              '60%',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          const Expanded(
            child: SizedBox(
              height: 20,
            ),
          ),
          Divider(),
          const Expanded(
            child: SizedBox(
              height: 20,
            ),
          ),
          const Text(
            'Temperature',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}
