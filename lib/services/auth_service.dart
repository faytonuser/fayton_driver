import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/profile_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AppUser {
  AppUser({
    required this.uid,
  });
  final String uid;
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class AuthService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<ProfileModel?> getCurrentUser(String userId) async {
    try {
      var user = await firestore.collection('drivers').doc(userId).get();
      if (user.exists) {
        return ProfileModel.fromJson((user.data() ?? {}));
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  static Future setLocation(
      String userId, double latitude, double longitude) async {
    try {
      firestore.collection("drivers").doc(userId).set(
          {"latitude": latitude, "longitude": longitude},
          SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future setDeviceToken(String userId, String deviceToken) async {
    try {
      firestore
          .collection("drivers")
          .doc(userId)
          .set({"deviceToken": deviceToken}, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<User> getCurrentFirebaseUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw FirebaseAuthException(code: "1");
    }
    return user;
  }

  static Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc("users/$userID").get().then((doc) {
        if (doc.exists) {
          exists = true;
        } else {
          exists = false;
        }
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static changePassword(String password) async {
    //Create an instance of the current user.
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw FirebaseAuthException(code: "1");
    }
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this e-mail not found.';
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
        case 'The email address is already in use by another account.':
          return 'Email address is already taken.';
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}
