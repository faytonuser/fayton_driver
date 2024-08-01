import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/route_model.dart';

class RouteService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<bool> createRoute({required RouteModel route}) async {
    try {
      var response =
          await firestore.collection("routes").doc().set(route.toJson());
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<RouteModel>> getRouteList(
      String userId, bool isActive) async {
    try {
      List<RouteModel> routes = [];
      var response = await firestore
          .collection('routes')
          .where('driverId', isEqualTo: userId)
          .get();

      response.docs.forEach((element) {
        routes.add(RouteModel.fromJson(
          element.data(),
          element.id,
        ));
      });
      return routes;
    } catch (e) {
      throw Exception(e);
    }
  }
}
