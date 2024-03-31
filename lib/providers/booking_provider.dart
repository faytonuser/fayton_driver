import 'package:driver/models/other_user_model.dart';
import 'package:driver/models/request_model.dart';
import 'package:driver/services/booking_service.dart';
import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  Future<List<RequestModel>>? _requestListFuture;
  Future<List<RequestModel>>? get requestListFuture => _requestListFuture;
  set requestListFuture(value) {
    _requestListFuture = value;
    notifyListeners();
  }

  Future<List<RequestModel>>? _passengerListFuture;
  Future<List<RequestModel>>? get passengerListFuture => _passengerListFuture;
  set passengerListFuture(value) {
    _passengerListFuture = value;
    notifyListeners();
  }

  Future<OtherUserModel>? _otherUserFuture;
  Future<OtherUserModel>? get otherUserFuture => _otherUserFuture;
  set otherUserFuture(value) {
    _otherUserFuture = value;
    notifyListeners();
  }

  Future<bool> acceptRequest(
      String routeId, bool isAccept, String userId) async {
    try {
      await BookingService.updateRequest(isAccept, routeId, userId);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> routeComplete(
      String routeId, bool isComplete) async {
    try {
      await BookingService.updateComplete(isComplete, routeId);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
