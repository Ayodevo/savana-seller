import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/review/domain/repositories/product_review_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class ProductReviewRepository implements ProductReviewRepositoryInterface{
  final DioClient? dioClient;
  ProductReviewRepository({required this.dioClient});

  @override
  Future<ApiResponse> productReviewList() async {
    try {
      final response = await dioClient!.get(AppConstants.productReviewUri,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> filterProductReviewList(int? productId, int? customerId, int status, String? from, String? to) async {
    try {
      final response = await dioClient!.get('${AppConstants.productReviewUri}?product_id=$productId&customer_id=$customerId&status=$status&from=$from&to=$to',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> searchProductReviewList(String search) async {
    try {
      final response = await dioClient!.get('${AppConstants.productReviewUri}?search=$search',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> reviewStatusOnOff(int? reviewId, int status) async {
    try {
      final response = await dioClient!.get('${AppConstants.productReviewStatusOnOff}?id=$reviewId&status=$status',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getProductWiseReviewList(int? productId,int offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.productWiseReviewList}$productId?limit=10&offset=$offset',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> sendReviewReply(int? reviewId, String replyText) async{
    try {
      final response = await dioClient!.post(AppConstants.reviewReply,
         data: { "review_id" : reviewId, "reply_text" : replyText }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }




}