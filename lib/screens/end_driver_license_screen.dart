import 'package:driver/common/assets.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/screens/camera_overlay_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EndDriverLicenseScreen extends StatelessWidget {
  const EndDriverLicenseScreen({super.key});

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
              if (response != true) {
                authProvider.activeStep = 2;
              }
            },
            icon: Icon(
              Icons.camera,
              color: Colors.green,
            ),
          ),
        ],
      )),
    );
  }
}
