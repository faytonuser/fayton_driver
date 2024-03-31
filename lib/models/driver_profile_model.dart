class DriverProfileModel {
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
  String deviceToken;
  String? rating;
  final String facePhotoUrl;

  String? get settedProfileUrl {
    return profileUrl;
  }

  set settedProfileUrl(String? profileUrl) {
    profileUrl = profileUrl;
  }

  final String plateNumber;

  DriverProfileModel(
      {required this.name,
      required this.surname,
      required this.identityNumber,
      required this.isDriverLicenseFrontUploaded,
      required this.isDriverLicenseBackUploaded,
      this.email,
      required this.mobilePhone,
      required this.isVerified,
      required this.userId,
      this.profileUrl,
      required this.plateNumber,
      required this.deviceToken,
      required this.facePhotoUrl,
      this.rating});

  // Factory constructor to create a DriverProfileModel instance from a Map
  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
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
      plateNumber: json['plateNumber'],
      deviceToken: json["deviceToken"] == null ? "" : json["deviceToken"],
      facePhotoUrl: json["facePhotoUrl"] == null ? "" : json["facePhotoUrl"],
      rating: json["rating"],
    );
  }

  // Convert a DriverProfileModel instance to a Map
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
      "facePhotoUrl": facePhotoUrl,
      "rating": rating,
    };
  }
}
