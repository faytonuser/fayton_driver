import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notify {
  static Future<bool> instantNotify(int id, String payload) async {


    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return awesomeNotifications.createNotification(
      content: NotificationContent(
          id: id,
          title: "Bildirim",
          body: payload,
          channelKey: 'instant_notification',
   //       notificationLayout: NotificationLayout.BigPicture,
          autoDismissible: false,
          largeIcon: 'assets/icons/passengerr.png',
          displayOnBackground: true,
          displayOnForeground: true,
          wakeUpScreen: true,
          locked: false,
      ),
  /*    actionButtons: [
        if (isTime)
          NotificationActionButton(
              key: 'REDIRECT',
              label: 'Kabul',
              actionType: ActionType.SilentBackgroundAction,
              isDangerousOption: true
          ),
        if (isTime)
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Yoksay',
              actionType: ActionType.SilentBackgroundAction,
              isDangerousOption: false
          )
      ],*/
    );
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {

    if(receivedAction.buttonKeyPressed == 'DISMISS') {

    }
    else if(receivedAction.buttonKeyPressed == 'REDIRECT') {

    }

    else if (receivedAction.actionType == ActionType.Default) {
      if(receivedAction.id == 2) {

      }
      else {
        late SharedPreferences logindata;
        logindata = await SharedPreferences.getInstance();

        //     alertmacid = logindata.getString('payloadmacid');


//        navigatorKey.currentState!.pushNamedAndRemoveUntil('/alert-route', (Route<dynamic> route) => false);
      }
    }
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}