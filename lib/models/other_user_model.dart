import 'package:cloud_firestore/cloud_firestore.dart';

class OtherUserModel {
  String username;
  String email;
  String name;
  String familyName;
  String? phoneNumber;
  String identityNumber;
  String userId;
  String? description;
  int? age;
  String profileUrl;
  String deviceToken;
  Timestamp?
      createdAt; // FieldValue.serverTimestamp() can be a Firestore Timestamp
  String? firstName;
  String? imageUrl;
  Timestamp?
      lastSeen; // FieldValue.serverTimestamp() can be a Firestore Timestamp
  Map<String, dynamic>? metadata;
  String? role;
  Timestamp? updatedAt;

  OtherUserModel({
    required this.username,
    required this.email,
    required this.name,
    required this.familyName,
    required this.identityNumber,
    required this.userId,
    required this.profileUrl,
    this.description,
    this.age,
    this.phoneNumber,
    this.createdAt,
    this.firstName,
    this.imageUrl,
    this.lastSeen,
    this.metadata,
    this.role,
    this.updatedAt,
    required this.deviceToken,
  });

  factory OtherUserModel.fromJson(Map<String, dynamic> json) {
    return OtherUserModel(
        username: json['username'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        familyName: json['familyName'] as String,
        identityNumber: json['identityNumber'] as String,
        userId: json['userId'] as String,
        profileUrl: json['profileUrl'] ?? "",
        age: json["age"] as int?,
        description: "",
        phoneNumber: json["phoneNumber"],
        createdAt: json["createdAt"] as Timestamp?,
        firstName: json["firstName"] as String?,
        imageUrl: json["imageUrl"] as String?,
        lastSeen: json["lastSeen"] as Timestamp?,
        metadata: json["metadata"] as Map<String, dynamic>?,
        role: json["role"] as String?,
        updatedAt: json["updatedAt"] as Timestamp?,
        deviceToken: json["deviceToken"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'familyName': familyName,
      'identityNumber': identityNumber,
      'userId': userId,
      'profileUrl': profileUrl,
      "phoneNumber": phoneNumber,
      "createdAt": FieldValue.serverTimestamp(),
      "firstName": familyName,
      "imageUrl": imageUrl,
      "lastSeen": lastSeen,
      "metadata": metadata,
      "role": role,
      "updatedAt": updatedAt,
      "deviceToken": deviceToken,
    };
  }
}
  