import 'package:driver/common/globals.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/screens/email_password_screen.dart';
import 'package:driver/screens/identity_info_screen.dart';
import 'package:driver/screens/verification_waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:provider/provider.dart';

class NewSignupScreen extends StatelessWidget {
  NewSignupScreen({super.key});

  final LoadingButtonController _btnController = LoadingButtonController();

  void buttonPressed(BuildContext context) async {
    Future.delayed(const Duration(seconds: 1), () {
      _btnController.success();
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IdentityInfoScreen(),
          ),
        );
        _btnController.reset();
      });
    });
  }

  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (_pageController.page! > 0) {
              _pageController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20,
          ),
        ),
      ),
      body: SizedBox(
        // width: 100,
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int index) {
                  authProvider.currentPageIndex = index;
                  if (index == 0) {
                  } else if (index == 1) {
                    authProvider.verifyStep = false;
                    authProvider.vehicleDetailStep = true;
                  } else if (index == 2) {
                    // authProvider.verifySecondStep = false;
                    // authProvider.vehicleDetailStep = true;
                  } else if (index == 3) {
                    // authProvider.vehicleDetailStep = false;
                    // authProvider.driverBackStep = true;
                  } else if (index == 4) {
                    // authProvider.vehicleDetailStep = false;
                    // authProvider.driverBackStep = false;
                    // authProvider.driverFrontStep = true;
                  } else if (index == 5) {
                    // authProvider.vehicleDetailStep = false;
                    // authProvider.driverFrontStep = false;
                    // authProvider.lastStep = true;
                  } else {
                    authProvider.lastStep = false;
                    authProvider.verifyStep = false;
                    authProvider.verifySecondStep = false;
                    authProvider.vehicleDetailStep = false;
                    authProvider.driverBackStep = false;
                    authProvider.driverFrontStep = false;
                    // print("verifySecondStep ${authProvider.lastStep}");
                    // print("verifyStep ${authProvider.verifyStep}");
                    // print("verifySecondStep ${authProvider.verifySecondStep}");
                    // print("vehicleDetailStep ${authProvider.vehicleDetailStep}");
                    // print("driverFrontStep ${authProvider.driverFrontStep}");
                  }
                },
                controller: _pageController,
                children: [
                  EmailPasswordScreen(),
                  // SmsConfirmationScreen(token: null,),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IdentityInfoScreen(),
                    ),
                    height: 250,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            ArgonButton(
              height: 50,
              width: 150,
              borderRadius: 5.0,
              color: Colors.green,
              child: Center(
                child: Text(
                  authProvider.lastStep
                      ? "Bitdi"
                      : authProvider.verifyStep
                          ? "Davam et"
                          : "Davam et",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
              loader: Container(
                padding: EdgeInsets.all(10),
                child: SpinKitRotatingCircle(
                  color: Colors.white,
                ),
              ),
              onTap: (startLoading, stopLoading, btnState) async {
                await authProvider.checkIfEmailExists();
                await authProvider.isPhoneNumberExists();
                try {
                  startLoading();
                  if (authProvider.currentPageIndex == 0) {
                    if (isEmailFieldValid &&
                        isPhoneNumberValid &&
                        isCityValid &&
                        isPasswordValid &&
                        isPasswordConfirmationValid &&
                        !isEmailAlreadyUsed &&
                        !isPhoneNumberAlreadyExists) {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                      authProvider.activeStep = _pageController.page?.toInt();
                      // print("HAL HAZIRKİ SƏHİFƏƏƏ ${authProvider.currentPageIndex}");
                    } else if (!isEmailFieldValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Zəhmət olmasa, email daxil edin'),
                        ),
                      );
                    } else if (!isPhoneNumberValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Zəhmət olmasa, nömrəni daxil edin.'),
                        ),
                      );
                    } else if (!isCityValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Zəhmət olmasa, yaşadığınız şəhəri seçin.'),
                        ),
                      );
                    } else if (!isPasswordValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Zəhmət olmasa, parol daxil edin.'),
                        ),
                      );
                    } else if (!isPasswordConfirmationValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Zəhmət olmasa, parolu yenidən daxil edin.'),
                        ),
                      );
                    } else if (isEmailAlreadyUsed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Bu email ilə artıq qeydiyyat mövcuddur.'),
                        ),
                      );
                    } else if (isPhoneNumberAlreadyExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Bu nömrə ilə artıq qeydiyyat mövcuddur.'),
                        ),
                      );
                    }
                  } else if (authProvider.driverBackStep == true) {
                    if (authProvider.backDriverLicense != null) {
                      _pageController.nextPage(
                          duration: Duration(seconds: 1), curve: Curves.easeIn);
                      authProvider.activeStep = _pageController.page?.toInt();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Sürücülük vəsiqənizin arxa hissəsini yükləyin!')),
                      );
                    }
                  } else if (authProvider.driverFrontStep == true) {
                    if (authProvider.fronDriverLicense != null) {
                      _pageController.nextPage(
                          duration: Duration(seconds: 1), curve: Curves.easeIn);
                      authProvider.activeStep = _pageController.page?.toInt();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Sürücülük vəsiqənizin ön hissəsini yükləyin!')),
                      );
                    }
                  } else if (authProvider.verifySecondStep == true) {
                    if (authProvider.vehicleDetailStep == true) {
                      authProvider.verifySecondStep = false;
                      _pageController.jumpToPage(2);
                      authProvider.activeStep = _pageController.page?.toInt();
                    }
                  } else if (authProvider.vehicleDetailStep == true) {
                    if (authProvider.identityInfoFormKey.currentState != null &&
                        authProvider.identityInfoFormKey.currentState!
                            .validate() &&
                        isCarFormValid &&
                        isGenderSelected) {
                      var response = await authProvider.addUserToDb();
                      if (response != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerificationWaitingScreen(
                                currentUser: authProvider.currentUser),
                          ),
                          (route) => false,
                        );
                      }
                    } else if (!isGenderSelected) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Zəhmət olmasa, cinsinizi seçin"),
                        ),
                      );
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Zəhmət olmasa, bütün sahələri düzgün doldurun"),
                        ),
                      );
                    }
                  } else if (authProvider.lastStep == true) {
                    if (authProvider.facePhoto != null) {
                      if (authProvider.fronDriverLicense != null &&
                          authProvider.backDriverLicense != null) {
                        var response = await authProvider.addUserToDb();
                        if (response != null) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerificationWaitingScreen(
                                  currentUser: authProvider.currentUser),
                            ),
                            (route) => false,
                          );
                        }
                        stopLoading();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tam məlumat daxil edin")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Üzünüzün şəklini çəkin")),
                      );
                    }
                  } else {
                    _pageController.nextPage(
                        duration: Duration(seconds: 1), curve: Curves.easeIn);
                    authProvider.activeStep = _pageController.page?.toInt();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                } finally {
                  stopLoading();
                }
              },
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  String info(int index) {
    switch (index) {
      case 1:
        return 'Educational Background';
      case 2:
        return 'Professional Background';
      case 3:
        return 'Hobbies';
      case 4:
        return 'Medical History';
      case 5:
        return 'Payment';
      default:
        return 'Welcome';
    }
  }
}
