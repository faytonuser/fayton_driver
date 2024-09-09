import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/globals.dart';
import 'package:driver/models/profile_model.dart';
import 'package:driver/models/state_model.dart';
import 'package:driver/models/verificaiton_model.dart';
import 'package:driver/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _emailError;

  String? get emailError => _emailError;

  String _exception = "";

  String get exception => _exception;
  String? _passwordError;
  String? _passwordConfirmationError;

  String _password = '';
  String _passwordAgain = '';

  String get password => _password;

  String get passwordAgain => _passwordAgain;

  String? get passwordError => _passwordError;

  String? get passwordConfirmationError => _passwordConfirmationError;
  String? _phoneError;

  String? get phoneError => _phoneError;
  String? _passwordAgainError;

  String? get passwordAgainError => _passwordAgainError;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  TextEditingController get emailController => _emailController;

  TextEditingController get passwordController => _passwordController;

  TextEditingController get phoneController => _phoneController;
  final TextEditingController _identityNumberController =
      TextEditingController();

  TextEditingController get identityNumberController =>
      _identityNumberController;
  TextEditingController _plateController = TextEditingController();
  String _plateNumber = '';
  String? _plateError = '';

  TextEditingController get plateController => _plateController;
  final TextEditingController _nameController = TextEditingController();

  TextEditingController get nameController => _nameController;
  final TextEditingController _familyNameController = TextEditingController();

  String? _selectedManufacturer;
  String? _selectedModel;
  String? _selectedYear;
  String? _selectedColor;

  String? get selectedManufacturer => _selectedManufacturer;

  String? get selectedModel => _selectedModel;

  String? get selectedYear => _selectedYear;

  String? get selectedColor => _selectedColor;

  TextEditingController _supportMailController = TextEditingController();

  TextEditingController get supportMailController => _supportMailController;

  TextEditingController get familyNameController => _familyNameController;
  String? _name;
  String? _surname;
  String? _nameError;
  String? _surnameError;

  String? get name => _name;
  String? get surname => _surname;
  String? get nameError => _nameError;
  String? get surnameError => _surnameError;

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


  updateName(String value){
    print(value);
    _name = value;
    if (_name == null){
      _nameError = 'Adınızı daxil edin';
    }
    else if (_name!.length < 3){
      _nameError = 'Zəhmət olmasa, adınızı tam daxil edin';
    }
    else {
     _nameError = null;
    }
    notifyListeners();
  }
  updateSurname(String value){
    _surname = value;
    if (_surname == null){
      _surnameError = 'Soyadınızı daxil edin';
    }
    else if (_surname!.length < 3){
      _surnameError = 'Zəhmət olmasa, soyadınızı tam daxil edin';
    }
    else{
    _surnameError = null;
    }
    notifyListeners();
  }
  updatePassword(String value) {
    _password = value;
    if (!value.isNotEmpty) {
      _passwordError = "Şifrə daxil edilməlidir";
    } else if (value.length < 6) {
      _passwordError = "Şifrə minimum 6 simvoldan ibarət olmalıdır.";
    } else {
      _passwordError = null;
      isPasswordValid = true;
    }
    notifyListeners();
  }

  updatePasswordConfirmation(String value) {
    _passwordAgain = value;
    if (!_passwordAgain.isNotEmpty) {
      _passwordAgainError = "Şifrə təkrarı daxil edilməlidir.";
    } else if (_passwordAgain != _password) {
      _passwordAgainError = "Şifrə təkrarı düzgün daxil edilməlidir.";
    } else {
      _passwordAgainError = null;
      isPasswordConfirmationValid = true;
    }
    notifyListeners();
  }

  updatePlate(value) {
    String pattern = r'^\d{2}[A-Z]{2}\d{3}$';
    RegExp regExp = RegExp(pattern);
    _plateNumber = value;
    if (plateNumber.isEmpty) {
      _plateError = 'Mətn daxil edin';
    } else if (!regExp.hasMatch(value)) {
      _plateError = 'Düzgün format daxil edin: 11AA111';
    }
    _plateError = null;
    notifyListeners();
  }

  String? get plateError => _plateError;

  String get plateNumber => _plateNumber;

  Client _client = Client();

  Client get client => _client;

  String? _phoneNumber;

  String? get phoneNumber => _phoneNumber;

  updatePhoneNumber(value) {
    _phoneNumber = value;
    if (value == null) {
      _phoneError = "Bu sahə boş olmamalıdır";
    } else if (value.length <= 9) {
      _phoneError = "Telefon nömrəsi düzgün daxil edilməyib";
    } else {
      _phoneError = null;
    }
    notifyListeners();
  }

  updateEmail(String value) {
    _emailController.text = value;
    if (value.isEmpty) {
      _emailError = "Zəhmət olmasa, email daxil edin.";
      isEmailFieldValid = false;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      isEmailFieldValid = false;
      _emailError = "E-poçt düzgün formatda deyil";
    } else {
      isEmailFieldValid = true;
      _emailError = null;
    }
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

  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  set currentPageIndex(int index) {
    _currentPageIndex = index;
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

  final GlobalKey<FormState> identityInfoFormKey = GlobalKey<FormState>();

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
          await AuthService.setDeviceToken(currentUser!.userId, token);
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

  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('company')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<bool> checkIfEmailExists() async {
    try {
      List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(_emailController.text);
      if (signInMethods.isNotEmpty) {
        //Email ALREADY EXISTS
        isEmailAlreadyUsed = true;
        return true;
      } else {
        //EMAIL NOT EXISTS
        isEmailAlreadyUsed = false;
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> isPhoneNumberExists() async {
    String formattedPhoneNumber =
        phoneController.text.replaceAll(' ', '').replaceFirst('+994', '994');
    try {
      var querySnapshot = await firestore
          .collection('drivers')
          .where('mobilePhone', isEqualTo: "+994" + formattedPhoneNumber)
          .get();
      print("Telefon nömrəsi: $formattedPhoneNumber");
      if (querySnapshot.docs.isNotEmpty) {
        print("Telefon Nömrəsi Mövcuddur");
        isPhoneNumberAlreadyExists = true;
        return true;
      } else {
        print("Telefon Nömrəsi Mövcud deyil");
        isPhoneNumberAlreadyExists = false;
        return false;
      }
    } catch (e) {
      print('Xəta baş verdi: $e');
      return false;
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
      print("ERRORR CODEEEE __________________ +++   ${e.code}");
      isLoading = false;
      if (e.code == 'user-not-found') {
        throw Exception('Bu hesab mövcud deyil.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Parol doğru deyil');
      } else if (e.code == 'invalid-credential') {
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

  Future<String> uploadProfilePicture(File profile) async {
    try {
      isLoading = true;

      // Şəkli Firebase Storage-ə yükləyin
      var storageRef = storage
          .ref('profile_pictures')
          .child(currentUser!.userId);

      // Faylı yükləyin
      var uploadTask = await storageRef.putFile(profile);

      // Fayl yükləndikdən sonra yükləmə linkini əldə edin
      var downloadUrl = await storageRef.getDownloadURL();

      // Firestore-da yüklənmə linkini saxlayın
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

  updateSelectedManufacturer(String? value) {
    if (value != null) {
      _selectedManufacturer = value;
    }
    notifyListeners();
  }

  updateSelectedModel(String? value) {
    if (value != null) {
      _selectedModel = value;
    }
    notifyListeners();
  }

  updateSelectedYear(String? value) {
    if (value != null) {
      _selectedYear = value;
    }
    notifyListeners();
  }

  updateSelectedColor(String? value) {
    if (value != null) {
      _selectedColor = value;
    }
    notifyListeners();
  }

  Future<ProfileModel?> addUserToDb() async {
    isLoading = true;
    notifyListeners();

    FirebaseFirestore client = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      var userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: signupPasswordController.text,
      );
      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;

        var profileModel = ProfileModel(
          isDriverLicenseBackUploaded: true,
          isDriverLicenseFrontUploaded: true,
          identityNumber: identityNumberController.text,
          email: emailController.text,
          mobilePhone: "+994" +
              phoneController.text
                  .replaceAll(" ", "")
                  .replaceFirst("+994", "994"),
          city: city?.title ?? "TR",
          name: nameController.text,
          surname: familyNameController.text,
          isVerified: false,
          userId: userId,
          plateNumber: plateController.text,
          deviceToken: deviceToken ?? "",
          driverLicenseBackPhoto: backPhoto,
          driverLicenseFrontPhoto: frontPhoto,
          facePhotoUrl: facePhotoUrl,
          profileUrl: facePhotoUrl,
          lastName: familyNameController.text,
          vehicleManufacturer: selectedManufacturer ?? '',
          vehicleModel: selectedModel ?? '',
          vehicleColor: selectedColor ?? '',
          vehicleYear: selectedYear ?? '',
          createdAt: Timestamp.now(),
        );

        await client
            .collection('drivers')
            .doc(userId)
            .set(profileModel.toJson());

        currentUser = profileModel;
        isLoading = false;
        notifyListeners();
        return profileModel;
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.code == 'email-already-in-use') {
        _exception = "Bu E-mail adresi artıq qeydiyyatdan keçib.";
        throw Exception('Bu E-mail adresi artıq qeydiyyatdan keçib.');
      } else if (e.code == 'invalid-email') {
        _exception = "Email düzgün deyil";
        throw Exception("E-mail adresi düzgün daxil edilməyib");
      } else {
        print('An unknown error occurred: $e');
        _exception = "Bilinmənən bir xəta yarandı";
        throw Exception('Bilinmənən bir xəta yarandı');
      }
    }

    isLoading = false;
    notifyListeners();
    throw Exception("User could not be created");
  }

  // Future<ProfileModel?> updateUserToDb() async {
  //   FirebaseFirestore client = FirebaseFirestore.instance;
  //   try {
  //     isLoading = true;
  //     await uploadFiles(currentUser!.userId);
  //     var verificationModel = VerificationModel(
  //       isDriverLicenseFrontUploaded: true,
  //       isDriverLicenseBackUploaded: true,
  //       isFacePhotoUploaded: true,
  //       facePhotoUrl: facePhotoUrl,
  //       driverLicenseBackPhoto: backPhoto,
  //       driverLicenseFrontPhoto: frontPhoto,
  //     );
  //
  //     await client.collection('drivers').doc(auth.currentUser!.uid).set(
  //           verificationModel.toJson(),
  //           SetOptions(merge: true),
  //         );
  //     currentUser = await AuthService.getCurrentUser(auth.currentUser!.uid);
  //     isLoading = false;
  //     return currentUser;
  //   } catch (e) {
  //     isLoading = false;
  //     throw Exception(e);
  //   }
  // }
}
