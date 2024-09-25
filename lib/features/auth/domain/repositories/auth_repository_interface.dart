import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/auth/domain/models/register_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class AuthRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> login({String? emailAddress, String? password});
  Future<ApiResponse> setLanguageCode(String languageCode);
  Future<ApiResponse> forgotPassword(String identity);
  Future<ApiResponse> resetPassword(String identity, String otp ,String password, String confirmPassword);
  Future<ApiResponse> verifyOtp(String identity, String otp);
  Future<ApiResponse> updateToken();
  Future<void> saveUserToken(String token);
  String getUserToken();
  bool isLoggedIn();
  Future<bool> clearSharedData();
  Future<void> saveUserCredentials(String number, String password);
  String getUserEmail();
  String getUserPassword();
  Future<bool> clearUserNumberAndPassword();
  Future<ApiResponse> registration(XFile? profileImage, XFile? shopLogo, XFile? shopBanner, XFile? secondaryBanner, RegisterModel registerModel);
}