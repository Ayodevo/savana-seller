import 'package:dio/dio.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/settings/domain/models/business_model.dart';
import 'package:sixvalley_vendor_app/features/settings/domain/repositories/buisness_repository_interface.dart';

class BusinessRepository implements BusinessRepositoryInterface{

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
  Future getList({int? offset = 1}) async{
    try {
      List<BusinessModel> businessList = [
        BusinessModel(id: 0, title: 'Superb Discount', duration: '2-5', cost: 200),
        BusinessModel(id: 1, title: 'New Discount', duration: '5-10', cost: 500),
      ];

      final response = Response(data: businessList,statusCode: 200, requestOptions: RequestOptions(path: ""));
      return  ApiResponse.withSuccess(response);
    } catch (e){
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
