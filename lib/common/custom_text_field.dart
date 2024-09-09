import 'package:driver/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final FaIcon? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final String? Function(String? val)? validator;
  final bool? isSecureText;
  final VoidCallback? suffixIconPressed;
  final VoidCallback? prefixIconPressed;
  final bool? enabled;
  final bool? readOnly;
  final int? maxLine;
  final int? maxCharacter;
  final int? minCharacter;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onTextChanged;
  final TextStyle? style;
  final bool? obsucure;

  const CustomTextField({
    Key? key,
    required,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconPressed,
    this.validator,
    this.inputType,
    this.enabled,
    this.suffixIconPressed,
    this.isSecureText,
    this.readOnly,
    this.maxLine,
    this.maxCharacter,
    this.minCharacter,
    this.onTap,
    this.style,
    this.obsucure,
    this.errorText,
    this.onTextChanged,
    this.inputFormatters,
  }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onTextChanged,
      readOnly: readOnly ?? false,
      controller: controller,
      onTap: onTap,
      enabled: enabled,
      validator: validator,
      keyboardType: inputType,
      obscureText: isSecureText ?? false,
      maxLines: maxLine ?? 1,
      maxLength: maxCharacter,
      minLines: 1,
      style: style,
      inputFormatters: inputFormatters ?? null,
      decoration: InputDecoration(
        counterText: "",
        errorText: errorText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 0.5),
        ),
        fillColor: enabled == null ? Colors.white : Colors.grey,
        focusColor: enabled == null ? Colors.white : Colors.grey,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.black54),
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: suffixIconPressed,
                icon: suffixIcon ?? const FaIcon(FontAwesomeIcons.notEqual),
              ),
        prefixIcon: prefixIcon == null
            ? null
            : IconButton(
                onPressed: prefixIconPressed,
                icon: prefixIcon ?? const FaIcon(FontAwesomeIcons.notEqual),
              ),
      ),
    );
  }
}
