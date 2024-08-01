import 'package:another_stepper/dto/stepper_data.dart';
import 'package:driver/common/assets.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/screens/landing_screen.dart';
import 'package:driver/screens/login_screen.dart';
import 'package:driver/screens/new_signup_screen.dart';
import 'package:driver/screens/signup_first_screen.dart';
import 'package:driver/screens/verification_waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('663f64800022cb794a03')
        .setSelfSigned(status: true);
    Future.delayed(const Duration(seconds: 1), () async {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => new LandingScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: null /* add child content here */,
      ),
    );
  }
}
