
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/providers/booking_provider.dart';
import 'package:driver/screens/message_list_screen.dart';
import 'package:driver/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _UberProfilePageState createState() => _UberProfilePageState();
}

class _UberProfilePageState extends State<ProfileScreen> {
  @override
  void initState() {
    var bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bookingProvider = Provider.of<BookingProvider>(context, listen: true);
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  authProvider.currentUser!.name +
                      " " +
                      authProvider.currentUser!.lastName,
                  style: const TextStyle(fontSize: 35),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    // Get.to(() => UberProfileEditPage(
                    //     uberProfialeController: _uberProfileController));
                  },
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                        "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQrMNU-5ZjCIfjFwRy5_l6P7HjYBJkTqJLlZio0hUG_trb9-nsf"),
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
                          onTap: () async {},
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                color: Colors.grey[100]),
                            child: Column(
                              children: [
                                RatingBar.builder(
                                  itemSize: 36,
                                  initialRating: double.parse(
                                      authProvider.currentUser?.rating ?? "0"),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) async {},
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${authProvider.currentUser?.rating ?? "0"}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                color: Colors.grey[100]),
                            child: Column(
                              children: [
                                Text(
                                  "Plate Number",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  authProvider.currentUser!.plateNumber ?? "",
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MessageListScreen(),
                            ),
                          );
                        } catch (e) {
                          throw Exception(e);
                        }
                      },
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.mailBulk),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      onTap: () async {
                        try {
                          await AuthService.signOut();
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
        ));
  }
}
