import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spelet_v3/Screen/NavbarScreen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const NavbarScreen(),),);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
        //toolbarHeight: 70,
        //title: Image.asset(
          //'assets/megamendung45x380.png',
          //fit: BoxFit.contain,
          //color: Colors.white,
          //height: 45,
        //),
        //centerTitle: true,
        //backgroundColor: Colors.blue,
      //),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.blue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image(image: image)
            Image.asset(
              'assets/Logo.png',
              width: 321,
              height: 293,
              color: Colors.white,
            ),
          ],
        ),
      ),
      //bottomNavigationBar: BottomAppBar(
        //color: Colors.blue,
        //height: 70,
        //child: Title(
          //color: Colors.blue,
          //child: Image.asset(
            //'assets/megamendung45x380.png',
            //fit: BoxFit.contain,
            //height: 45,
            //color: Colors.white,
          //),
        //),
      //),
    );
  }
}
