

import 'package:sixvalley_vendor_app/features/pos/domain/models/customer_body.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/place_order_body.dart';

abstract class CartServiceInterface{
  Future<dynamic> getCouponDiscount(String couponCode, int? userId, double orderAmount);
  Future<dynamic> placeOrder(PlaceOrderBody placeOrderBody);
  Future<dynamic> getProductFromScan(String? productCode);
  Future<dynamic> getCustomerList(String type);
  Future<dynamic> customerSearch(String name);
  Future<dynamic> addNewCustomer(CustomerBody customerBody);
  Future<dynamic> getInvoiceData(int? orderId);
}