import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/shop_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/services/shop_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class ShopController extends ChangeNotifier {
  final ShopServiceInterface shopServiceInterface;

  ShopController({required this.shopServiceInterface});


  int _selectedIndex = 0;
  int get selectedIndex =>_selectedIndex;

  updateSelectedIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }



  ShopModel? _shopModel;
  ShopModel? get shopModel => _shopModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  File? _file;

  File? get file => _file;
  final picker = ImagePicker();

  void choosePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    if (pickedFile != null) {
      _file = File(pickedFile.path);
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
    notifyListeners();
  }

  bool vacationIsOn = false;

  void checkVacation(String vacationEndDate){
      DateTime vacationDate = DateTime.parse(vacationEndDate);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      if(difference >=0 ){
        vacationIsOn = true;
      }else{
        vacationIsOn = false;
      }

  }


  Future<ResponseModel> getShopInfo() async {
    ResponseModel responseModel;
    ApiResponse apiResponse = await shopServiceInterface.getShop();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _shopModel = ShopModel.fromJson(apiResponse.response!.data);
      responseModel = ResponseModel(true, 'successful');
      if(shopModel!.vacationEndDate != null){
        checkVacation(shopModel!.vacationEndDate!);
      }


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


  Future<void> updateShopInfo( {ShopModel? updateShopModel, File? file,String? minimumOrderAmount,
    String? freeDeliveryStatus,
    String? freeDeliveryOverAmount, bool fromOnOff = false}) async {

    http.StreamedResponse response = await shopServiceInterface.updateShop(shopModel!, file,
        Provider.of<AuthController>(Get.context!, listen: false).shopBanner,
        Provider.of<AuthController>(Get.context!, listen: false).secondaryBanner,
        Provider.of<AuthController>(Get.context!, listen: false).offerBanner,minimumOrderAmount: minimumOrderAmount,
        freeDeliveryOverAmount: freeDeliveryOverAmount, freeDeliveryStatus: freeDeliveryStatus
    );
    if (response.statusCode == 200) {
      if(fromOnOff){
        Provider.of<ProfileController>(Get.context!, listen: false).setFreeDeliveryStatus(freeDeliveryStatus!);
      }
      showCustomSnackBarWidget(getTranslated('shop_info_updated_successfully', Get.context!), Get.context!, isError: false, sanckBarType: SnackBarType.success);
      getShopInfo();
      Provider.of<ProfileController>(Get.context!, listen: false).getSellerInfo();

    }
    notifyListeners();
  }



  Future<void> shopTemporaryClose(BuildContext context, int status) async {
    Navigator.of(context).pop();
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shopServiceInterface.temporaryClose(status);

    if (apiResponse.response!.statusCode == 200) {
      _isLoading = false;

      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      getShopInfo();

    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();

  }


  Future<void> shopVacation(BuildContext context, String? startDate, String? endDate, vacationNote, int status) async {
    Navigator.of(context).pop();
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shopServiceInterface.vacation(startDate, endDate, vacationNote, status);

    if (apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      getShopInfo();

    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();

  }




  final int _selectedItem = 0;
  int get selectedItem => _selectedItem;
  String _startDate = 'Start Date';
  String get startDate => _startDate;
  String _endDate = 'End Date';
  String get endDate => _endDate;


  Future <void> selectDate(BuildContext context,String startDate, String endDate) async {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }


}


