import 'package:driver/common/assets.dart';
import 'package:driver/common/custom_button.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/screens/camera_overlay_screen.dart';
import 'package:driver/screens/face_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EndDriverLicenseScreen extends StatefulWidget {
  const EndDriverLicenseScreen({super.key});

  @override
  State<EndDriverLicenseScreen> createState() => _EndDriverLicenseScreenState();
}

class _EndDriverLicenseScreenState extends State<EndDriverLicenseScreen> {
  bool isEnable = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Sürücülük vəsiqənizin arxa hissəsini yükləyin.",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 24,
          ),
          Center(
            child: Image.asset(
              AssetPaths.driverLicense,
              width: 200,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          IconButton(
            onPressed: () async {
              var response = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CameraOverlayScreen(isFront: false),
                ),
              );
              setState(() {
                isEnable = true;
              });
            },
            icon: Icon(
              Icons.camera,
              color: Colors.green,
            ),
          ),
          GestureDetector(
            onTap: isEnable
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacePhotoScreen(),
                      ),
                    );
                  }
                : null,
            child:  SizedBox(
              width: 250,
              child: CustomButton(
                backgroundColor: isEnable ? Colors.green : Colors.grey,
                text: "Devam Et",
                assetPath: AssetPaths.car,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
