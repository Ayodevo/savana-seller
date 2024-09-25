import 'dart:io';

abstract class OrderDetailsServiceInterface{
  Future<dynamic> getOrderDetails(String orderID);
  Future<dynamic> orderStatus(int? orderID , String? status);
  Future<dynamic> getOrderStatusList(String type);
  Future<dynamic> updatePaymentStatus({int? orderId, String? status});
  Future<dynamic> uploadAfterSellDigitalProduct(File? filePath, String token, String orderId);
  Future<HttpClientResponse> productDownload(String url);

}