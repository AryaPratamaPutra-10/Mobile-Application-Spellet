import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spelet_v3/Screen/HomeScreen.dart';
//import 'package:spelet_v3/Screen/LoginScreen.dart';
//import 'package:spelet_v3/Screen/ProfileScreen.dart';
import 'package:spelet_v3/Screen/SettingScreen.dart';
import 'package:quickalert/quickalert.dart';
//import 'package:spelet_v3/Screen/TesScreen.dart';
import 'package:spelet_v3/Screen/TimerScreen.dart';

class NavbarScreen extends StatefulWidget {
  final bool showLoginSuccess;
  const NavbarScreen({
    super.key,
    this.showLoginSuccess = false,
  });

  @override
  _NavbarScreenState createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen>
    with SingleTickerProviderStateMixin {
  
  int currentTab = 0;
  final List<Widget> screens = [
    const HomeScreen(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();
  
  @override
  void initState() {
    super.initState();
    if (widget.showLoginSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Logged in successfully!',
          showConfirmBtn: false,
        );

        // Automatically dismiss the alert after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);  // Dismiss the QuickAlert
        });
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),

      // Add Timer Button
      //floatingActionButton: FloatingActionButton(
        //shape: const CircleBorder(
          //side: BorderSide(
            //color: Colors.white,
          //),
        //),
        //backgroundColor: Colors.blue,
        //onPressed: () {
          //if (isLoggedIn) {
            //Navigator.of(context).push(
              //MaterialPageRoute(builder: (_) => const ProfileScreen()),
            //);
          //} else {
            //Navigator.of(context).push(
              //MaterialPageRoute(builder: (_) => const LoginScreen()),
            //);
          //}
        //},
        //child: const Icon(
          //Icons.add,
          //color: Colors.white,
        //),
      //),
      //

      // Navigation Bar Button
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //shape: const CircularNotchedRectangle(),
        //notchMargin: 15,
        color: Colors.blue,
        child: Container(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Home Screen
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = const HomeScreen();
                        currentTab = 0;
                      });
                    },
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 10, right: 10, top: 10)),
                      overlayColor: WidgetStatePropertyAll(Colors.blue[400]),
                      shadowColor: WidgetStateColor.transparent,
                      backgroundColor: const WidgetStatePropertyAll(Colors.blue),
                    ),
                    child: currentTab == 0
                        ? const Column(
                            children: [
                              Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          )
                        : const Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                          ),
                  ),
                ],
              ),

              // TimerScreen
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = const TimerScreen();
                        currentTab = 1;
                      });
                    },
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 10, right: 10, top: 10)),
                      overlayColor: WidgetStatePropertyAll(Colors.blue[400]),
                      shadowColor: WidgetStateColor.transparent,
                      backgroundColor: const WidgetStatePropertyAll(Colors.blue),
                    ),
                    icon: currentTab == 1
                        ? const Column(
                            children: [
                              Icon(
                                Icons.watch,
                                color: Colors.white,
                              ),
                              Text(
                                'Timer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          )
                        : const Icon(
                            Icons.watch_outlined,
                            color: Colors.white,
                          ),
                  ),
                ],
              ),

              //SettingScreen
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = const SettingScreen();
                        currentTab = 2;
                      });
                    },
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 10, right: 10, top: 10)),
                      overlayColor: WidgetStatePropertyAll(Colors.blue[400]),
                      shadowColor: WidgetStateColor.transparent,
                      backgroundColor: const WidgetStatePropertyAll(Colors.blue),
                    ),
                    icon: currentTab == 2
                        ? const Column(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              Text(
                                'Settings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          )
                        : const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //
    );
  }
}
