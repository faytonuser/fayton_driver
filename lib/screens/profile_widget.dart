import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  final String profileUrl;
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
            ),
          ),
        ));
  }
}
