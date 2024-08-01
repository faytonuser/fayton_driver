import 'dart:ffi';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/profile_model.dart';
import 'package:driver/models/state_model.dart';
import 'package:driver/models/verificaiton_model.dart';
import 'package:driver/screens/login_screen.dart';
import 'package:driver/screens/sms_confirmation_screen.dart';
import 'package:driver/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AuthProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController get smsCodeController => _smsCodeController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get phoneController => _phoneController;
  final TextEditingController _identityNumberController =
      TextEditingController();
  TextEditingController get identityNumberController =>
      _identityNumberController;
  TextEditingController _plateController = TextEditingController();
  TextEditingController get plateController => _plateController;
  TextEditingController _manufaturerController = TextEditingController();
  TextEditingController get manufaturerController => _manufaturerController;
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _vehicleYearController = TextEditingController();
  TextEditingController get vehicleYearController => _vehicleYearController;
  final TextEditingController _vehicleModelController = TextEditingController();
  TextEditingController get vehicleModelController => _vehicleModelController;
  final TextEditingController _vehicleColorController = TextEditingController();
  TextEditingController get vehicleColorController => _vehicleColorController;
  TextEditingController _supportMailController = TextEditingController();
  TextEditingController get supportMailController => _supportMailController;
  TextEditingController get familyNameController => _familyNameController;

  TextEditingController _signupPasswordController = TextEditingController();
  TextEditingController get signupPasswordController =>
      _signupPasswordController;

  TextEditingController _signupPasswordAgainController =
      TextEditingController();
  TextEditingController get signupPasswordAgainController =>
      _signupPasswordAgainController;
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  set isPasswordVisible(value) {
    _isPasswordVisible = value;
    notifyListeners();
  }

  Client _client = Client();

  Client get client => _client;

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;
  set phoneNumber(value) {
    _phoneNumber = value;
    notifyListeners();
  }

  StateModel? _city;
  StateModel? get city => _city;
  set city(value) {
    _city = value;
    notifyListeners();
  }

  String _selectedGender = '';
  String? get selectedGender => _selectedGender;
  set selectedGender(value) {
    _selectedGender = value;
    notifyListeners();
  }

  File? _frontDriverLicense;
  File? get fronDriverLicense => _frontDriverLicense;
  set fronDriverLicense(value) {
    _frontDriverLicense = value;
    notifyListeners();
  }

  File? _facePhoto;
  File? get facePhoto => _facePhoto;
  set facePhoto(value) {
    _facePhoto = value;
    notifyListeners();
  }

  Future<void> refreshUser(String userId) async {
    currentUser = await AuthService.getCurrentUser(userId);
    notifyListeners();
  }

  File? _backDriverLincese;
  File? get backDriverLicense => _backDriverLincese;
  set backDriverLicense(value) {
    _backDriverLincese = value;
    notifyListeners();
  }

  bool _lastStep = false;
  bool get lastStep => _lastStep;
  set lastStep(value) {
    _lastStep = value;
    notifyListeners();
  }

  bool _isCheck = false;
  bool get isCheck => _isCheck;
  set isCheck(value) {
    _isCheck = value;
    notifyListeners();
  }

  bool _verifyStep = true;
  bool get verifyStep => _verifyStep;
  set verifyStep(value) {
    _verifyStep = value;
    notifyListeners();
  }

  String? _selectedPhoneCode;
  String? get selectedPhoneCode => _selectedPhoneCode;
  set selectedPhoneCode(value) {
    _selectedPhoneCode = value;
    notifyListeners();
  }

  bool _verifySecondStep = false;
  bool get verifySecondStep => _verifySecondStep;
  set verifySecondStep(value) {
    _verifySecondStep = value;
    notifyListeners();
  }

  bool _driverBackStep = false;
  bool get driverBackStep => _driverBackStep;
  set driverBackStep(value) {
    _driverBackStep = value;
    notifyListeners();
  }

  bool _driverFrontStep = false;
  bool get driverFrontStep => _driverFrontStep;
  set driverFrontStep(value) {
    _driverFrontStep = value;
    notifyListeners();
  }

  bool _vehicleDetailStep = false;
  bool get vehicleDetailStep => _vehicleDetailStep;
  set vehicleDetailStep(value) {
    _vehicleDetailStep = value;
    notifyListeners();
  }

  late String _verificationId;

  String get verificationId => _verificationId;
  set verificationId(value) {
    _verificationId = value;
    notifyListeners();
  }

  String? _currentUSerProfilePicture;
  String? get currentUserProfilePicture => _currentUSerProfilePicture;
  set currentUserProfilePicture(value) {
    _currentUSerProfilePicture = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  ProfileModel? _currentUser;
  ProfileModel? get currentUser => _currentUser;
  set currentUser(value) {
    _currentUser = value;
    notifyListeners();
  }

  String? _deviceToken;
  String? get deviceToken => _deviceToken;
  set deviceToken(value) {
    _deviceToken = value;
    notifyListeners();
  }

  final _identityInfoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _emailPasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get identityInfoFormKey => _identityInfoFormKey;
  GlobalKey<FormState> get emailPasswordFormKey => _emailPasswordFormKey;

  int _activeStep = 0;
  int get activeStep => _activeStep;
  set activeStep(value) {
    _activeStep = value;
    notifyListeners();
  }

  Future<void> setToken() async {
    try {
      FirebaseMessaging.instance.getToken().then((token) async {
        if (token == null) {
          throw Exception("token could not set");
        }
        deviceToken = token;
        if (currentUser?.userId != null) {
          await AuthService.setDeviceToken(currentUser!.userId, token!);
        }
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  bool isLoggedIn() {
    if (auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> signInWithEmail() async {
    try {
      isLoading = true;
      var user = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (user.user != null) {
        currentUser = await AuthService.getCurrentUser(user.user!.uid);
      }
      isLoading = false;
      return true;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'user-not-found') {
        throw Exception('Bu hesab mövcud deyil.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Parol doğru deyil');
      } else if (e.code == 'user-disabled') {
        throw Exception(
            'İstifadəçi hesabı administrator tərəfindən deaktiv edilmişdir.');
      } else if (e.code == 'too-many-requests') {
        throw Exception('Bu hesaba giriş üçün çox sayda sorğu göndərilib.');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception(
            'Server xətası, zəhmət olmasa daha sonra yenidən cəhd edin.');
      } else {
        throw Exception('Giriş uğursuz oldu. Zəhmət olmasa yenidən cəhd edin.');
      }
    } catch (e) {
      isLoading = false;
      throw Exception(
          'Gözlənilməz bir xəta baş verdi. Zəhmət olmasa yenidən cəhd edin.');
    }
  }

  String? currentUserId() {
    return auth.currentUser?.uid;
  }

  Future<ProfileModel?>? _getCurrentUserFuture = null;
  Future<ProfileModel?>? get getCurrentUserFuture => _getCurrentUserFuture;
  set getCurrentUserFuture(value) {
    _getCurrentUserFuture = value;
    notifyListeners();
  }

  model.Token? _token;
  model.Token? get token => _token;
  set token(value) {
    _token = value;
    notifyListeners();
  }

  Future<void> sendSms(BuildContext context) async {
    try {
      final Account account = Account(client);

      token = await account.createPhoneToken(
        userId: ID.unique(),
        phone: selectedPhoneCode! +
            phoneController.text.trim().replaceAll(" ", ""),
      );
    } on AppwriteException {
      rethrow;
    }
  }

  Future<model.Session> verifyOTP({
    required String userId,
    required String otp,
  }) async {
    try {
      final Account account = Account(client);

      final session = await account.updatePhoneSession(
        userId: userId,
        secret: otp,
      );
      return session;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> uploadProfilePicture(File profile) async {
    try {
      isLoading = true;
      var response = await storage
          .ref('profile_pictures')
          .child(currentUser!.userId)
          .putFile(profile);

      var downloadUrl = await storage
          .ref('profile_pictures')
          .child(currentUser!.userId)
          .getDownloadURL();
      await firestore
          .collection('drivers')
          .doc(currentUser!.userId)
          .set({"profileUrl": downloadUrl}, SetOptions(merge: true));
      isLoading = false;
      return downloadUrl;
    } catch (e) {
      isLoading = false;
      throw Exception(e);
    }
  }

  Future signout() async {
    await AuthService.signOut();
  }

  Future<void> uploadFiles(String id) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      if (fronDriverLicense != null) {
        var ref = storage.ref("driver_licenses").child('front-$id');
        await ref.putFile(fronDriverLicense!);
        frontPhoto = await ref.getDownloadURL();
      }
      if (backDriverLicense != null) {
        var ref = storage.ref("driver_licenses").child('back-$id');
        await ref.putFile(backDriverLicense!);
        backPhoto = await ref.getDownloadURL();
      }
      if (facePhoto != null) {
        var ref = storage.ref("faces").child('face-$id');
        await ref.putFile(facePhoto!);
        facePhotoUrl = await ref.getDownloadURL();
      }
    } catch (e) {
      isLoading = false;
    }
  }

  String facePhotoUrl = "";
  String backPhoto = "";
  String frontPhoto = "";

  Future<ProfileModel?> addUserToDb() async {
    isLoading = true;
    FirebaseFirestore client = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    await setToken();

    try {
      isLoading = true;
      var user = (await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: signupPasswordController.text));
      if (user.user != null) {
        await uploadFiles(user.user!.uid);
        var profileModel = ProfileModel(
          isDriverLicenseBackUploaded: true,
          isDriverLicenseFrontUploaded: true,
          identityNumber: identityNumberController.text,
          email: emailController.text,
          mobilePhone: "+994" + phoneController.text.trim(),
          city: city?.title ?? "TR",
          name: nameController.text,
          surname: familyNameController.text,
          isVerified: false,
          userId: auth.currentUser!.uid,
          plateNumber: plateController.text,
          deviceToken: deviceToken ?? "",
          driverLicenseBackPhoto: backPhoto,
          driverLicenseFrontPhoto: frontPhoto,
          facePhotoUrl: facePhotoUrl,
          profileUrl: facePhotoUrl,
          lastName: familyNameController.text,
          vehicleModel: vehicleModelController.text,
          vehicleColor: vehicleColorController.text,
          vehicleYear: int.parse(vehicleYearController.text),
          createdAt: Timestamp.now(),
        );
        await client.collection('drivers').doc(user.user!.uid).set(
              profileModel.toJson(),
            );
        FirebaseChatCore.instance
            .setConfig(FirebaseChatCoreConfig(null, "rooms", "chatUsers"));
        await FirebaseChatCore.instance.createUserInFirestore(types.User(
            id: auth.currentUser!.uid,
            firstName: nameController.text,
            lastName: familyNameController.text,
            imageUrl: ""));
        currentUser = profileModel;
        isLoading = false;
        return profileModel;
      }
    } catch (e) {
      isLoading = false;

      throw Exception(e);
    }

    isLoading = false;
    throw Exception("User could not created");
  }

  Future<ProfileModel?> updateUserToDb() async {
    FirebaseFirestore client = FirebaseFirestore.instance;
    try {
      isLoading = true;
      await uploadFiles(currentUser!.userId);
      var verificationModel = VerificationModel(
        isDriverLicenseFrontUploaded: true,
        isDriverLicenseBackUploaded: true,
        isFacePhotoUploaded: true,
        facePhotoUrl: facePhotoUrl,
        driverLicenseBackPhoto: backPhoto,
        driverLicenseFrontPhoto: frontPhoto,
      );

      await client.collection('drivers').doc(auth.currentUser!.uid).set(
            verificationModel.toJson(),
            SetOptions(merge: true),
          );
      currentUser = await AuthService.getCurrentUser(auth.currentUser!.uid);
      isLoading = false;
      return currentUser;
    } catch (e) {
      isLoading = false;
      throw Exception(e);
    }
  }
}
