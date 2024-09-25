import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';

abstract class CouponServiceInterface {
  Future<dynamic> getCouponList(int offset);
  Future<dynamic> addNewCoupon(Coupons coupons, {bool update = false});
  Future<dynamic> deleteCoupon(int? id);
  Future<dynamic> updateCouponStatus(int? id, int status);
  Future<dynamic> getCouponCustomerList(String search);
}