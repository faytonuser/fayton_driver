import 'package:driver/common/assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class CustomWaitingIndicator extends StatelessWidget {
  const CustomWaitingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AssetPaths.waitingIndicator,
      height: 100,
    );
  }
}
