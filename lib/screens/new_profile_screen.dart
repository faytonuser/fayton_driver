import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/app_colors.dart';
import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/models/route_model.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/providers/request_provider.dart';
import 'package:driver/providers/route_provider.dart';
import 'package:driver/screens/completed_ride_screen.dart';
import 'package:driver/screens/driver_license_front_screen.dart';
import 'package:driver/screens/profile_widget.dart';
import 'package:driver/services/auth_service.dart';
import 'package:driver/services/root_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'edit_profile_screen.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  @override
  void initState() {
    var routeProvider = Provider.of<RouteProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.setToken();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeProvider.routesFuture =
          RouteService.getRouteList(authProvider.currentUserId() ?? "", true);
    });
    var requestProvider = Provider.of<RequestProvider>(context, listen: false);
    requestProvider.getRequestList(authProvider.currentUser!.userId);
    super.initState();
  }

  String formatDate(timestamp) {
    var now = DateTime.now();
    final Timestamp firebaseTimestamp =
        Timestamp.fromMillisecondsSinceEpoch(timestamp);
    var date = firebaseTimestamp.toDate();
    var difference = now.difference(date);

    if (difference.inDays > 0) {
      return DateFormat.yMMM().format(date);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Şimdi';
    }
  }

  var _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var routeProvider = Provider.of<RouteProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: authProvider.currentUser!.isVerified
                ? Icon(
                    Icons.verified,
                    color: Colors.green,
                  )
                : (authProvider.currentUser!.isVerified == false &&
                        authProvider.currentUser!.isDriverLicenseBackUploaded ==
                            true)
                    ? Icon(
                        Icons.alarm,
                        color: Colors.grey,
                      )
                    : Icon(
                        Icons.verified,
                        color: Colors.grey,
                      ),
            onPressed: () {},
          ),
          backgroundColor: Color(0xff502eb2),
          actions: [
            GestureDetector(
              onTap: () async {
                await auth.FirebaseAuth.instance.signOut();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            )
          ]),
      body: routeProvider.routesFuture == null
          ? Center(
              child: CustomWaitingIndicator(),
            )
          : FutureBuilder<List<RouteModel>>(
              future: routeProvider.routesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CustomWaitingIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasError == false) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff502eb2), Colors.white],
                        stops: [0.25, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                height: 196,
                                width: 196,
                                child: ProfileWidget(
                                  profileUrl:
                                      "https://i0.wp.com/www.cssscript.com/wp-content/uploads/2020/12/Customizable-SVG-Avatar-Generator-In-JavaScript-Avataaars.js.png?fit=438%2C408&ssl=1",
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                width: 196,
                                left: 61,
                                child: Container(
                                  height: 70,
                                  child: CircleAvatar(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/icons/car.png',
                                        //           color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    //  title: const Text('Düzenle'),
                                    contentPadding: EdgeInsets.all(10),
                                    children: <Widget>[
                                      SimpleDialogOption(
                                          padding: const EdgeInsets.all(5),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 5),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Parolunuzu Yeniləyin'),
                                                  Icon(Icons.key)
                                                ],
                                              )),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const EditProfileScreen(
                                                editType: 'password',
                                              );
                                            }));
                                          }),
                                      SimpleDialogOption(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 5),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    'Profil şəklini dəyişdirin'),
                                                Icon(Icons.clear)
                                              ],
                                            )),
                                        onPressed: () async {
                                          var xFile =
                                              await _imagePicker.pickImage(
                                                  source: ImageSource.camera,
                                                  preferredCameraDevice:
                                                      CameraDevice.front);
                                          if (xFile == null) return;

                                          var convertedFile = File(xFile.path);
                                          authProvider.uploadProfilePicture(
                                              convertedFile);

                                          authProvider.currentUser =
                                              await AuthService.getCurrentUser(
                                                  authProvider
                                                      .currentUser!.userId);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      authProvider.currentUser!.isVerified
                                          ? SizedBox()
                                          : (authProvider.currentUser!
                                                      .isDriverLicenseBackUploaded ??
                                                  false)
                                              ? SizedBox()
                                              : SimpleDialogOption(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15,
                                                              horizontal: 5),
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Hesabı Onayla'),
                                                          Icon(Icons.clear)
                                                        ],
                                                      )),
                                                  onPressed: () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            FronDriverLicenseScreen(),
                                                      ),
                                                    );
                                                  }),
                                      SimpleDialogOption(
                                          padding: const EdgeInsets.all(5),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 5),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Hesabı Sil'),
                                                  Icon(Icons.clear)
                                                ],
                                              )),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const EditProfileScreen(
                                                editType: 'delete',
                                              );
                                            }));
                                          }),
                                      SimpleDialogOption(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: const Center(
                                              child: Text(
                                            "Yaxın",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          )),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white70,
                            ),
                            label: Text(
                              authProvider.currentUser!.name.toString() +
                                  " " +
                                  authProvider.currentUser!.lastName.toString(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white70),
                            ),
                          ),
                          Text(
                            authProvider.currentUser!.email.toString(),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black45),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          authProvider
                                                  .currentUser!.vehicleModel ??
                                              "",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          authProvider.currentUser!.vehicleYear
                                                  .toString() ??
                                              "",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          authProvider
                                                  .currentUser!.plateNumber ??
                                              "",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          authProvider.currentUser!.city
                                                  .toString() ??
                                              "",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "📌Avtomobilə minməzdən əvvəl həmişə sərnişinin adını soruşun və təsdiqləyin.",
                              style: GoogleFonts.poppins(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CompletedRideScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.length.toString(),
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text("Rides"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 25,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        authProvider.currentUser!.rating != null
                                            ? "★ " +
                                                authProvider.currentUser!.rating
                                                    .toString()
                                            : "★ 0.0",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text("Rating"),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 25,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Column(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          formatDate(authProvider
                                              .currentUser!
                                              .createdAt!
                                              .millisecondsSinceEpoch),
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        "Member since",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Icon(Icons.favorite_outline),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              "RIDER COMPLIMENTS",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 25,
                            ),
                            child: Container(
                              height: 2,
                              width: 96,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text("An error occured"),
                  );
                }
              },
            ),
    );
  }
}
