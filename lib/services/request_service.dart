import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/request_model_history.dart';
import 'package:driver/models/driver_profile_model.dart';

class RequestService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future sendRequestToDriver(RequestModel request) async {
    try {
      await firestore
          .collection("drivers")
          .doc(request.driverId)
          .collection("requests")
          .doc()
          .set(
            request.toJson(),
          );

      await firestore
          .collection("routes")
          .doc(request.docId)
          .collection("requests")
          .doc(request.fromUserId)
          .set(
            request.toJson(),
          );
      await firestore
          .collection("users")
          .doc(request.fromUserId)
          .collection("requests")
          .doc()
          .set(request.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<DriverProfileModel> getDriver(String driverId) async {
    try {
      var response = await firestore.collection("drivers").doc(driverId).get();

      if (response.exists) {
        return DriverProfileModel.fromJson(response.data() ?? {});
      } else {
        throw Exception("User Could not found");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<RequestModel>> getRequestList(String userId) async {
    try {
      var response = await firestore
          .collection("drivers")
          .doc(userId)
          .collection("requests")
          .get();

      List<RequestModel> _requestList = [];

      for (var element in response.docs) {
        _requestList.add(RequestModel.fromJson(element.data(), element.id));
      }
      return _requestList;
    } catch (e) {
      throw Exception(e);
    }
  }

  static ratingCalculation(
    String driverId,
    double rating,
  ) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('drivers').doc(driverId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(documentReference);

      final lastRatingForTheUser = documentSnapshot.data() as Map;
      String? newRating;
      double? ratingOfUser =
          double.tryParse(lastRatingForTheUser['rating'] ?? "0");

      if (ratingOfUser == 0.0) {
        newRating = rating.toStringAsFixed(2);
      } else {
        double calculateRating = (ratingOfUser! + rating) / 2;
        newRating = calculateRating.toStringAsFixed(2);
      }

      transaction.update(documentReference, {'rating': newRating});
    });
  }
}
