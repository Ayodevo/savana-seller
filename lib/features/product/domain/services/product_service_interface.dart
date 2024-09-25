abstract class ProductServiceInterface {
  Future<dynamic> getSellerProductList(String sellerId, int offset, String languageCode, String search );
  Future<dynamic> getPosProductList(int offset, List <String> ids);
  Future<dynamic> getStockLimitStatus();
  Future<dynamic> getSearchedPosProductList(String search, List <String> ids);
  Future<dynamic> getStockLimitedProductList(int offset, String languageCode );
  Future<dynamic> getMostPopularProductList(int offset, String languageCode );
  Future<dynamic> getTopSellingProductList(int offset, String languageCode );
  Future<dynamic> deleteProduct(int? productID);
  bool isShowCookies();
  Future<void> setIsShowCookies();
  Future<void> removeShowCookies();
}