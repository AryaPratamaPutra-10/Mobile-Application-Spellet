import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:load_switch/load_switch.dart';
import 'package:quickalert/quickalert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spelet_v3/Screen/LoginScreen.dart';
import 'package:http/http.dart' as http;

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _auth = FirebaseAuth.instance;
  final DatabaseReference userAlarmsRef =
      FirebaseDatabase.instance.ref().child('alarms');

  List<Map<dynamic, dynamic>> userAlarms = [];
  List<bool> selectedDays = List.generate(7, (index) => false);

  @override
  void initState() {
    super.initState();
    fetchUserAlarms();
    _checkAlarms();
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

  void _checkAlarms() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    String currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    userAlarms.forEach((alarm) {
      if (alarm['alarmActive'] == true && alarm['days'].contains(currentWeekday)) {
        if (alarm['time'] == currentTime && now.second < 10) {
          openServo;
        }
      }
    });
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

  void _showAddTimerModal(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay.now();
    TextEditingController nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TimePickerSpinner(
                      alignment: Alignment.center,
                      is24HourMode: true,
                      normalTextStyle:
                          const TextStyle(fontSize: 24, color: Colors.grey),
                      highlightedTextStyle:
                          const TextStyle(fontSize: 24, color: Colors.blue),
                      spacing: 50,
                      itemHeight: 60,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          selectedTime =
                              TimeOfDay(hour: time.hour, minute: time.minute);
                        });
                      },
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Alarm Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text('Repeat'),
                      ],
                    ),
                    Row(
                      children: [
                        Wrap(
                          spacing: 1.5,
                          children: List.generate(7, (index) {
                            return ChoiceChip(
                              label: Text(
                                getDayName(index),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: selectedDays[index],
                              selectedColor: Colors.blue.shade100,
                              backgroundColor: Colors.blue.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              showCheckmark: false,
                              padding: const EdgeInsets.all(5),
                              onSelected: (selected) {
                                setState(() {
                                  selectedDays[index] = selected;
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final user = _auth.currentUser;
                          if (user != null) {
                            await userAlarmsRef.push().set({
                              'time': selectedTime.format(context),
                              'name': nameController.text,
                              'userId': user.uid,
                              'alarmActive': false,
                              'days': getSelectedDays(),
                            });
                            fetchUserAlarms();
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.blue
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<String> getSelectedDays() {
    List<String> days = [];
    if (selectedDays[0]) days.add('Sunday');
    if (selectedDays[1]) days.add('Monday');
    if (selectedDays[2]) days.add('Tuesday');
    if (selectedDays[3]) days.add('Wednesday');
    if (selectedDays[4]) days.add('Thursday');
    if (selectedDays[5]) days.add('Friday');
    if (selectedDays[6]) days.add('Saturday');
    return days;
  }

  String getDayName(int index) {
    switch (index) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return '';
    }
  }

  void _showLoginAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Login Required',
      text: 'Login to add an alarm',
      confirmBtnText: 'OK',
      cancelBtnText: 'Cancel',
      disableBackBtn: false,
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
      },
      onCancelBtnTap: () {},
    );
  }

  void _showAlarmAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Alarm Alert',
      text: 'It\'s time for your alarm!',
      confirmBtnText: 'OK',
      disableBackBtn: false,
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final bool isLoggedIn = user != null;
    //final bool hasAlarms = userAlarms.isNotEmpty;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
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
            icon: const Icon(
              Icons.notifications,
              color: Colors.blue,
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          //Container(
            //height: 150,
            //margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //alignment: Alignment.center,
            //color: Colors.blue,
          //),
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
          } else ...{
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
                              fontSize: 11,
                              color: Colors.blue,
                            ),
                          ),
                          //
                        ],
                      ),
                      trailing: LoadSwitch(
                                  height: 25,
                                  width: 50,
                                  value: userAlarms[index]['alarmActive'] ?? true,
                                  onChange: (value) {
                                    setState(() {
                                      userAlarmsRef
                                          .child(userAlarms[index]['key'])
                                          .update({
                                        'alarmActive': value,
                                      });
                                    });
                                  },
                                  switchDecoration: (value, isActived) =>
                                      BoxDecoration(
                                    color: isActived
                                        ? Colors.blue.shade300
                                        : Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  future: () async {
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    return !userAlarms[index]['alarmActive'];
                                  },
                                  onTap: (v) {
                                    print('Tapping while value is $v');
                                  },
                                ),
                    ),
                  );
                },
              ),
            ),
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
                    final user = _auth.currentUser;
                    if (user == null) {
                      _showLoginAlert(context);
                    } else {
                      _showAddTimerModal(context);
                    }
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
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          }
        ],
      ),
    );
  }
}
