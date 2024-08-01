import 'package:driver/common/assets.dart';
import 'package:driver/common/custom_button.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/screens/camera_overlay_screen.dart';
import 'package:driver/screens/end_driver_license_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FronDriverLicenseScreen extends StatefulWidget {
  const FronDriverLicenseScreen({super.key});

  @override
  State<FronDriverLicenseScreen> createState() =>
      _FronDriverLicenseScreenState();
}

class _FronDriverLicenseScreenState extends State<FronDriverLicenseScreen> {
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
            "Sürücülük vəsiqənizin ön hissəsini yükləyin.",
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
              var response = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CameraOverlayScreen(isFront: true),
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
                        builder: (_) => EndDriverLicenseScreen(),
                      ),
                    );
                  }
                : null,
            child: SizedBox(
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
