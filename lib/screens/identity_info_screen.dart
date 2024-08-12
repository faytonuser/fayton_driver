import 'package:driver/common/custom_button.dart';
import 'package:driver/common/custom_text_field.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../common/app_colors.dart';
import '../common/app_fonts.dart';

class IdentityInfoScreen extends StatefulWidget {
  const IdentityInfoScreen({super.key});

  @override
  State<IdentityInfoScreen> createState() => _IdentityInfoScreenState();
}

class _IdentityInfoScreenState extends State<IdentityInfoScreen> {
  List<String> vehicleColorList = ["Blue", "Red", "Yellow", "Black", "White", "Green", "Orange", "Pink", "Brown", "Purple", "Grey"];

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

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
              /**          Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: CustomTextField(
                  inputType: TextInputType.number,
                  controller: authProvider.identityNumberController,
                  hintText: 'Identity Number',
                   validator: (value) {
                     if (value == null || value.isEmpty || value.length > 16) {
                       return 'This field is more than 16 chars';
                     }
                   },
                ),
              ),
              SizedBox(
                height: 8,
              ),*/
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
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: CustomTextField(
                  controller: authProvider.manufaturerController,
                  hintText: 'Avtomobilin istehsalçısı və modeli',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu hissə məcburidir.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: CustomTextField(
                  controller: authProvider.vehicleYearController,
                  inputType: TextInputType.number,
                  hintText: 'Avtomobil ili (Exp. 1994, 2004, 2023..)',
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length > 4) {
                      return 'Avtomobilin ili maksiumum 4 rəqəmli ola bilər.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: CustomTextField(
                  controller: authProvider.vehicleModelController,
                  inputType: TextInputType.text,
                  hintText: 'Avtomobil Modeli (Exp. BMW, Mercedes vb..)',
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length > 15) {
                      return 'This field is more than 15 chars';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 48),
                child: CustomTextField(
                  controller: authProvider.vehicleColorController,
                  inputType: TextInputType.text,
                  hintText: 'Avtomobilin Rəngi',
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length > 12) {
                      return 'This field is more than 12 chars';
                    }
                    return null;
                  },
                ),
              ),
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
