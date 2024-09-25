import 'dart:io';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class OrderDetailsRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> updatePaymentStatus({int? orderId, String? status});
  Future<ApiResponse> getOrderDetails(String orderID);
  Future<ApiResponse> orderStatus(int? orderID , String? status);
  Future<ApiResponse> getOrderStatusList(String type);
  Future<ApiResponse> uploadAfterSellDigitalProduct(File? filePath, String token, String orderId);
  Future<HttpClientResponse> productDownload(String url);

}