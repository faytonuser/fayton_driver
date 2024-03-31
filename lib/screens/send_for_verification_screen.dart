import 'package:flutter/material.dart';

class SendForVerificationScreen extends StatefulWidget {
  const SendForVerificationScreen({super.key});

  @override
  State<SendForVerificationScreen> createState() =>
      _SendForVerificationScreenState();
}

class _SendForVerificationScreenState extends State<SendForVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Send for verification"),
      ),
    );
  }
}
