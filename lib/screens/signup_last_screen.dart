import 'dart:io';

import 'package:driver/common/app_colors.dart';
import 'package:driver/common/custom_button.dart';
import 'package:driver/common/custom_text_field.dart';
import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/screens/verification_waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupLastScreen extends StatelessWidget {
  SignupLastScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: Center(
              child: Text(
                "Your provider information should be match with the driver license informations. Please be sure, you entered correct informations",
                style: GoogleFonts.nunito(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: CustomTextField(
              controller: authProvider.nameController,
              hintText: 'Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: CustomTextField(
              controller: authProvider.familyNameController,
              hintText: 'Family Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: CustomTextField(
              controller: authProvider.identityNumberController,
              hintText: 'Identity Number',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: CustomTextField(
              controller: authProvider.plateController,
              hintText: 'Plate Number',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: CustomTextField(
              controller: authProvider.manufaturerController,
              hintText: 'Vehicle Manufacturer',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: CustomTextField(
              readOnly: true,
              validator: (value) {
                if (authProvider.fronDriverLicense == null) {
                  return 'This field is required';
                }
              },
              controller: TextEditingController(
                  text: authProvider.fronDriverLicense?.path ?? ""),
              hintText: 'Front License',
              suffixIcon: const FaIcon(FontAwesomeIcons.file),
              suffixIconPressed: () async {
                try {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  authProvider.fronDriverLicense = File(pickedFile!.path);
                } catch (e) {
                  throw Exception(e);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: CustomTextField(
              controller: TextEditingController(
                  text: authProvider.backDriverLicense?.path ?? ""),
              hintText: 'Back License',
              validator: (value) {
                if (authProvider.backDriverLicense == null) {
                  return 'This field is required';
                }
              },
              readOnly: true,
              suffixIcon: const FaIcon(FontAwesomeIcons.file),
              suffixIconPressed: () async {
                try {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  authProvider.backDriverLicense = File(pickedFile!.path);
                } catch (e) {
                  throw Exception(e);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48),
            child: CustomTextField(
              controller: TextEditingController(
                  text: authProvider.facePhoto?.path ?? ""),
              hintText: 'Face Photo',
              readOnly: true,
              suffixIcon: FaIcon(FontAwesomeIcons.file),
              validator: (value) {
                if (authProvider.facePhoto == null) {
                  return 'This field is required';
                }
                return null;
              },
              suffixIconPressed: () async {
                try {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  authProvider.facePhoto = File(pickedFile!.path);
                } catch (e) {
                  throw Exception(e);
                }
              },
            ),
          ),
          SizedBox(
            height: 100,
          ),
          authProvider.isLoading
              ? Center(
                  child: CustomWaitingIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 48.0, right: 48),
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        var currentUser = await authProvider.addUserToDb();
                        authProvider.currentUser = currentUser;
                        if (currentUser != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerificationWaitingScreen(
                                currentUser: currentUser,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: CustomButton(
                      text: "Send For Verification",
                      backgroundColor: AppColors.primaryColor,
                    ),
                  ),
                )
        ]),
      ),
    );
  }
}
