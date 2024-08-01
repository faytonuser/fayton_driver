import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String fromDeviceToken;
  final String toDeviceToken;
  final String fromUserId;
  final String fromPicture;
  final String fromNameAndSurname;
  final Timestamp requestTime;
  final String driverId;
  final String docId;
  final int status;
  final String fromLocation;
  final String toLocation;
  final Timestamp fromDate;
  final Timestamp toDate;

  RequestModel({
    required this.fromLocation,
    required this.toLocation,
    required this.fromDate,
    required this.toDate,
    required this.fromDeviceToken,
    required this.toDeviceToken,
    required this.fromUserId,
    required this.fromPicture,
    required this.fromNameAndSurname,
    required this.requestTime,
    required this.driverId,
    required this.docId,
    required this.status,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json, String docId) {
    return RequestModel(
      fromDeviceToken: json['fromDeviceToken'] as String,
      toDeviceToken: json['toDeviceToken'] as String,
      fromUserId: json['fromUserId'] as String,
      fromPicture: json['fromPicture'] as String,
      fromNameAndSurname: json['fromNameAndSurname'] as String,
      requestTime: json['requestTime'] as Timestamp,
      driverId: json["driverId"],
      status: json["status"],
      docId: docId,
      fromLocation: json['fromLocation'],
      toLocation: json['toLocation'],
      fromDate: json["fromDate"],
      toDate: json["toDate"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromDeviceToken': fromDeviceToken,
      'toDeviceToken': toDeviceToken,
      'fromUserId': fromUserId,
      'fromPicture': fromPicture,
      'fromNameAndSurname': fromNameAndSurname,
      'requestTime': requestTime,
      'driverId': driverId,
      'status': status,
      "fromLocation": fromLocation,
      "toLocation": toLocation,
      "fromDate": fromDate,
      "toDate": toDate,
    };
  }
}
