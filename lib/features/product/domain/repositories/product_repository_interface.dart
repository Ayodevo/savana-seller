
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class ProductRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getSellerProductList(String sellerId, int offset, String languageCode, String search );
  Future<ApiResponse> getPosProductList(int offset, List <String> ids);
  Future<ApiResponse> getStockLimitStatus();
  Future<ApiResponse> getSearchedPosProductList(String search, List <String> ids);
  Future<ApiResponse> getStockLimitedProductList(int offset, String languageCode );
  Future<ApiResponse> getMostPopularProductList(int offset, String languageCode );
  Future<ApiResponse> getTopSellingProductList(int offset, String languageCode );
  bool isShowCookies();
  Future<void> setIsShowCookies();
  Future<void> removeShowCookies();
}