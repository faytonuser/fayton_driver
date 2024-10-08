import 'package:driver/common/custom_text_field.dart';
import 'package:driver/models/state_model.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/providers/route_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class EmailPasswordScreen extends StatefulWidget {
  const EmailPasswordScreen({super.key});

  @override
  State<EmailPasswordScreen> createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  String numberInitialCode = "994";

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var routeProvider = Provider.of<RouteProvider>(context);

    return Scaffold(
      body: authProvider.vehicleDetailStep == true
          ? Center(
              child: Text(
              'Doğrulandı!',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ))
          : Form(
              key: authProvider.emailPasswordFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0, right: 48),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Şəxsiyyət məlumatlarınız alınacaq.",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Provayderinizin məlumatı sürücülük vəsiqəsi məlumatlarına uyğun olmalıdır. Düzgün məlumatları daxil etdiyinizə əmin olun",
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
                        controller: authProvider.emailController,
                        hintText: 'E-poçt',
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 60.0,
                        right: 36,
                        top: 24,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                        ),
                        height: 48,
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              numberInitialCode = number.isoCode.toString();
                            });
                            print(number.phoneNumber.toString() + " onInputChanged");
                            authProvider.selectedPhoneCode = number.dialCode;
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          textAlign: TextAlign.start,
                          countries: ["AZ", "TR"],
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(color: Colors.black),
                          initialValue: PhoneNumber(
                            isoCode: numberInitialCode,
                          ),
                          textFieldController: authProvider.phoneController,
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          validator: null,
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0, right: 48),
                      child: CustomTextField(
                        controller: TextEditingController(text: authProvider.city?.title ?? ""),
                        hintText: "Şəhər",
                        readOnly: true,
                        onTap: () {
                          showMaterialSelectionPicker<StateModel?>(
                            context: context,
                            title: 'Şəhər',
                            items: StateModel.townModels.followedBy(StateModel.villageModels).followedBy(StateModel.subwayStationModels).toList(),
                            transformer: (item) => (item?.title),
                            iconizer: (item) => item?.icon,
                            selectedItem: authProvider.city,
                            cancelText: "Ləğv et",
                            confirmText: "Təsdiqlə",
                            onChanged: (value) => setState(() {
                              authProvider.city = value;
                            }),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0, right: 48),
                      child: CustomTextField(
                        controller: authProvider.signupPasswordController,
                        hintText: 'Şifrə',
                        isSecureText: authProvider.isPasswordVisible ? false : true,
                        suffixIcon: Icon(authProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        suffixIconPressed: () {
                          authProvider.isPasswordVisible = !authProvider.isPasswordVisible;
                        },
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
                        controller: authProvider.signupPasswordAgainController,
                        hintText: 'Yenidən Şifrə',
                        isSecureText: authProvider.isPasswordVisible ? false : true,
                        suffixIcon: Icon(authProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        suffixIconPressed: () {
                          authProvider.isPasswordVisible = !authProvider.isPasswordVisible;
                        },
                        validator: (value) {
                          if (value != authProvider.signupPasswordController.text) {
                            return 'Passwords should match';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0, right: 48),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          "*Şifrə ən az 6 xanali olmalıdır",
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 38,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0, right: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'By signing up, you agree to our ',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = onTermsAndTap,
                                ),
                                TextSpan(
                                  text: ' and confirm that you have read and understood the ',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy for Drivers',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
                                ),
                                TextSpan(
                                  text: ' applicable for your country of operation.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void onTermsAndTap() {
    print('Terms and kelimesine tıklandı!');
    _showOverlay(context, 'Term of use', 'terms_and_conditions');
  }

  void onPrivacyTap() {
    print('privacy and kelimesine tıklandı!');
    _showOverlay(context, 'Privacy policy', 'privacy_policy');
  }

  late OverlayEntry _overlayEntry;

  void _showOverlay(BuildContext context, title, doc) async {
    _overlayEntry = OverlayEntry(
        builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$title - Read carefully',
                              style: GoogleFonts.nunito(),
                            ),
                            IconButton.outlined(
                                onPressed: () {
                                  _removeoverlay();
                                },
                                icon: Icon(Icons.cancel))
                          ],
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: Future.delayed(Duration(milliseconds: 150)).then((value) {
                              return rootBundle.loadString('assets/widgets/$doc.md');
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Markdown(
                                    data: snapshot.data.toString(),
                                  ),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeoverlay() {
    _overlayEntry.remove();
  }
}
