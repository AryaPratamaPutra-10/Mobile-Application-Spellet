import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spelet_v3/Screen/LoginScreen.dart';
import 'package:spelet_v3/Screen/NavbarScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const NavbarScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool isScroller) {
          return [
            SliverAppBar(
              toolbarHeight: 70,
              leading: IconButton(
                style: const ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                icon: const Icon(Icons.arrow_back, color: Colors.transparent),
                onPressed: () {},
              ),
              floating: true,
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
                  style: ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(Colors.blue[50]),
                  ),
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.blue,
                  ),
                ),
              ],
              backgroundColor: Colors.white,
            ),
          ];
        },
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            //Profile
            Container(
              height: 25,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              child: const Text(
                'Profile',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue),
              ),
            ),
            //

            if (_auth.currentUser != null) ...{
              Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Account
                    Container(
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Address
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(),
                            child: user == null 
                            ? Text(
                                "Email: ${user!.email ?? 'N/A'}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                              )
                            : Text(
                                "Email: ${user!.email ?? 'N/A'}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                              )
                          ),
                          //

                          // Connected Device
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Device connected : 1',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          //
                        ],
                      ),
                    ),
                    //

                    // Action Button
                    Container(
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 25,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit,
                              color: Colors.white,
                                size: 15,
                              ),
                              iconAlignment: IconAlignment.end,
                              label: Text(''),
                              style: const ButtonStyle(
                                minimumSize: WidgetStatePropertyAll(Size(10, 20)),
                                backgroundColor: WidgetStatePropertyAll(Colors.blue),
                              ),
                            ),
                          ),
                          Container(
                            height: 25,
                            child: ElevatedButton.icon(
                              onPressed: _signOut,
                              icon: const Icon(Icons.logout,
                              color: Colors.white,
                                size: 15,
                              ),
                              iconAlignment: IconAlignment.end,
                              label: Text(''),
                              style: const ButtonStyle(
                                minimumSize: WidgetStatePropertyAll(Size(10, 20)),
                                backgroundColor: WidgetStatePropertyAll(Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                  ],
                ),
              ),
            } else ...{
              Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 10],
                  color: Colors.red.shade200,
                  strokeWidth: 2,
                  child: InkWell(
                    onTap: () 
                    {
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
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
            },
          ],
        ),
      ),
    );
  }
}
