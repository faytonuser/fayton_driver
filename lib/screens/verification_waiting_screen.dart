import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/app_colors.dart';
import 'package:driver/common/app_fonts.dart';
import 'package:driver/common/assets.dart';
import 'package:driver/common/custom_button.dart';
import 'package:driver/common/custom_text_field.dart';
import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/models/profile_model.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VerificationWaitingScreen extends StatefulWidget {
  const VerificationWaitingScreen({super.key, required this.currentUser});
  final ProfileModel? currentUser;
  @override
  State<VerificationWaitingScreen> createState() =>
      _VerificationWaitingScreenState();
}

class _VerificationWaitingScreenState extends State<VerificationWaitingScreen> {
  @override
  void initState() {
  //  updateDriverIsVerified();
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider.currentUser = widget.currentUser;
    });
    super.initState();
  }

  void updateDriverIsVerified() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider.currentUser = widget.currentUser;
    });
    try {
      // Firestore instance'ı oluşturun
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // drivers koleksiyonundaki belirli belgeyi alın
      DocumentReference driverRef = firestore.collection('drivers').
      doc(authProvider.currentUser!.userId);

      // Belgeyi güncelleyin
      await driverRef.update({'isVerified': true});

      print('Driver isVerified updated successfully!');
    } catch (e) {
      print('Error updating driver isVerified: $e');
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    Timer(Duration(seconds: 3), () {
      try {
        // Firestore instance'ı oluşturun
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // drivers koleksiyonundaki belirli belgeyi alın
        DocumentReference driverRef = firestore.collection('drivers').
        doc(authProvider.currentUser!.userId);

        // Belgeyi güncelleyin
        driverRef.update({'isVerified': true});

        print('Driver isVerified updated successfully!');
      } catch (e) {
        print('Error updating driver isVerified: $e');
      }
    });


    return Scaffold(
      body: authProvider.currentUser == null
          ? Center(
              child: CustomWaitingIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(AssetPaths.logo),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 48.0, right: 48),
                    child: Text(
                      'Hörmətli ${authProvider.currentUser!.name} gözləmə siyahısındasınız, yoxlama tamamlandıqdan sonra sizi xəbərdar edəcəyik.',
                      style: AppFonts.generalTextTheme(Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            _sendEmail();
                      /*      var result = await OpenMailApp.openMailApp();

                            // If no mail apps found, show error
                            if (!result.didOpen && !result.canOpen) {
                              showNoMailAppsDialog(
                                context,
                              );

                              // iOS: if multiple mail apps found, show dialog to select.
                              // There is no native intent/default app system in iOS so
                              // you have to do it yourself.
                            } else if (!result.didOpen && result.canOpen) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return MailAppPickerDialog(
                                    mailApps: result.options,
                                    title: "Plaese write your message",
                                    emailContent: EmailContent(
                                        to: ["shamkhal@gmail.com"],
                                        body: "Please send your message"),
                                        

                                  );
                                },
                              );
                            }*/
                            // showModalBottomSheet(
                            //     context: context,
                            //     builder: (context) {
                            //       return Column(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Container(
                            //             height: 120,
                            //             width: double.infinity,
                            //             child: Padding(
                            //               padding: const EdgeInsets.only(
                            //                   right: 48.0, left: 48, top: 12),
                            //               child: CustomTextField(
                            //                   controller: authProvider
                            //                       .supportMailController,
                            //                   maxLine: 5,
                            //                   hintText: 'Support Message'),
                            //             ),
                            //           ),
                            //           Padding(
                            //             padding: const EdgeInsets.only(
                            //                 right: 48.0,
                            //                 left: 48,
                            //                 top: 12,
                            //                 bottom: 48),
                            //             child: CustomButton(
                            //               text: "Send",
                            //               backgroundColor:
                            //                   AppColors.primaryColor,
                            //             ),
                            //           )
                            //         ],
                            //       );
                            //     });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 48.0, right: 48),
                            child: CustomButton(
                              text: 'Bizə e-poçt göndərin',
                              backgroundColor: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void _sendEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    // Mailto URL'sini oluştur
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'faytondriver@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Yoxlayın',
        'body': 'Mənə dəstək lazımdır'
      }),
    );

    // URL'yi başlat
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      // Eğer URL başlatılamazsa, bir hata mesajı göster
      print('Mail gönderme başarısız!');
    }
  }
}
