

import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/barcode/domain/repositories/barcode_reposity_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class BarcodeRepository implements BarcodeRepositoryInterface{
  final DioClient dioClient;
  BarcodeRepository({required this.dioClient});

  @override
  Future<ApiResponse> barCodeDownLoad(int? id, int quantity) async {
    try {
      final response = await dioClient.get('${AppConstants.barCodeGenerateUri}?id=$id&quantity=$quantity',
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