import 'package:flutter/material.dart';
import 'package:driver/models/driver_profile_model.dart';
import 'package:driver/models/request_model_history.dart';
import 'package:driver/services/request_service.dart';

class RequestProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> sendRequest(RequestModel request) async {
    try {
      isLoading = true;
      await RequestService.sendRequestToDriver(request);
      isLoading = false;
      return true;
    } catch (e) {
      isLoading = false;
      throw Exception(e);
    }
  }

  List<RequestModel> _requestList = [];
  List<RequestModel> get requestList => _requestList;
  set requestList(value) {
    _requestList = value;
    notifyListeners();
  }

  getRequestList(String userId) async {
    RequestService.getRequestList(userId).then((value) {
      _requestList = value;
    });
  }

  Future<DriverProfileModel>? _getDriverProfileFuture;
  Future<DriverProfileModel>? get getDriverProfileFuture =>
      _getDriverProfileFuture;
  set getDriverProfileFuture(value) {
    _getDriverProfileFuture = value;
    notifyListeners();
  }
}
