

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/shop_model.dart';

abstract class ShopServiceInterface{
  Future<dynamic> getShop();
  Future<dynamic> updateShop(ShopModel userInfoModel,  File? file, XFile? shopBanner, XFile? secondaryBanner, XFile? offerBanner,
      {String? minimumOrderAmount, String? freeDeliveryStatus, String? freeDeliveryOverAmount});
  Future<dynamic> vacation(String? startDate, String? endDate, String? vacationNote, int status);
  Future<dynamic> temporaryClose(int status);
}