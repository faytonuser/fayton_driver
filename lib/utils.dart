import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Utils {
  static mergeDateTime(DateTime? date, TimeOfDay? time) {
    return DateTime(date!.year, date.month, date.day, time!.hour, time.minute);
  }

  static String getFormatedDate(String date) {
    return DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(date).toLocal());
  }
}

const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

Color getUserAvatarNameColor(types.User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(types.User user) =>
    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}