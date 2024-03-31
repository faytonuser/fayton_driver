import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:driver/providers/auth_methods.dart';
import 'package:driver/screens/login_screen.dart';
import 'package:driver/utils.dart';
import 'package:driver/widgets/textfieldinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class EditProfileScreen extends StatefulWidget {
  final editType;
  const EditProfileScreen({
    Key? key,
    required this.editType,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _deletePasswordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  String university = '';
  String bolum = '';

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _deletePasswordController.dispose();
    _oldpasswordController.dispose();
    _usernameController.dispose();
  }

  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  void updateUser() async {

    setState(() {
      _isLoading = true;
    });

    if (widget.editType == 'password') {
      String res = await AuthMethods().settingsUser(
        oldpassword: _oldpasswordController.text,
        newpassword: _passwordController.text,
      );
      // if string returned is sucess, user has been created
      if (res == "Kaydedildi") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        if (context.mounted) {
          showSnackBar(context, res);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen()
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } else if (widget.editType == 'delete') {
      String res = await AuthMethods().settingsUser(
          deletepassword: _deletePasswordController.text
      );
      // if string returned is sucess, user has been created
      if (res == "Kaydedildi") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        if (context.mounted) {
          showSnackBar(context, res);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => LoginScreen()
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    }
    else {
      if (context.mounted) {
        showSnackBar(context, 'error');
      }
    }
  }


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * .96,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Image.asset(
                      'assets/icons/logo.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    widget.editType == 'password' ?
                    Column(
                      children: [
                        TextFieldInput(
                          hintText: 'Mevcut Şifre',
                          textInputType: TextInputType.text,
                          textEditingController: _oldpasswordController,
                          isPass: true,
                        ),
                        SizedBox(height: 8,),
                        TextFieldInput(
                          hintText: 'Yeni Şifre',
                          textInputType: TextInputType.text,
                          textEditingController: _passwordController,
                          isPass: true,
                        ),
                      ],
                    ) :
                    widget.editType == 'delete' ?
                    Column(
                      children: [
                        Text('Hesabınızı silmək üçün parolunuzu daxil edin', style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Red Hat Display'),),
                        SizedBox(height: 16,),
                        TextFieldInput(
                          hintText: 'Şifre',
                          textInputType: TextInputType.text,
                          textEditingController: _deletePasswordController,
                          isPass: true,
                        ),
                      ],
                    ) :
                    const Center(child: Text('No data')),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !_isLoading
                            ?
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                //      width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    color: Colors.grey,
                                  ),
                                  child: const Text(
                                    'Geri dön',
                                  )
                              ),
                            ),
                          ),
                        ) : Container(),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: updateUser,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                // width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                  ),
                                  color: Colors.blue
                                ),
                                child: !_isLoading
                                    ? Text(
                                  widget.editType == 'delete' ? 'Hesabı Kaldır' : 'Kaydet',
                                )
                                    : const CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
