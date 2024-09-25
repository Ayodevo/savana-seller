

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/shop_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class ShopRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getShop();
  Future<http.StreamedResponse> updateShop(ShopModel userInfoModel,  File? file, XFile? shopBanner, XFile? secondaryBanner, XFile? offerBanner,
      {String? minimumOrderAmount, String? freeDeliveryStatus, String? freeDeliveryOverAmount});
  Future<ApiResponse> vacation(String? startDate, String? endDate, String? vacationNote, int status);
  Future<ApiResponse> temporaryClose(int status);
}