class VerificationModel {
  final bool? isDriverLicenseFrontUploaded;
  final bool? isDriverLicenseBackUploaded;
  final bool? isFacePhotoUploaded;
  final String facePhotoUrl;
  final String driverLicenseBackPhoto;
  final String driverLicenseFrontPhoto;

  VerificationModel(
      {required this.isDriverLicenseFrontUploaded,
      required this.isDriverLicenseBackUploaded,
      required this.isFacePhotoUploaded,
      required this.facePhotoUrl,
      required this.driverLicenseBackPhoto,
      required this.driverLicenseFrontPhoto});

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      isDriverLicenseFrontUploaded: json['isDriverLicenseFrontUploaded'],
      isDriverLicenseBackUploaded: json['isDriverLicenseBackUploaded'],
      isFacePhotoUploaded: json['isFacePhotoUploaded'],
      facePhotoUrl: json['facePhotoUrl'],
      driverLicenseBackPhoto: json['driverLicenseBackPhoto'],
      driverLicenseFrontPhoto: json['driverLicenseFrontPhoto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDriverLicenseFrontUploaded': isDriverLicenseFrontUploaded,
      'isDriverLicenseBackUploaded': isDriverLicenseBackUploaded,
      'isFacePhotoUploaded': isFacePhotoUploaded,
      'facePhotoUrl': facePhotoUrl,
      'driverLicenseBackPhoto': driverLicenseBackPhoto,
      'driverLicenseFrontPhoto': driverLicenseFrontPhoto,
    };
  }
}
