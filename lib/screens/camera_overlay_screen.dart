import 'dart:io';

import 'package:camera/camera.dart';
import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/screens/verification_waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CameraOverlayScreen extends StatefulWidget {
  final bool isFront;
  CameraOverlayScreen({super.key, required this.isFront});

  @override
  State<CameraOverlayScreen> createState() => _CameraOverlayScreenState();
}

class _CameraOverlayScreenState extends State<CameraOverlayScreen> {
  OverlayFormat format = OverlayFormat.cardID1;
  int tab = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: FutureBuilder<List<CameraDescription>>(
          future: availableCameras(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CustomWaitingIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return CameraOverlay(
                  snapshot.data!.first, CardOverlay.byFormat(format),
                  (XFile file) {
                if (widget.isFront) {
                  print(file.path);
                  authProvider.fronDriverLicense = File(file.path);
                } else {
                  authProvider.backDriverLicense = File(file.path);
                }

                Navigator.pop(context);
              },
                  info:
                      'Şəxsiyyət vəsiqənizi düzbucaqlı içərisinə yerləşdirin və şəklin mükəmməl oxuna biləcəyinə əmin olun.',
                  label: 'Şəxsiyyət vəsiqəsi skan edilir');
            } else {
              return Center(
                child: Text("An error occured"),
              );
            }
          }),
    );
  }
}
