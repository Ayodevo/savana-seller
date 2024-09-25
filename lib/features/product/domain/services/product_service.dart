
import 'package:sixvalley_vendor_app/features/product/domain/repositories/product_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/product/domain/services/product_service_interface.dart';

class ProductService implements ProductServiceInterface{
  final ProductRepositoryInterface productRepoInterface;
  ProductService({required this.productRepoInterface});


  @override
  Future getMostPopularProductList(int offset, String languageCode) {
    return productRepoInterface.getMostPopularProductList(offset, languageCode);
  }

  @override
  Future getPosProductList(int offset, List<String> ids) {
    return productRepoInterface.getPosProductList(offset, ids);
  }

  @override
  Future getStockLimitStatus() {
    return productRepoInterface.getStockLimitStatus();
  }

  @override
  Future getSearchedPosProductList(String search, List<String> ids) {
    return productRepoInterface.getSearchedPosProductList(search, ids);
  }

  @override
  Future getSellerProductList(String sellerId, int offset, String languageCode, String search) {
    return productRepoInterface.getSellerProductList(sellerId, offset, languageCode, search);
  }

  @override
  Future getStockLimitedProductList(int offset, String languageCode) {
   return productRepoInterface.getStockLimitedProductList(offset, languageCode);
  }

  @override
  Future getTopSellingProductList(int offset, String languageCode) {
    return productRepoInterface.getTopSellingProductList(offset, languageCode);
  }

  @override
  Future deleteProduct(int? productID) {
    return productRepoInterface.delete(productID!);
  }

  @override
  bool isShowCookies() {
    return productRepoInterface.isShowCookies();
  }

  @override
  Future<void> setIsShowCookies() {
    return productRepoInterface.setIsShowCookies();
  }

  @override
  Future<void> removeShowCookies() {
    return productRepoInterface.removeShowCookies();
  }

}