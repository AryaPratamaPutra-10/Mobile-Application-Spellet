import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class PhWaterGauge2 extends StatefulWidget {
  const PhWaterGauge2({super.key});

  @override
  State<PhWaterGauge2> createState() => _PhWaterGauge2State();
}

class _PhWaterGauge2State extends State<PhWaterGauge2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue),
        color: Colors.white,
      ),
      child: const Column(
        children: [
          AnimatedRadialGauge(
            duration: Duration(seconds: 2),
            curve: Curves.elasticIn,
            radius: 100,
            value: 5,
            axis: GaugeAxis(
              min: 0,
              max: 10,
              degrees: 280,
              style: GaugeAxisStyle(
                thickness: 20,
                background: Colors.white,
                segmentSpacing: 0,
              ),
              pointer: GaugePointer.needle(
                width: 15,
                height: 60,
                color: Colors.black,
                position: GaugePointerPosition.center(),
                //border: GaugePointerBorder(color: Colors.white, width: 2)
              ),
              progressBar: GaugeProgressBar.rounded(
                color: Colors.transparent,
              ),
              segments: [
                GaugeSegment(
                  from: 0,
                  to: 3.3,
                  color: Colors.yellow,
                  cornerRadius: Radius.circular(2),
                ),
                GaugeSegment(
                  from: 3.3,
                  to: 6.6,
                  color: Colors.orange,
                  cornerRadius: Radius.circular(2),
                ),
                GaugeSegment(
                  from: 6.6,
                  to: 10,
                  color: Colors.red,
                  cornerRadius: Radius.circular(2),
                ),
              ],
            ),
          ),
          RadialGaugeLabel(
            value: 5,
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: SizedBox(
              height: 20,
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
          Expanded(
            child: SizedBox(
              height: 20,
            ),
          ),
          Text(
            'Ph Water',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blue
            ),
          ),
        ],
      ),
    );
  }
}
