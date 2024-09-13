import 'package:carousel_slider/carousel_slider.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickalert/quickalert.dart';
import 'package:spelet_v3/Component/ChooseDevice.dart';
import 'package:spelet_v3/Component/Gauge_2/FoodGauge2.dart';
import 'package:spelet_v3/Component/Gauge_2/PhWaterGauge2.dart';
import 'package:spelet_v3/Component/Gauge_2/TemperatureGauge2.dart';
//import 'package:spelet_v3/Screen/TimerScreen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'package:spelet_v3/Screen/LoginScreen.dart';
import 'package:spelet_v3/Screen/TimerScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference userAlarmsRef =
      FirebaseDatabase.instance.ref().child('alarms');

  List<Map<dynamic, dynamic>> userAlarms = [];
  int myCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserAlarms();
  }

  Future<void> fetchUserAlarms() async {
    final user = _auth.currentUser;
    if (user != null) {
      userAlarmsRef
          .orderByChild('userId')
          .equalTo(user.uid)
          .once()
          .then((DatabaseEvent event) {
        List<Map<dynamic, dynamic>> alarms = [];
        var snapshotValue = event.snapshot.value;
        if (snapshotValue is Map) {
          snapshotValue.forEach((key, value) {
            alarms.add(
                {...value, 'key': key}); // Include the key in each alarm map
          });
          setState(() {
            userAlarms = alarms;
          });
        }
      }).catchError((error) {
        print('Error fetching user alarms: $error');
      });
    }
  }

  Future<void> openServo() async {
    const String espUrl =
        'http://192.168.1.6/open_servo'; // Replace <ESP8266_IP> with your ESP8266 IP address

    try {
      final response = await http.get(Uri.parse(espUrl));
      if (response.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Servo opened',
            showConfirmBtn: false,
          );

          // Automatically dismiss the alert after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context); // Dismiss the QuickAlert
          });
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Error connection to device',
            showConfirmBtn: false,
          );

          // Automatically dismiss the alert after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context); // Dismiss the QuickAlert
          });
        });
      }
    } catch (e) {
      // Exception in the request
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Error connection to device',
          showConfirmBtn: false,
        );

        // Automatically dismiss the alert after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context); // Dismiss the QuickAlert
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final user = _auth.currentUser;
    final bool isLoggedIn = user != null;
    //final bool hasAlarms = userAlarms.isNotEmpty;

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
      extendBody: true,
      backgroundColor: Colors.white,
      // App Bar
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Image.asset(
          'assets/Logo2.png',
          fit: BoxFit.contain,
          height: 75,
          color: Colors.blue,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.blue),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      //
      body: ListView(
        children: [
          if (_auth.currentUser != null) ...{
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              // Choose Device Button
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 10],
                color: Colors.blue.shade300,
                strokeWidth: 2,
                child: InkWell(
                  onTap: () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChooseDevice(),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 50,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Choose Devices',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              //
            ),
            //
          } else ...{
            SafeArea(
              child: Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        border: Border.all(color: Colors.blue)
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          devices[index]['image']!,
                          color: Colors.blue,
                        ),
                        title: Text(
                          devices[index]['name']!,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          'IP: ${devices[index]['ip']}',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
            ),
          },

          // Indicator
          Container(
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: const Text(
              'Indicator',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
          //

          // Carousel Indicator
          CarouselSlider(
            items: const [
              FoodGauge2(),
              TemperatureGauge2(),
              PhWaterGauge2(),
            ],
            options: CarouselOptions(
              height: 300,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
          ),
          //

          // Timer List View

          if (!isLoggedIn) ...{
            // Reminder
            Container(
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 10],
                color: Colors.red.shade200,
                strokeWidth: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'You\'re not signed in',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tap to Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //

            // Servo Button
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 10],
                color: Colors.blue.shade300,
                strokeWidth: 2,
                child: InkWell(
                  onTap: openServo,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Servo Button',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            //

          } else ...{
          
          // Timer
          Container(
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: const Text(
              'Timer',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
          //

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userAlarms.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue)
                    ),
                    child: ListTile(
                      title: Text(
                        userAlarms[index]['time'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama Alarm
                          Text(
                            userAlarms[index]['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          //

                          // Hari Alarm
                          Text(
                            userAlarms[index]['days'].map((day) {
                              switch (day) {
                                case 'Sunday':
                                  return 'Sun';
                                case 'Monday':
                                  return 'Mon';
                                case 'Tuesday':
                                  return 'Tue';
                                case 'Wednesday':
                                  return 'Wed';
                                case 'Thursday':
                                  return 'Thu';
                                case 'Friday':
                                  return 'Fri';
                                case 'Saturday':
                                  return 'Sat';
                                default:
                                  return '';
                              }
                            }).join(', '),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                          //
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Get timer button
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 10],
                color: Colors.blue.shade300,
                strokeWidth: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimerScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Get Time Here',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            //
          }
        ],
      ),
    );
  }

  String getDayName(int index) {
    switch (index) {
      case 0:
        return 'sunday';
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      default:
        return '';
    }
  }

  String getDayShortName(int index) {
    switch (index) {
      case 0:
        return 'S';
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      default:
        return '';
    }
  }
}
