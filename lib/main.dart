import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/providers/booking_provider.dart';
import 'package:driver/providers/navbar_provider.dart';
import 'package:driver/providers/request_provider.dart';
import 'package:driver/providers/route_provider.dart';
import 'package:driver/screens/splash_screen.dart';
import 'package:driver/services/firebase_helper.dart';
import 'package:driver/services/notification_service.dart';
import 'package:driver/widgets/notify.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHelper.setupFirebase();
  await NotificationService.initializeNotification();
  await FaceCamera.initialize(); //Add this
  await initializeService();

  runApp(const MyApp());

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'instant_notification',
        channelName: 'Basic Instant Notification',
        channelDescription: 'Notification channel that can trigger notification instantly.',
        defaultColor: const Color(0xff32485E),
        importance: NotificationImportance.High,
        playSound: false,
        onlyAlertOnce: false,
        enableVibration: true,
      ),
    ],
  );
  Notify.startListeningNotificationEvents();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: false,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
List<String>? docId;

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  // ignore: unused_local_variable
  String? onstartUserid;
  onstartUserid = preferences.getString('userid').toString();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// OPTIONAL when use custom notification
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    FirebaseFirestore.instance
        .collection('rooms')
        .where('userIds', arrayContainsAny: [FirebaseChatCore.instance.firebaseUser?.uid.toString() ?? ""])
        .snapshots()
        .listen((snapshot) {
          for (var change in snapshot.docChanges) {
            bool notificationSentmessage = false;

            if (change.type == DocumentChangeType.modified && !notificationSentmessage) {
              var modifiedData = change.doc.data();
              print(modifiedData!['userIds'][1]);

              if (!notificationSentmessage) {
                Notify.instantNotify(1, "Yeni mesajınız var");
                notificationSentmessage = true;
              }
            }
          }
        });

    //   print(preferences.getString('userid').toString());
    SharedPreferences preferences = await SharedPreferences.getInstance();

    docId = preferences.getStringList('docId');
    print(preferences.getStringList('docId'));

    if (docId != null) {
      for (String docId in docId!) {
        FirebaseFirestore.instance.collection('routes').doc(docId).collection('requests').snapshots().listen((snapshot) {
          for (var change in snapshot.docChanges) {
            bool notificationSent = false;
            if (change.type == DocumentChangeType.modified) {
              var requestData = change.doc.data();

              var status = requestData?['status'];

              if (status == 0 && !notificationSent) {
                // Bildirimi gönder
                Notify.instantNotify(1, "Yeni sorğu");

                notificationSent = true;
              }
            }
          }
        });
      }
    } else {
      print("Liste boş");
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavbarProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RouteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RequestProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
