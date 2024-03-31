import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/other_user_model.dart';
import 'package:driver/models/request_model.dart';
import 'package:driver/models/route_model.dart';
import 'package:driver/models/user_model.dart';

class BookingService {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<List<RequestModel>> getRequestList(String userId) async {
    try {
      List<RequestModel> _requestList = [];
      var response = await firebaseFirestore
          .collection("drivers")
          .doc(userId)
          .collection("requests")
          .get();

      if (response.docs.isNotEmpty) {
        for (var element in response.docs) {
          _requestList.add(
            RequestModel.fromJson(
              element.data(),
            ),
          );
        }
        return _requestList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<RequestModel>> getPassengerList(String routeId) async {
    try {
      List<RequestModel> _requestList = [];
      var response = await firebaseFirestore
          .collection("routes")
          .doc(routeId)
          .collection("requests")
          .get();

      if (response.docs.isNotEmpty) {
        for (var element in response.docs) {
          _requestList.add(
            RequestModel.fromJson(
              element.data(),
            ),
          );
        }
        return _requestList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<RouteModel> getRoute(String routeId) async {
    try {
      var route =
          await firebaseFirestore.collection("routes").doc(routeId).get();
      if (route.exists) {
        return RouteModel.fromJson(route.data() ?? {}, route.id);
      } else {
        throw Exception("");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<RequestModel>> getRouteRequests(String routeId) async {
    try {
      var routeRequests = await firebaseFirestore
          .collection("routes")
          .doc(routeId)
          .collection("requests")
          .get();
      List<RequestModel> requests = [];

      if (routeRequests.docs.isNotEmpty) {
        for (var routeRequestsaZ in routeRequests.docs) {
          requests.add(
            RequestModel.fromJson(
              routeRequestsaZ.data(),
            ),
          );
        }
        return requests;
      } else {
        throw Exception("");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> updateRequest(
      bool isAccept, String routeId, String fromUserId) async {
    try {
      if (isAccept) {
        var route = await getRoute(routeId);
        var routeRequests = await getPassengerList(routeId);
        // if (routeRequests.length <= route.maxPassengerCount) {
        //   return false;
        // }
        await firebaseFirestore
            .collection("routes")
            .doc(routeId)
            .collection("requests")
            .doc(fromUserId)
            .update(  
          {"status": 1},
        );
        return true;
      } else {
        await firebaseFirestore
            .collection("routes")
            .doc(routeId)
            .collection("requests")
            .doc(fromUserId)
            .update(
          {"status": 2},
        );
        return true;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> updateComplete(
      bool isComplete, String routeId) async {
    try {
      await firebaseFirestore
          .collection("routes")
          .doc(routeId)
          .update(
        {"isComplete": isComplete},
      );
       return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<OtherUserModel> getOtherUserProfile(String userId) async {
    try {
      var response =
          await firebaseFirestore.collection("users").doc(userId).get();
      if (response.exists) {
        return OtherUserModel.fromJson(response.data() ?? {});
      } else {
        throw Exception("Could not found");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
