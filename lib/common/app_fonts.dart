import 'package:driver/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle? generalTextTheme(Color? color) {
    return GoogleFonts.inter(color: color);
  }

  static TextStyle? mediumTextTheme(Color? color) {
    return GoogleFonts.inter(color: color, fontSize: 18);
  }

  static TextStyle? smallTextTheme(Color? color) {
    return GoogleFonts.inter(color: color, fontSize: 14);
  }

  static TextStyle? smallText400(Color? color) {
    return GoogleFonts.inter(color: color, fontSize: 14);
  }

  static TextStyle? mediumTextThemeBold(Color? color) {
    return GoogleFonts.inter(color: color, fontWeight: FontWeight.w500, fontSize: 16);
  }

  static TextStyle? generalTextThemeBold(Color? color) {
    return GoogleFonts.inter(color: color, fontWeight: FontWeight.bold);
  }

  static TextStyle? generalTextThemeWithTransparancy(Color? color) {
    return GoogleFonts.inter(
      color: color?.withOpacity(0.3) ?? Colors.black,
    );
  }

  static TextStyle? generalTextThemeSmall(Color? color) {
    return GoogleFonts.inter(
      color: color,
      fontSize: 12,
    );
  }

  static TextStyle? generalTextThemeExtraSmall(Color? color) {
    return GoogleFonts.inter(
      color: color,
      fontSize: 10,
    );
  }

  static TextStyle? generalTextThemeBig(Color? color) {
    return GoogleFonts.inter(
      color: color,
      fontSize: 18,
    );
  }

  static TextStyle? generalTextThemeSmallBold(Color? color) {
    return GoogleFonts.inter(
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle? generalTextThemeExtraSmallBold(Color? color) {
    return GoogleFonts.inter(
      color: color,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle? selectedTabColor(Color? color) {
    return GoogleFonts.inter(color: color?.withOpacity(0.3) ?? AppColors.primaryColor, fontWeight: FontWeight.bold);
  }

  static TextStyle? errorMessage(Color? color) {
    return GoogleFonts.ubuntuCondensed(
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle? redBoldText(Color? color) {
    return GoogleFonts.ubuntuCondensed(
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    );
  }
}
