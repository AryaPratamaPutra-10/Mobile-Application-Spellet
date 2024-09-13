import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChooseDevice extends StatefulWidget {
  const ChooseDevice({super.key});

  @override
  State<ChooseDevice> createState() => _ChooseDeviceState();
}

class _ChooseDeviceState extends State<ChooseDevice> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> devices = [
      {
        'name': 'Spelet 1',
        'ip': '192.168.1.6',
        'image': 'assets/Logo2.png',
      },
      {
        'name': 'Spelet 2',
        'ip': '192.168.1.17',
        'image': 'assets/Logo2.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          'assets/Logo2.png',
          fit: BoxFit.contain,
          height: 75,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return Container(
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: ListTile(
                  leading: Image.asset(
                    devices[index]['image']!,
                    color: Colors.white,
                  ),
                  title: Text(
                    devices[index]['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'IP: ${devices[index]['ip']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  onTap: () async {
                    // Save the selected device to Firestore
                    await _firestore.collection('devices').add({
                      'name': devices[index]['name'],
                      'ip': devices[index]['ip'],
                      'image': devices[index]['image'],
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context, devices[index]);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
