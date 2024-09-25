import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/services/coupon_service_interface.dart';

class CouponService implements CouponServiceInterface{
  CouponRepositoryInterface couponRepoInterface;
  CouponService({required this.couponRepoInterface});

  @override
  Future addNewCoupon(Coupons coupons, {bool update = false}) {
    return couponRepoInterface.add(coupons, update: update);
  }

  @override
  Future<ApiResponse> deleteCoupon(int? id) async{
    ApiResponse apiResponse = await couponRepoInterface.delete(id!);
    return apiResponse;
  }

  @override
  Future getCouponCustomerList(String search) {
    return couponRepoInterface.getCouponCustomerList(search);
  }

  @override
  Future getCouponList(int offset) async{
    return await couponRepoInterface.getList(offset: offset);
  }

  @override
  Future updateCouponStatus(int? id, int status) {
    return couponRepoInterface.updateCouponStatus(id, status);
  }
}