import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spelet_v3/Screen/LoadingScreen.dart';
import 'package:spelet_v3/Screen/LoginScreen.dart';
import 'package:spelet_v3/Screen/NavbarScreen.dart';
import 'package:spelet_v3/Screen/RegisterScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDUcXO7DvLTbf18axRPWaoRAeJB4675guo',
      authDomain: 'https://spelet-2.firebaseapp.com',
      projectId: 'spelet-2',
      storageBucket: 'spelet-2.appspot.com',
      messagingSenderId: '906274384635',
      appId: '1:906274384635:web:58bc9a7374d002c2c61e5e',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
      routes: {
        '/home': (context) => const NavbarScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
