import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/profile_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/profile_info.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/services/profice_service_interface.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:sixvalley_vendor_app/helper/country_code_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class ProfileController with ChangeNotifier {
  final ProfileServiceInterface profileServiceInterface;

  ProfileController({required this.profileServiceInterface});

  ProfileInfoModel? _userInfoModel;
  ProfileInfoModel? get userInfoModel => _userInfoModel;
  int? _userId;
  int? get userId =>_userId;
  String? _profileImage;
  String? get profileImage =>_profileImage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _countryDialCode = '+880';
  String? get countryDialCode => _countryDialCode;



  Future<ResponseModel> getSellerInfo() async {
    ResponseModel responseModel;
    ApiResponse apiResponse = await profileServiceInterface.getSellerInfo();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _userInfoModel = ProfileInfoModel.fromJson(apiResponse.response!.data);
      _userId = _userInfoModel!.id;
      _profileImage = _userInfoModel!.image;
      responseModel = ResponseModel(true, 'successful');
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      if (kDebugMode) {
        print(errorMessage);
      }
      responseModel = ResponseModel(false, errorMessage);
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return responseModel;
  }

  setFreeDeliveryStatus(String val){
    _userInfoModel?.freeOverDeliveryAmountStatus = int.parse(val);
    notifyListeners();
  }




  Future<void> updateUserInfo(ProfileInfoModel updateUserModel, ProfileBody seller, File? file, String token, String password) async {
    _isLoading = true;
    notifyListeners();

    http.StreamedResponse response = await profileServiceInterface.updateProfile(updateUserModel, seller, file, token, password);
    _isLoading = false;
    if (response.statusCode == 200) {
      _userInfoModel = updateUserModel;
      getSellerInfo();
      showCustomSnackBarWidget(getTranslated('updated_successfully', Get.context!) ?? "", Get.context!, isError: false);
    }
    notifyListeners();
  }





  Future<ApiResponse> deleteCustomerAccount(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await profileServiceInterface.deleteUserAccount();
    _isLoading = false;
    notifyListeners();
    return apiResponse;
  }

  void setCountryDialCode (String? setValue){
    if(setValue != null && setValue.trim() != '') {
      _countryDialCode = setValue;
    } else {
      _countryDialCode = CountryCodeHelper.getCountryCodebyCode(Provider.of<SplashController>(Get.context!, listen: false).configModel!.countryCode)!;
    }
  }

}
