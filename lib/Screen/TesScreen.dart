import 'package:flutter/material.dart';

class TesScreen extends StatefulWidget {
  const TesScreen({super.key});

  @override
  State<TesScreen> createState() => _TesScreenState();
}

class _TesScreenState extends State<TesScreen> {
  bool ligth = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Switch(
        value: ligth,
        onChanged: (bool value) {
          setState(() {
            ligth = value;
          });
        },
      ),
    );
  }
}
