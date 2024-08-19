import 'package:driver/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FaceOverlayScreen extends StatelessWidget {
  const FaceOverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        //flutter_camera_overlay
        // body: SmartFaceCamera(
        //   autoCapture: true,
        //   defaultCameraLens: CameraLens.front,
        //   message: 'Center your face in the square',
        //   onCapture: (File? image) {
        //     authProvider.facePhoto = image;
        //     if (image != null) {
        //       authProvider.lastStep = true;
        //       authProvider.facePhoto = image;
        //       Navigator.pop(context, true);
        //     } else {
        //       Navigator.pop(context, false);
        //     }
        //   },
        // ),
        );
  }
}
