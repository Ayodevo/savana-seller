import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/customer_body.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/place_order_body.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class CartRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getCouponDiscount(String couponCode, int? userId, double orderAmount);
  Future<ApiResponse> placeOrder(PlaceOrderBody placeOrderBody);
  Future<ApiResponse> getProductFromScan(String? productCode);
  Future<ApiResponse> getCustomerList(String type);
  Future<ApiResponse> customerSearch(String name);
  Future<ApiResponse> addNewCustomer(CustomerBody customerBody);
  Future<ApiResponse> getInvoiceData(int? orderId);
}