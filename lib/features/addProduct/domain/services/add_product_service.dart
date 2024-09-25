
 import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/image_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/repository/add_product_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/services/add_product_service_interface.dart';

class AddProductService implements AddProductServiceInterface{
 final AddProductRepositoryInterface shopRepoInterface;
 AddProductService({required this.shopRepoInterface});

  @override
  Future addImage(BuildContext context, ImageModel imageForUpload, bool colorActivate) {
    return shopRepoInterface.addImage(context, imageForUpload, colorActivate);
  }

  @override
  Future addProduct(Product product, AddProductModel addProduct, Map<String, dynamic> attributes, List<Map<String, dynamic>>? productImages, String? thumbnail, String? metaImage, bool isAdd, bool isActiveColor, List<ColorImage> colorImageObject, List<String?> tags, String? digitalFileReady, DigitalVariationModel? digitalVariationModel, bool? isDigitalVariationActive, String? token) async{
    return await shopRepoInterface.addProduct(product, addProduct, attributes, productImages, thumbnail, metaImage, isAdd, isActiveColor, colorImageObject, tags, digitalFileReady, digitalVariationModel, isDigitalVariationActive, token);
  }

  @override
  Future getAttributeList(String languageCode) {
    return shopRepoInterface.getAttributeList(languageCode);
  }

  @override
  Future getBrandList(String languageCode) {
    return shopRepoInterface.getBrandList(languageCode);
  }

  @override
  Future getCategoryList(String languageCode) {
    return shopRepoInterface.getCategoryList(languageCode);
  }

  @override
  Future getEditProduct(int? id) {
   return shopRepoInterface.getEditProduct(id);
  }

  @override
  Future getSubCategoryList() {
   return shopRepoInterface.getSubCategoryList();
  }

  @override
  Future getSubSubCategoryList() {
    return shopRepoInterface.getSubSubCategoryList();
  }

  @override
  Future updateProductQuantity(int? productId, int currentStock, List<Variation> variation) {
    return shopRepoInterface.updateProductQuantity(productId, currentStock, variation);
  }


  @override
  Future uploadDigitalProduct(File? filePath, String token) {
   return shopRepoInterface.uploadDigitalProduct(filePath, token);
  }

  @override
  Future deleteProductImage(String id, String name, String? color) {
    return shopRepoInterface.deleteProductImage(id, name, color);
  }

  @override
  Future getProductImage(String id) {
    return shopRepoInterface.getProductImage(id);
  }

  @override
  Future deleteDigitalVariationFile(int? productId, String variantKey) {
   return shopRepoInterface.deleteDigitalVariationFile(productId, variantKey);
  }
}