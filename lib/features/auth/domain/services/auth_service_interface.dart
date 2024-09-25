import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/auth/domain/models/register_model.dart';

abstract class AuthServiceInterface {
  Future<dynamic> login({String? emailAddress, String? password});
  Future<dynamic> setLanguageCode(String languageCode);
  Future<dynamic> forgotPassword(String identity);
  Future<dynamic> resetPassword(String identity, String otp ,String password, String confirmPassword);
  Future<dynamic> verifyOtp(String identity, String otp);
  Future<dynamic> updateToken();
  Future<void> saveUserToken(String token);
  String getUserToken();
  bool isLoggedIn();
  Future<dynamic> clearSharedData();
  Future<dynamic> saveUserNumberAndPassword(String number, String password);
  String getUserEmail();
  String getUserPassword();
  Future<dynamic> clearUserNumberAndPassword();
  Future<dynamic> registration(XFile? profileImage, XFile? shopLogo, XFile? shopBanner, XFile? secondaryBanner, RegisterModel registerModel);
}