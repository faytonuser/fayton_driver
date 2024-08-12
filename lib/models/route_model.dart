import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/profile_model.dart';

class RouteModel {
  final DateTime startDate;
  final DateTime endDate;
  final String to;
  final String from;
  final String remainingPassenger;
  final int maxPassengerCount;
  final int journeyDuration;
  final bool isActive;
  final bool isComplete;
  final String driverId;
  final String driverPlate;
  final ProfileModel? profile;
  final String docId;
  final String pricePerPerson;

  RouteModel({
    required this.startDate,
    required this.endDate,
    required this.to,
    required this.from,
    required this.remainingPassenger,
    required this.maxPassengerCount,
    required this.journeyDuration,
    required this.isActive,
    required this.isComplete,
    required this.driverId,
    required this.driverPlate,
    required this.profile,
    required this.docId,
    required this.pricePerPerson,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json, String docId) {
    return RouteModel(
        startDate: DateTime.fromMicrosecondsSinceEpoch(
            (json['startDate'] as Timestamp).microsecondsSinceEpoch),
        endDate: DateTime.fromMicrosecondsSinceEpoch(
            (json['endDate'] as Timestamp).microsecondsSinceEpoch),
        to: json['to'],
        from: json['from'],
        remainingPassenger: json['remainingPassenger'],
        maxPassengerCount: json['maxPassengerCount'],
        journeyDuration: json['journeyDuration'],
        isActive: json['isActive'],
        isComplete: json['isComplete'],
        driverPlate: json['driverPlate'],
        driverId: json['driverId'],
        profile: ProfileModel.fromJson(json['profile']),
        docId: docId,
        pricePerPerson: json['pricePerPerson']);
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'to': to,
      'from': from,
      'remainingPassenger': remainingPassenger,
      'maxPassengerCount': maxPassengerCount,
      'journeyDuration': journeyDuration,
      'isActive': isActive,
      'isComplete': isComplete,
      'driverPlate': driverPlate,
      'driverId': driverId,
      'profile': profile!.toJson(),
      'pricePerPerson': pricePerPerson,
    };
  }
}
