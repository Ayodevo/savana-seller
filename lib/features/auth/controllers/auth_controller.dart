import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/auth/domain/models/register_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';

class AuthController with ChangeNotifier {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final String _loginErrorMessage = '';
  String get loginErrorMessage => _loginErrorMessage;
  XFile? _sellerProfileImage;
  XFile? _shopLogo;
  XFile? _shopBanner;
  XFile? secondaryBanner;
  XFile? offerBanner;
  XFile? get sellerProfileImage => _sellerProfileImage;
  XFile? get shopLogo => _shopLogo;
  XFile? get shopBanner => _shopBanner;
  bool? _isTermsAndCondition = false;
  bool? get isTermsAndCondition => _isTermsAndCondition;
  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;
  int _selectionTabIndex = 1;
  int get selectionTabIndex =>_selectionTabIndex;
  String _verificationCode = '';
  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;
  bool get isEnableVerificationCode => _isEnableVerificationCode;
  String? _verificationMsg = '';
  String? get verificationMessage => _verificationMsg;
  final String _email = '';
  final String _phone = '';
  String get email => _email;
  String get phone => _phone;
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;
  String? _countryDialCode = '+880';
  String? get countryDialCode => _countryDialCode;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode shopNameNode = FocusNode();
  FocusNode shopAddressNode = FocusNode();

  bool _lengthCheck = false;
  bool _numberCheck = false;
  bool _uppercaseCheck = false;
  bool _lowercaseCheck = false;
  bool _spatialCheck = false;
  bool _showPassView = false;

  bool get lengthCheck => _lengthCheck;
  bool get numberCheck => _numberCheck;
  bool get uppercaseCheck => _uppercaseCheck;
  bool get lowercaseCheck => _lowercaseCheck;
  bool get spatialCheck => _spatialCheck;
  bool get showPassView => _showPassView;

  Future<ApiResponse> login(BuildContext context, {String? emailAddress, String? password}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authServiceInterface.login(emailAddress: emailAddress, password: password);
    _isLoading = false;
    notifyListeners();
    await Provider.of<AuthController>(Get.context!, listen: false).updateToken(Get.context!);
    setCurrentLanguage(Provider.of<LocalizationController>(Get.context!, listen: false).getCurrentLanguage()??'en');
    notifyListeners();
    return apiResponse;
  }

  Future<void> setCurrentLanguage(String currentLanguage) async {
      await authServiceInterface.setLanguageCode(currentLanguage);
  }

  Future<ResponseModel> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel = await authServiceInterface.forgotPassword(email);
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> updateToken(BuildContext context) async {
      await authServiceInterface.updateToken();
  }

  void updateTermsAndCondition(bool? value) {
    _isTermsAndCondition = value;
    notifyListeners();
  }

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  void setIndexForTabBar(int index, {bool isNotify = true}){
    _selectionTabIndex = index;
    if(isNotify){
      notifyListeners();
    }
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authServiceInterface.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authServiceInterface.saveUserNumberAndPassword(number, password);
  }

  String getUserEmail() {
    return authServiceInterface.getUserEmail();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return await authServiceInterface.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }


  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }



  Future<ResponseModel> verifyOtp(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ResponseModel responseModel = await authServiceInterface.verifyOtp(phone, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    _verificationMsg = responseModel.message;
    notifyListeners();
    return responseModel;
  }


  Future<ResponseModel> resetPassword(String identity, String otp, String password, String confirmPassword) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ResponseModel responseModel = await authServiceInterface.resetPassword(identity,otp,password,confirmPassword);
    _isPhoneNumberVerificationButtonLoading = false;
    _verificationMsg = responseModel.message;
    notifyListeners();
    return responseModel;
  }


  void pickImage(bool isProfile, bool shopLogo, bool isRemove, {bool secondary = false, bool offer = false}) async {
    if(isRemove) {
      _sellerProfileImage = null;
      _shopLogo = null;
      _shopBanner = null;
      secondaryBanner = null;
    }else {
      if (isProfile) {
        _sellerProfileImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else if(shopLogo){
        _shopLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      }else if(secondary){
        secondaryBanner = await ImagePicker().pickImage(source: ImageSource.gallery);
      }else if(offer){
        offerBanner = await ImagePicker().pickImage(source: ImageSource.gallery);
      }else {
        _shopBanner = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
    }
    notifyListeners();
  }

  Future<ApiResponse> registration(BuildContext context,RegisterModel registerModel) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse  response = await authServiceInterface.registration(_sellerProfileImage, _shopLogo, _shopBanner, secondaryBanner, registerModel);
    if(response.response?.statusCode == 200) {
      _isLoading = false;
      firstNameController.clear();
      lastNameController.clear();
      phoneController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      shopNameController.clear();
      shopAddressController.clear();
      _sellerProfileImage = null;
      _shopLogo = null;
      _shopBanner = null;
      secondaryBanner = null;
      showCustomSnackBarWidget(getTranslated("you_are_successfully_registered", Get.context!), Get.context!, isError: false, sanckBarType: SnackBarType.success);

    }else {
      log("---->log===> ${response.response?.statusCode}/${response.error}/${response.response?.statusMessage}/${response.response?.data}");
      _isLoading = false;
      showCustomSnackBarWidget("The email has already been taken", Get.context!, sanckBarType: SnackBarType.warning);
    }
    _isLoading = false;
    notifyListeners();
    return response;
  }

  void setCountryDialCode (String? setValue){
    _countryDialCode = setValue;
  }


  void emptyRegistrationData ({bool isUpdate = false}) {
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    shopNameController.clear();
    shopAddressController.clear();
    _sellerProfileImage = null;
    _shopLogo = null;
    _shopBanner = null;
    secondaryBanner = null;
    if(isUpdate){
      notifyListeners();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}){
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))){
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(isUpdate) {
      notifyListeners();
    }
  }

  void showHidePass({bool isUpdate = true}){
    _showPassView = ! _showPassView;
    if(isUpdate) {
      notifyListeners();
    }
  }


  bool isPasswordValid (){
    return (_lengthCheck && _numberCheck && _lowercaseCheck && _uppercaseCheck && _spatialCheck && _numberCheck);
  }

}
