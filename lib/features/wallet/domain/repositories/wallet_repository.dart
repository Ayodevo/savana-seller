import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class WalletRepository implements WalletRepositoryInterface{
  final DioClient dioClient;
  WalletRepository({required this.dioClient});

  @override
  Future<ApiResponse> getDynamicWithDrawMethod() async {
    try {
      final response = await dioClient.get(AppConstants.dynamicWithdrawMethod);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> withdrawBalance(List <String?> typeKey, List<String> typeValue, int? id, String balance) async {
    try {
      Map<String?, String> fields = {};

      for(var i = 0; i < typeKey.length; i++){
        fields.addAll(<String?, String>{
          typeKey[i] : typeValue[i]
        });
      }
      fields.addAll(<String, String>{
        'amount': balance,
        'withdraw_method_id': id.toString()
      });
      if (kDebugMode) {
        print('--here is type key =$id');
      }
      Response response = await dioClient.post( AppConstants.balanceWithdraw,
          data: fields);

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