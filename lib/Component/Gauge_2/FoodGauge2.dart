import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:http/http.dart' as http;

class FoodGauge2 extends StatefulWidget {
  const FoodGauge2({Key? key}) : super(key: key);

  @override
  State<FoodGauge2> createState() => _FoodGauge2State();
}

class _FoodGauge2State extends State<FoodGauge2> {
  double distance = 0;
  bool isLoading = false;
  String error = '';

  void fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.1.6/distance'));
      if (response.statusCode == 200) {
        setState(() {
          distance = double.parse(response.body);
          error = '';
        });
      } else {
        setState(() {
          error = 'Failed to load distance: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to connect to ESP8266: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
      child: Column(
        children: [
          AnimatedRadialGauge(
            duration: const Duration(seconds: 2),
            curve: Curves.elasticIn,
            radius: 100,
            value: distance,
            axis: const GaugeAxis(
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
              ),
              progressBar: GaugeProgressBar.rounded(
                color: Colors.transparent,
              ),
              segments: [
                GaugeSegment(
                  from: 0,
                  to: 33,
                  color: Colors.red,
                  cornerRadius: Radius.circular(2),
                ),
                GaugeSegment(
                  from: 33,
                  to: 66,
                  color: Colors.yellow,
                  cornerRadius: Radius.circular(2),
                ),
                GaugeSegment(
                  from: 66,
                  to: 100,
                  color: Colors.green,
                  cornerRadius: Radius.circular(2),
                ),
              ],
            ),
          ),
          if (isLoading)
            CircularProgressIndicator() // Tampilkan indikator loading jika sedang memuat
          else if (error.isNotEmpty)
            Text(
              'Error: $error', // Tampilkan pesan error jika terjadi kesalahan
              style: TextStyle(color: Colors.red),
            )
          else
            RadialGaugeLabel(
              value: distance,
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          const Expanded(
            child: SizedBox(
              height: 20,
            ),
          ),
          const Divider(
            color: Colors.blue,
          ),
          const Expanded(
            child: SizedBox(
              height: 20,
            ),
          ),
          const Text(
            'Food',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
