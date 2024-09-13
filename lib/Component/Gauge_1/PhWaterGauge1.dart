import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PhWaterGauge1 extends StatefulWidget {
  const PhWaterGauge1({super.key});

  @override
  State<PhWaterGauge1> createState() => _PhWaterGauge1State();
}

class _PhWaterGauge1State extends State<PhWaterGauge1> {
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
            'Ph Water',
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
