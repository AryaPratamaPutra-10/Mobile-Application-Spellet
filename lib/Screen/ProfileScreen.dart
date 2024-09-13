import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spelet_v3/Screen/NavbarScreen.dart';
//import 'LoginScreen.dart';
//import 'NavbarScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text(
                    //"Username: ${user!.uName ?? 'N/A'}",
                    //style: const TextStyle(fontSize: 18),
                  //),
                  const SizedBox(height: 10),
                  Text(
                    "Email: ${user!.email ?? 'N/A'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Password: ********",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text("Sign Out"),
                  ),
                ],
              ),
      ),
    );
  }
}
