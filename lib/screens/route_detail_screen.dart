import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/app_colors.dart';
import 'package:driver/common/app_fonts.dart';
import 'package:driver/common/custom_button.dart';
import 'package:driver/models/request_model.dart';
import 'package:driver/models/route_model.dart';
import 'package:driver/providers/booking_provider.dart';
import 'package:driver/providers/request_provider.dart';
import 'package:driver/screens/chat_page.dart';
import 'package:driver/screens/home_screen.dart';
import 'package:driver/screens/other_user_profiles_screen.dart';
import 'package:driver/screens/travel_history_screen.dart';
import 'package:driver/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:provider/provider.dart';

import '../widgets/notify.dart';

class RouteDetailScreen extends StatefulWidget {
  final RouteModel route;
  RouteDetailScreen({super.key, required this.route});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    setState(() {
      _tabController = TabController(length: 2, vsync: this);
    });
    var bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bookingProvider.passengerListFuture =
          BookingService.getPassengerList(widget.route.docId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bookingProvider = Provider.of<BookingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.route.from + "-" + widget.route.to),
      ),
      body: FutureBuilder<List<RequestModel>>(
          future: bookingProvider.passengerListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Passenger List",
                    style: AppFonts.generalTextThemeBig(AppColors.primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .30,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            'assets/icons/passengerr.png',
              //              color: Colors.black,

                          ),
                        ),
                        Text(
                          snapshot.data!
                              .where((element) => element.status == 1)
                              .length.toString() + "/" + widget.route.maxPassengerCount.toString(),
                          style: AppFonts.generalTextThemeSmall(AppColors.almostBlack),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  TabBar(controller: _tabController, tabs: [
                    Tab(
                      text: "Qəbul edildi",
                    ),
                    Tab(
                      text: "Gözləyənlər",
                    ),
                  ]),
                  Expanded(
                    child: TabBarView(controller: _tabController, children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!
                              .where((element) => element.status == 1)
                              .length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: ListTile(
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: AppColors.primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => UberProfilePage(
                                                userId: snapshot.data!
                                                    .where((element) =>
                                                        element.status == 1)
                                                    .toList()[index]
                                                    .fromUserId,
                                                route: widget.route,
                                                request: snapshot.data![index],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                                title: Text(
                                    snapshot.data![index].fromNameAndSurname),
                                leading: Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(snapshot
                                                  .data![index].fromPicture ==
                                              ""
                                          ? "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png"
                                          : snapshot.data![index].fromPicture),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!
                              .where((element) => element.status == 0)
                              .length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: ListTile(
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: AppColors.primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => UberProfilePage(
                                                userId: snapshot.data!
                                                    .where((element) =>
                                                        element.status == 0)
                                                    .toList()[index]
                                                    .fromUserId,
                                                route: widget.route,
                                                request: snapshot.data![index],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.message,
                                          color: AppColors.primaryColor,
                                        ),
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (_) => ChatPage(),
                                          //   ),
                                          // );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                    snapshot.data![index].fromNameAndSurname),
                                leading: Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(snapshot
                                                  .data![index].fromPicture ==
                                              ""
                                          ? "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png"
                                          : snapshot.data![index].fromPicture),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () async {

                      var response =
                          await bookingProvider.routeComplete(
                          widget.route.docId, true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 48.0, right: 48, bottom: 15, top: 15),
                      child: CustomButton(
                        text: 'Ride Complete',
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("An error occured"),
              );
            }
          }),
    );
  }
}
