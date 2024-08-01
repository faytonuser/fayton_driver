import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  final String profileUrl;
  final ImagePicker _picker = ImagePicker();
  ProfileWidget({required this.profileUrl});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0XFF8134AF),
                Color(0XFFDD2A7B),
                Color(0XFFFEDA77),
                Color(0XFFF58529),
              ],
            ),
            shape: BoxShape.circle),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0XFF8134AF),
                  Color(0XFFDD2A7B),
                  Color(0XFFFEDA77),
                  Color(0XFFF58529),
                ],
              ),
              shape: BoxShape.circle),
          margin: EdgeInsets.all(2),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CircleAvatar(
              radius: 96,
              backgroundImage: CachedNetworkImageProvider(
                authProvider.currentUser!.profileUrl ?? "",
              ),
              child: authProvider.currentUser!.profileUrl == ""
                  ? GestureDetector(
                      onTap: () async {
                        var xFile = await _picker.pickImage(
                            source: ImageSource.camera,
                            preferredCameraDevice: CameraDevice.front);
                        if (xFile == null) return;

                        var convertedFile = File(xFile.path);
                        authProvider.uploadProfilePicture(convertedFile);

                        authProvider.currentUser =
                            await AuthService.getCurrentUser(
                                authProvider.currentUser!.userId);
                      },
                      child: authProvider.isLoading
                          ? CustomWaitingIndicator()
                          : Icon(
                              Icons.add,
                              size: 96,
                              color: Colors.black54,
                            ),
                    )
                  : null,
            ),
          ),
        ));
  }
}
