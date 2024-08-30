import 'package:driver/common/app_colors.dart';
import 'package:driver/common/assets.dart';
import 'package:driver/common/custom_button.dart';
import 'package:driver/common/custom_text_field.dart';
import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/screens/custom_navigation_bar.dart';
import 'package:driver/screens/new_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff502eb2), Colors.white],
                stops: [0.25, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 48, right: 48, bottom: 12),
                    child: Image.asset(
                      AssetPaths.logo,
                      width: 250,
                      height: 300,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sürücü",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48),
                    child: CustomTextField(
                      controller: authProvider.emailController,
                      hintText: "E-poçt",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Bu sahə tələb olunur";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return "E-poçt ünvanı doğru deyil";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0, right: 48),
                    child: CustomTextField(
                      controller: authProvider.passwordController,
                      hintText: 'Parol',
                      validator: (value) {
                        if (value == null) {
                          return "Bu sahə tələb olunur";
                        } else if (value.length < 6) {
                          return "Parol minimum 6 simvol olmalıdır";
                        }
                        return null;
                      },
                      isSecureText:
                          authProvider.isPasswordVisible ? false : true,
                      suffixIcon: Icon(authProvider.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      suffixIconPressed: () {
                        authProvider.isPasswordVisible =
                            !authProvider.isPasswordVisible;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          try {
                            var response = await authProvider.signInWithEmail();
                            if (response == true) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CustomNavigationBar(
                                      currentUser: authProvider.currentUser),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                            throw Exception(
                                e.toString().replaceAll("Xəta: ", ""));
                          }
                        }
                      },
                      child: authProvider.isLoading
                          ? Center(
                              child: CustomWaitingIndicator(),
                            )
                          : CustomButton(
                              text: "Daxil ol",
                              backgroundColor: AppColors.primaryColor,
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                        text: "Burda yenisiniz?\n",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewSignupScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomButton(
                        text: "Sürücü olaraq qeydiyyatdan keçin",
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ]),
          ),
        ),
      ),
    );
  }
}
