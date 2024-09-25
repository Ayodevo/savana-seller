import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';

abstract class ProductDetailsRepositoryInterface {
  Future<ApiResponse> getProductDetails(int? productId);
  Future<ApiResponse> productStatusOnOff(int? productId, int status);
}