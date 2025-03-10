import 'package:flutter/material.dart';
import 'package:ristek/pages/navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen Navbar
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeNavbar()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/todoicon.png', // Splah image
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        ),
      ),
      backgroundColor: Colors.white, 
    );
  }
}