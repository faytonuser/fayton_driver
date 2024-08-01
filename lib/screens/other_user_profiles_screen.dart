// import 'package:driver/widgets/profile_menu.dart';
// import 'package:driver/widgets/profile_picture.dart';
// import 'package:flutter/material.dart';

// class OtherUserProfileScreen extends StatelessWidget {
//   final String userId;
//   const OtherUserProfileScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xff502eb2), Colors.white],
//                 stops: [0.25, 1],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//           Scaffold(
//             backgroundColor: Colors.transparent,
//             body: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Column(
//                 children: [
//                   ProfilePic(
//                       profilePicture: authProvider.currentUser!.profileUrl),
//                   SizedBox(height: 20),
//                   ProfileMenu(
//                     text: "Keçmiş Səyahətlərim",
//                     icon: "assets/icons/User Icon.svg",
//                     press: () => {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => TravelHistoryScreen(),
//                         ),
//                       )
//                     },
//                   ),
//                   // ProfileMenu(
//                   //   text: "Notifications",
//                   //   icon: "assets/icons/Bell.svg",
//                   //   press: () {},
//                   // ),
//                   // ProfileMenu(
//                   //   text: "Settings",
//                   //   icon: "assets/icons/Settings.svg",
//                   //   press: () {},
//                   // ),
//                   // ProfileMenu(
//                   //   text: "Help Center",
//                   //   icon: "assets/icons/Question mark.svg",
//                   //   press: () {},
//                   // ),
//                   // ProfileMenu(
//                   //   text: "Log Out",
//                   //   icon: "assets/icons/Log out.svg",
//                   //   press: () {},
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/models/other_user_model.dart';
import 'package:driver/models/request_model.dart';
import 'package:driver/models/route_model.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/providers/booking_provider.dart';
import 'package:driver/screens/chat_page.dart';
import 'package:driver/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';

class UberProfilePage extends StatefulWidget {
  final String userId;
  final RouteModel route;
  final RequestModel request;

  const UberProfilePage(
      {Key? key,
      required this.userId,
      required this.route,
      required this.request})
      : super(key: key);

  @override
  _UberProfilePageState createState() => _UberProfilePageState();
}

class _UberProfilePageState extends State<UberProfilePage> {
  int status = 0;
  @override
  void initState() {
    var bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    setState(() {
      status = widget.request.status;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bookingProvider.otherUserFuture =
          BookingService.getOtherUserProfile(widget.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bookingProvider = Provider.of<BookingProvider>(context, listen: true);
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<OtherUserModel>(
          future: bookingProvider.otherUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CustomWaitingIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError == false) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      title: Text(
                        snapshot.data!.name + " " + snapshot.data!.familyName,
                        style: const TextStyle(fontSize: 35),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          // Get.to(() => UberProfileEditPage(
                          //     uberProfileController: _uberProfileController));
                        },
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              NetworkImage(snapshot.data!.profileUrl),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var response =
                                      await bookingProvider.acceptRequest(
                                          widget.route.docId,
                                          true,
                                          snapshot.data!.userId);
                                  setState(() {
                                    status = 1;
                                  });
                                  bookingProvider.passengerListFuture =
                                      BookingService.getPassengerList(
                                          widget.route.docId);
                                  if (response == false) {
                                    SnackBar(
                                      content: Text(
                                          "Siz Maksimum Sərnişin Sayısına çatdınız"),
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      color: Colors.grey[100]),
                                  child: Column(
                                    children: [
                                      FaIcon(FontAwesomeIcons.thumbsUp),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        status == 0
                                            ? " qəbul etmək "
                                            : status == 2
                                                ? " qəbul etmək "
                                                : "Qəbul edildi",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var response =
                                      await bookingProvider.acceptRequest(
                                          widget.route.docId,
                                          false,
                                          snapshot.data!.userId);
                                  setState(() {
                                    status = 1;
                                  });
                                  bookingProvider.passengerListFuture =
                                      BookingService.getPassengerList(
                                          widget.route.docId);
                                  setState(() {
                                    status = 2;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      color: Colors.grey[100]),
                                  child: Column(
                                    children: [
                                      FaIcon(FontAwesomeIcons.thumbsDown),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        status == 2
                                            ? "Artıq Rədd edilib"
                                            : " rədd etmək ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 8,
                            color: Colors.grey[100],
                          ),
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.mailBulk),
                            title: Text(
                              "Messages",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            onTap: () async {
                              try {
                                FirebaseChatCore.instance.setConfig(
                                    FirebaseChatCoreConfig(
                                        null, "rooms", "chatUsers"));
                                await FirebaseChatCore.instance
                                    .createUserInFirestore(types.User(
                                        id: authProvider.currentUser!.userId,
                                        firstName:
                                            authProvider.currentUser!.name,
                                        lastName:
                                            authProvider.currentUser!.lastName,
                                        imageUrl: authProvider
                                            .currentUser!.profileUrl));
                                final room =
                                    await FirebaseChatCore.instance.createRoom(
                                  types.User(
                                    id: snapshot.data!.userId,
                                    imageUrl: snapshot.data!.profileUrl,
                                    firstName: snapshot.data!.name,
                                    lastName: snapshot.data!.familyName,
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatPage(room: room),
                                  ),
                                );
                              } catch (e) {
                                throw Exception(e);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          }),
    );
  }
}
