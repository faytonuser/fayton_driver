// import 'package:driver/common/app_colors.dart';
// import 'package:driver/common/custom_button.dart';
// import 'package:driver/providers/auth_provider.dart';
// import 'package:driver/screens/sms_confirmation_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:provider/provider.dart';

// class VerificationScreen extends StatefulWidget {
//   @override
//   _SignupFirstScreenState createState() => _SignupFirstScreenState();
// }

// class _SignupFirstScreenState extends State<VerificationScreen> {
//   final _formKeySignupFirst = GlobalKey<FormState>();

//   bool validateAndSave() {
//     final form = _formKeySignupFirst.currentState;
//     if (form!.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }

//   void validateAndSubmit(BuildContext context) {
//     if (validateAndSave()) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => SmsConfirmationScreen(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var authProvider = Provider.of<AuthProvider>(context);
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           image: DecorationImage(
//             image: AssetImage(
//               'assets/images/login-background.jpg',
//             ),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//                 Colors.black.withOpacity(0.5), BlendMode.dstATop),
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKeySignupFirst,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 25,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 48.0, right: 48),
//                     child: InternationalPhoneNumberInput(
//                       onInputChanged: (PhoneNumber number) {
//                         print(number.phoneNumber);
//                       },
//                       onInputValidated: (bool value) {
//                         print(value);
//                       },
//                       countries: ["TR"],
//                       selectorConfig: SelectorConfig(
//                         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                       ),
//                       ignoreBlank: false,
//                       autoValidateMode: AutovalidateMode.disabled,
//                       selectorTextStyle: TextStyle(color: Colors.black),
//                       initialValue: PhoneNumber(
//                           dialCode: "90", phoneNumber: "555 555 5555"),
//                       textFieldController: authProvider.phoneController,
//                       formatInput: true,
//                       keyboardType: TextInputType.numberWithOptions(
//                           signed: true, decimal: true),
//                       inputBorder: OutlineInputBorder(),
//                       onSaved: (PhoneNumber number) {
//                         print('On Saved: $number');
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 250,
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: GestureDetector(
//                         onTap: () {
//                           _formKeySignupFirst.currentState!.reset();

//                           // Navigator.of(context).pushReplacement(
//                           //   MaterialPageRoute(
//                           //     builder: (context) => LoginScreen(),
//                           //   ),
//                           // );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 48.0, left: 48),
//                           child: GestureDetector(
//                             onTap: () {
//                               authProvider.sendSms(context).then((value) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => SmsConfirmationScreen(token: value,),
//                                   ),
//                                 );
//                               });
//                             },
//                             child: CustomButton(
//                               text: "NEXT",
//                               backgroundColor: AppColors.primaryColor,
//                             ),
//                           ),
//                         )),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future verifyPhoneNumber(BuildContext context) {
//     var authProvider = Provider.of<AuthProvider>(context, listen: false);
//     auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

//     _auth.verifyPhoneNumber(
//         phoneNumber: authProvider.phoneController.text,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (value) {},
//         verificationFailed: (value) {},
//         codeSent: (value, code) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => SmsConfirmationScreen(),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (value) {});

//     throw Exception();
//   }
// }
