import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/shop_model.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/repositories/shop_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/services/shop_service_interface.dart';

class ShopService implements ShopServiceInterface{
  final ShopRepositoryInterface shopRepositoryInterface;
  ShopService({required this.shopRepositoryInterface});

  @override
  Future getShop() {
    return shopRepositoryInterface.getShop();
  }

  @override
  Future temporaryClose(int status) {
    return shopRepositoryInterface.temporaryClose(status);
  }

  @override
  Future updateShop(ShopModel userInfoModel, File? file, XFile? shopBanner, XFile? secondaryBanner, XFile? offerBanner, {String? minimumOrderAmount, String? freeDeliveryStatus, String? freeDeliveryOverAmount}) {
    return shopRepositoryInterface.updateShop(userInfoModel, file, shopBanner, secondaryBanner, offerBanner, minimumOrderAmount: minimumOrderAmount, freeDeliveryOverAmount: freeDeliveryOverAmount, freeDeliveryStatus: freeDeliveryStatus);
  }

  @override
  Future vacation(String? startDate, String? endDate, String? vacationNote, int status) {
    return shopRepositoryInterface.vacation(startDate, endDate, vacationNote, status);
  }

}