// // ignore_for_file: use_build_context_synchronously

// import 'package:driver/common/waiting_indicator.dart';
// import 'package:driver/providers/auth_provider.dart';
// import 'package:driver/screens/home_screen.dart';
// import 'package:driver/screens/new_signup_screen.dart';
// import 'package:driver/screens/signup_last_screen.dart';
// import 'package:driver/screens/verification_waiting_screen.dart';
// import 'package:driver/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:appwrite/models.dart' as model;

// class SmsConfirmationScreen extends StatefulWidget {
//   final model.Token? token;
//   const SmsConfirmationScreen({Key? key, required this.token})
//       : super(key: key);

//   @override
//   State<SmsConfirmationScreen> createState() => _SmsConfirmationScreenState();
// }

// class _SmsConfirmationScreenState extends State<SmsConfirmationScreen> {
//   @override
//   void initState() {
//     SmsAutoFill().listenForCode;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // SmsAutoFill().unregisterListener();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var authProvider = Provider.of<AuthProvider>(context);
//     return Scaffold(
//       body: Center(
//         child: authProvider.isLoading
//             ? const CustomWaitingIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Doğrulama kodu nömrənizə göndərildi.",
//                     style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 50),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 16.0, right: 16),
//                     child: PinFieldAutoFill(
//                         controller: authProvider.smsCodeController,
//                         decoration: UnderlineDecoration(
//                           textStyle: const TextStyle(
//                               fontSize: 20, color: Colors.black),
//                           colorBuilder:
//                               FixedColorBuilder(Colors.black.withOpacity(0.3)),
//                         ), // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
//                         onCodeSubmitted: (code) async {
//                           auth.FirebaseAuth auth2 = auth.FirebaseAuth.instance;

//                           try {
//                             await authProvider.verifyOTP(
//                                 userId: authProvider.token!.userId, otp: code);

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text("Sms Təsdiqləndi"),
//                               ),
//                             );
//                             authProvider.verifyStep = false;
//                             authProvider.vehicleDetailStep = true;
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => NewSignupScreen()));
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(e.toString()),
//                               ),
//                             );
//                           }

//                           // var _credential = auth.PhoneAuthProvider.credential(
//                           //     verificationId: authProvider.verificationId,
//                           //     smsCode: smsCode);
//                           // auth2
//                           //     .signInWithCredential(_credential)
//                           //     .then((var result) async {
//                           //   // var user = await AuthService.getCurrentUser(
//                           //   //     result.user!.uid);

//                           //   // if (user == null) {
//                           //   //   // ignore: use_build_context_synchronously
//                           //   //   authProvider.verifyStep = false;
//                           //   //   authProvider.vehicleDetailStep = true;
//                           //   //   Navigator.pushReplacement(
//                           //   //       context,
//                           //   //       MaterialPageRoute(
//                           //   //           builder: (context) => NewSignupScreen()));
//                           //   // } else {
//                           //   //   authProvider.currentUser = user;
//                           //   //   if (user.isVerified) {
//                           //   //     Navigator.pushReplacement(
//                           //   //         context,
//                           //   //         MaterialPageRoute(
//                           //   //             builder: (_) => HomeScreen()));
//                           //   //   } else {
//                           //   //     Navigator.pushReplacement(
//                           //   //         context,
//                           //   //         MaterialPageRoute(
//                           //   //             builder: (_) =>
//                           //   //                 VerificationWaitingScreen(
//                           //   //                   currentUser: user,
//                           //   //                 )));
//                           //   //   }
//                           //   // }
//                           // }).catchError((e) {
//                           //   Navigator.pop(context);
//                           //   print(e);
//                           //   ScaffoldMessenger.of(context).showSnackBar(
//                           //     SnackBar(
//                           //       content: Text(e.toString()),
//                           //     ),
//                           //   );
//                           // });
//                         },
//                         onCodeChanged: (code) async {
//                           if (code!.length == 6) {
//                             // FocusScope.of(context).requestFocus(FocusNode());
//                             // var verificationResponse = await authProvider
//                             //     .verifyPhoneNumber(code, widget.smsToken);

//                             // if (authProvider.failure == null) {
//                             //   if (verificationResponse?.authUserData.emailAddress ==
//                             //       null) {
//                             //     // Navigator.push(
//                             //     //   context,
//                             //     //   MaterialPageRoute(
//                             //     //     builder: (_) => CompleteRegistrationScreen(
//                             //     //         smsCode: code,
//                             //     //         verificationCode: verificationResponse!
//                             //     //                 .authUserData.verificationCode ??
//                             //     //             ''),
//                             //     //   ),
//                             //     // );
//                             //   } else {
//                             //     // Navigator.pushReplacement(
//                             //     //   //TODO This line will change
//                             //     //   context,
//                             //     //   MaterialPageRoute(
//                             //     //     builder: (_) => AlreadyRegisteredScreen(
//                             //     //         phoneNumber: verificationResponse!
//                             //     //                 .authUserData.mobilePhone ??
//                             //     //             ''),
//                             //     //   ),
//                             //     // );
//                             //   }
//                             // } else {
//                             //   ScaffoldMessenger.of(context).showSnackBar(
//                             //     SnackBar(
//                             //       content: Text("Ters gitti"),
//                             //     ),
//                             //   );
//                             // }
//                           }
//                         } //code length, default 6
//                         ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
