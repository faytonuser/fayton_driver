import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/custom_button.dart';
import 'package:driver/common/custom_text_field.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/widgets/car_model_year_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../common/app_colors.dart';

class IdentityInfoScreen extends StatefulWidget {
  const IdentityInfoScreen({super.key});

  @override
  State<IdentityInfoScreen> createState() => _IdentityInfoScreenState();
}

class _IdentityInfoScreenState extends State<IdentityInfoScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return Scaffold(
      body: Form(
        key: authProvider.identityInfoFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Şəxsi məlumatlar və avtomobilin təfərrüatları",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Sifariş zamanı müştərilərə yalnız adınız və avtomobilinizin təfərrüatları görünür.",
                        style: GoogleFonts.nunito(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: CustomTextField(
                  controller: authProvider.nameController,
                  hintText: 'Ad',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: CustomTextField(
                  controller: authProvider.familyNameController,
                  hintText: 'Soyad',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Radio(
                            value: 'Kişi',
                            groupValue: authProvider.selectedGender,
                            onChanged: (value) {
                              setState(() {
                                authProvider.selectedGender = value.toString();
                              });
                            },
                          ),
                          Text('Kişi'),
                          Spacer(),
                          Container(
                            width: 1,
                            height: 25,
                            color: Colors.grey,
                          ),
                          Spacer(),
                          Radio(
                            value: 'Qadın',
                            groupValue: authProvider.selectedGender,
                            onChanged: (value) {
                              setState(() {
                                authProvider.selectedGender = value.toString();
                              });
                            },
                          ),
                          Text('Qadın'),
                        ],
                      ),
                      Divider(
                        color: AppColors.primaryColor,
                        thickness: 0.5,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: CustomTextField(
                  controller: authProvider.plateController,
                  hintText: 'Avtomobilin seriya nömrəsi',
                  validator: (value) {
                    String pattern = r'^\d{2}[A-Z]{2}\d{3}$';
                    RegExp regExp = RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return 'Mətn daxil edin';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Düzgün format daxil edin: 99BB999';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            DependentDropdowns(),
              SizedBox(
                height: 8,
              ),
              CustomButton(
                text: 'Tamam',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
