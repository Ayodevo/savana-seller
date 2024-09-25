

import 'package:sixvalley_vendor_app/features/pos/domain/models/customer_body.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/place_order_body.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/repository/cart_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/services/cart_service_interface.dart';

class CartService implements CartServiceInterface{
  final CartRepositoryInterface cartRepositoryInterface;
  CartService({required this.cartRepositoryInterface});

  @override
  Future addNewCustomer(CustomerBody customerBody) {
    return cartRepositoryInterface.addNewCustomer(customerBody);
  }

  @override
  Future customerSearch(String name) {
    return cartRepositoryInterface.customerSearch(name);
  }

  @override
  Future getCouponDiscount(String couponCode, int? userId, double orderAmount) {
    return cartRepositoryInterface.getCouponDiscount(couponCode, userId, orderAmount);
  }

  @override
  Future getCustomerList(String type) {
    return cartRepositoryInterface.getCustomerList(type);
  }

  @override
  Future getProductFromScan(String? productCode) {
    return cartRepositoryInterface.getProductFromScan(productCode);
  }

  @override
  Future placeOrder(PlaceOrderBody placeOrderBody) {
    return cartRepositoryInterface.placeOrder(placeOrderBody);
  }

  @override
  Future getInvoiceData(int? orderId) {
    return cartRepositoryInterface.getInvoiceData(orderId);
  }

}