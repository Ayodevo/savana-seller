

abstract class ProductDetailsServiceInterface {
  Future<dynamic> getProductDetails(int? productId);
  Future<dynamic> productStatusOnOff(int? productId, int status);
}