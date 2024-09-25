import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class CouponRepository implements CouponRepositoryInterface{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  CouponRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponse> updateCouponStatus(int? id, int status) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.couponStatusUpdate}$id',
          data: {
            '_method': 'put',
            'status': status
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getCouponCustomerList(String search) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.couponCustomerList}$search');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future delete(int id) async{
    try {
      final response = await dioClient!.post('${AppConstants.deleteCoupon}$id',
          data: {
            '_method': 'delete'
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) async{
    try {
      final response = await dioClient!.get(
          '${AppConstants.getCouponList}?limit=10&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future add(Coupons value, {bool update = false}) async{
    try {
      Response response = await dioClient!.post(
          update ? '${AppConstants.updateCoupon}${value.id}' : AppConstants.addNewCoupon,
          data: update ? {
            'coupon_type': value.couponType,
            'customer_id': value.customerId,
            'limit': value.limit,
            'discount_type': value.discountType,
            'discount': value.discount,
            'min_purchase': value.minPurchase,
            'max_discount' : value.maxDiscount,
            'code': value.code,
            'title': value.title,
            'start_date': value.startDate,
            'expire_date': value.expireDate,
            '_method': 'put'
          } : value.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}