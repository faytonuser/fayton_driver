// import 'package:driver/common/assets.dart';
// import 'package:driver/common/custom_button.dart';
// import 'package:driver/common/waiting_indicator.dart';
// import 'package:driver/providers/auth_provider.dart';
// import 'package:driver/screens/face_overlay_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
//
// class FacePhotoScreen extends StatefulWidget {
//   const FacePhotoScreen({super.key});
//
//   @override
//   State<FacePhotoScreen> createState() => _FacePhotoScreenState();
// }
//
// class _FacePhotoScreenState extends State<FacePhotoScreen> {
//   bool isEnable = false;
//   @override
//   void initState() {
//     var authProvider = Provider.of<AuthProvider>(context, listen: false);
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       authProvider.lastStep = true;
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var authProvider = Provider.of<AuthProvider>(context);
//
//     return Scaffold(
//       body: SafeArea(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "Üzünüzün şəklini çəkin",
//             style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 24,
//           ),
//           Center(
//             child: Image.asset(
//               AssetPaths.faceDetection,
//               width: 200,
//             ),
//           ),
//           SizedBox(
//             height: 24,
//           ),
//           IconButton(
//             onPressed: () async {
//               var response = Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => FaceOverlayScreen(),
//                 ),
//               );
//
//               setState(() {
//                 isEnable = true;
//               });
//             },
//             icon: Icon(
//               Icons.camera,
//               color: Colors.green,
//             ),
//           ),
//           GestureDetector(
//             onTap: isEnable
//                 ? () async {
//                     await authProvider.updateUserToDb();
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             "Sənədləriniz uğurla yükləndi. Qısa müddətdə təsdiqlənəcəkdir."),
//                       ),
//                     );
//                     Navigator.popUntil(context, (route) => route.isFirst);
//                   }
//                 : null,
//             child: authProvider.isLoading
//                 ? CustomWaitingIndicator()
//                 : SizedBox(
//                     width: 250,
//                     child: CustomButton(
//                       backgroundColor: isEnable ? Colors.green : Colors.grey,
//                       text: "Tamam",
//                       assetPath: AssetPaths.car,
//                     ),
//                   ),
//           ),
//         ],
//       )),
//     );
//   }
// }
