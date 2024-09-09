import 'package:driver/common/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final String? assetPath;
  const CustomButton(
      {Key? key,
      required this.text,
      this.backgroundColor,
      this.textColor,
      this.assetPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          text,
          style: AppFonts.generalTextTheme(Colors.white),
        ),
      ),
    );
  } 
}
