import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String name;
  final String surname;
  final String identityNumber;
  final bool? isDriverLicenseFrontUploaded;
  final bool? isDriverLicenseBackUploaded;
  final String? email;
  final String mobilePhone;
  final bool isVerified;
  final String userId;
  String? profileUrl;
  String vehicleYear;
  String vehicleManufacturer;
  String vehicleModel;
  String? city;
  String vehicleColor;
  String deviceToken;
  final String facePhotoUrl;
  final String driverLicenseBackPhoto;
  final String driverLicenseFrontPhoto;
  String? rating;
  double? latitude;
  double? longitude;

  Timestamp?
      createdAt; // FieldValue.serverTimestamp() can be a Firestore Timestamp
  String? firstName;
  String? imageUrl;
  Timestamp?
      lastSeen; // FieldValue.serverTimestamp() can be a Firestore Timestamp
  Map<String, dynamic>? metadata;
  String? role;
  Timestamp?
      updatedAt; // FieldValue.serverTimestamp() can be a Firestore Timestamp
  String? get settedProfileUrl {
    return profileUrl;
  }

  final String lastName;

  set settedProfileUrl(String? profileUrl) {
    profileUrl = profileUrl;
  }

  final String? plateNumber;

  ProfileModel({
    required this.name,
    required this.surname,
    required this.identityNumber,
    required this.isDriverLicenseFrontUploaded,
    required this.isDriverLicenseBackUploaded,
    this.email,
    required this.mobilePhone,
    required this.isVerified,
    required this.userId,
    this.profileUrl,
    this.plateNumber,
    required this.deviceToken,
    required this.driverLicenseBackPhoto,
    required this.driverLicenseFrontPhoto,
    required this.facePhotoUrl,
    this.createdAt,
    this.firstName,
    this.imageUrl,
    this.lastSeen,
    this.metadata,
    this.role,
    this.updatedAt,
    required this.lastName,
    this.rating,
    this.latitude,
    this.longitude,
    required this.vehicleManufacturer,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehicleYear,
    this.city,
  });

  // Factory constructor to create a ProfileModel instance from a Map
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      surname: json['surname'],
      identityNumber: json['identityNumber'],
      isDriverLicenseFrontUploaded: json['isDriverLicenseFrontUploaded'],
      isDriverLicenseBackUploaded: json['isDriverLicenseBackUploaded'],
      email: json['email'],
      mobilePhone: json['mobilePhone'],
      isVerified: json["isVerified"],
      userId: json['userId'],
      profileUrl: json['profileUrl'],
      plateNumber: json['plateNumber'] == null ? null : json['plateNumber'],
      deviceToken: json["deviceToken"] == null ? "" : json["deviceToken"],
      driverLicenseBackPhoto: json["driverLicenseBackPhoto"] == null
          ? ""
          : json["driverLicenseBackPhoto"],
      driverLicenseFrontPhoto: json["driverLicenseFrontPhoto"] == null
          ? ""
          : json["driverLicenseFrontPhoto"],
      facePhotoUrl: json["facePhotoUrl"] == null ? "" : json["facePhotoUrl"],
      createdAt: json["createdAt"],
      firstName: json["firstName"],
      imageUrl: json["imageUrl"],
      lastSeen: json["lastSeen"],
      metadata: json["metadata"],
      role: json["role"],
      updatedAt: json["updatedAt"],
      lastName: json["lastName"],
      rating: json["rating"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      vehicleModel: json["vehicleModel"],
      vehicleColor: json["vehicleColor"],
      vehicleYear: json["vehicleYear"],
      city: json["city"],
      vehicleManufacturer: json['vehicleManufacturer'],
    );
  }

  // Convert a ProfileModel instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'identityNumber': identityNumber,
      'isDriverLicenseFrontUploaded': isDriverLicenseFrontUploaded,
      'isDriverLicenseBackUploaded': isDriverLicenseBackUploaded,
      'email': email,
      'mobilePhone': mobilePhone,
      'isVerified': isVerified,
      'userId': userId,
      'profileUrl': profileUrl,
      'plateNumber': plateNumber,
      'deviceToken': deviceToken,
      "driverLicenseBackPhoto": driverLicenseBackPhoto,
      "driverLicenseFrontPhoto": driverLicenseFrontPhoto,
      "facePhotoUrl": facePhotoUrl,
      "createdAt": FieldValue.serverTimestamp(),
      "firstName": name,
      "imageUrl": facePhotoUrl,
      "lastSeen": lastSeen,
      "metadata": metadata,
      "role": role,
      "updatedAt": updatedAt,
      "lastName": lastName,
      "rating": rating,
      "latitude": latitude,
      "longitude": longitude,
      'vehicleModel': vehicleModel,
      'vehicleManufacturer': vehicleManufacturer,
      'vehicleYear': vehicleYear,
      'vehicleColor': vehicleColor,
      'city': city,
    };
  }
}
