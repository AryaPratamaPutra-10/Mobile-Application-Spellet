import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class TemperatureGauge2 extends StatefulWidget {
  const TemperatureGauge2({super.key});

  @override
  State<TemperatureGauge2> createState() => _TemperatureGauge2State();
}

class _TemperatureGauge2State extends State<TemperatureGauge2> {
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
            value: 35,
            axis: GaugeAxis(
              min: 0,
              max: 100,
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
                  to: 33,
                  color: Colors.yellow,
                  cornerRadius: Radius.circular(2),
                ),
                GaugeSegment(
                  from: 33,
                  to: 66,
                  color: Colors.orange,
                  cornerRadius: Radius.circular(2),
                ),
                GaugeSegment(
                  from: 66,
                  to: 100,
                  color: Colors.red,
                  cornerRadius: Radius.circular(2),
                ),
              ],
            ),
          ),
          RadialGaugeLabel(
            value: 35,
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
            'Temperature',
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
