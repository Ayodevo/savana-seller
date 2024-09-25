import 'package:flutter/src/widgets/framework.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/services/splash_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class SplashService implements SplashServiceInterface{
  final SplashRepositoryInterface splashRepoInterface;
  SplashService({required this.splashRepoInterface});

  @override
  Future getConfig() {
   return splashRepoInterface.getConfig();
  }

  @override
  String getCurrency() {
    return splashRepoInterface.getCurrency();
  }

  @override
  Future getShippingTypeList(BuildContext context, String type) async{
    ApiResponse apiResponse = await splashRepoInterface.getShippingTypeList(context, type);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
     return apiResponse;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  void initSharedData() {
    return splashRepoInterface.initSharedData();
  }

  @override
  void setCurrency(String currencyCode) {
   return splashRepoInterface.setCurrency(currencyCode);
  }

  @override
  void setShippingType(String shippingType) {
    return splashRepoInterface.setShippingType(shippingType);
  }
}