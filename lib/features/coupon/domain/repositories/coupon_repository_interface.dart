
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class CouponRepositoryInterface extends RepositoryInterface<Coupons>{
  Future<ApiResponse> updateCouponStatus(int? id, int status);
  Future<ApiResponse> getCouponCustomerList(String search);
  @override
  Future<dynamic> add(Coupons value, {bool update = false});
}