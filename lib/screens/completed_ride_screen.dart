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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedRideScreen extends StatefulWidget {
  const CompletedRideScreen({super.key});

  @override
  State<CompletedRideScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CompletedRideScreen> {
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

  @override
  Widget build(BuildContext context) {
    var routeProvider = Provider.of<RouteProvider>(context, listen: true);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text('Tamamlanmış gəzinti'),),
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
            return Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return snapshot.data![index].isComplete ?
                      ListTile(
                  //      trailing: Icon(Icons.chevron_right),
                        title: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${snapshot.data![index].from}-${snapshot.data![index].to}"),
                         /*   snapshot.data![index].maxPassengerCount <= 5 ? Row(
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
                            snapshot.data![index].startDate.toString())),
                      ) : SizedBox.shrink();
                    }),
              ],
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
