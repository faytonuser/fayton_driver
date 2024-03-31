import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/app_fonts.dart';
import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/models/route_model.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/providers/request_provider.dart';
import 'package:driver/providers/route_provider.dart';
import 'package:driver/screens/add_route_screen.dart';
import 'package:driver/screens/route_detail_screen.dart';
import 'package:driver/services/root_service.dart';
import 'package:driver/utils.dart';
import 'package:driver/widgets/notify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late SharedPreferences logindata;
  List<String> existingDocIds = [];
  int requestCount = 0;

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {});
  }

  _backgroundServiceStartStop() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
    setState(() {});
  }

  @override
  void initState() {
    _backgroundServiceStartStop();
    initial();
    checkLocationPermission();
    _checkNotificationPermission();
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

  Future<void> _checkNotificationPermission() async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request().then((value) async {
          await Permission.notification.isGranted.then((value) {

          });
        });
      }
    });
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Kullanıcı daha önce izni reddetmiş, izin iste
      await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      openAppSettings();
    } else {
      _handleCurrentLocation();
    }
  }

  void _handleCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      var locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    var routeProvider = Provider.of<RouteProvider>(context, listen: true);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var response = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddRoutesScreen(),
            ),
          );
          if (response == true) {
            routeProvider.routesFuture = routeProvider.routesFuture =
                RouteService.getRouteList(
                    authProvider.currentUserId() ?? "", true);
          }
        },
        label: Text('Yeni marşrut yaradın'),
        icon: Icon(Icons.add),
      ),
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
                    snapshot.hasError == false &&
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("There is no route"),
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasError == false &&
                    snapshot.data!.isNotEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff502eb2), Colors.white],
                        stops: [0.25, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Hörmətli ${authProvider.currentUser?.name}, Sizin marşurut siyahisi budur",
                            style: AppFonts.generalTextThemeBig(Colors.white),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              if (!existingDocIds.contains(snapshot.data![index].docId)) {
                                existingDocIds.add(snapshot.data![index].docId);
                                logindata.setStringList('docId', existingDocIds);
                                final service = FlutterBackgroundService();
                                service.startService();
                              }
                              return snapshot.data![index].isComplete ?
                            SizedBox.shrink() :
                            Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RouteDetailScreen(
                                          route: snapshot.data![index]),
                                    ),
                                  );
                                },
                                trailing: Icon(Icons.chevron_right, color: Colors.black54,),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${snapshot.data![index].from}-${snapshot.data![index].to}"),
                              /*      snapshot.data![index].maxPassengerCount <= 5 ? Row(
                                      children: List.generate(
                                        snapshot.data![index].maxPassengerCount,
                                            (seatIndex) =>  Container(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                            'assets/icons/passengerr.png',
                                            color: seatIndex >=
                                                snapshot.data![index]
                                                    .remainingPassenger.length
                                                ? Colors.grey
                                                : Colors.green,
                                          ),
                                        ),
                                      ).toList(),
                                    ) : Text('5+'),*/
                                  ],
                                ),
                                subtitle: Text(Utils.getFormatedDate(
                                    snapshot.data![index].startDate.toString()),
                                style: TextStyle(
                                  color: Colors.black54
                                ),),
                              ),
                            );
                            }),
                      ],
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
