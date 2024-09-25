import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/repositories/order_details_repository_interface.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class OrderDetailsRepository implements OrderDetailsRepositoryInterface{
  final DioClient? dioClient;
  OrderDetailsRepository({required this.dioClient});

  @override
  Future<ApiResponse> orderStatus(int? orderID , String? status) async {
    try {
      Response response = await dioClient!.post(
        '${AppConstants.updateOrderStatus}$orderID',
        data: {'_method': 'put', 'order_status': status},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getOrderStatusList(String type) async {
    try {
      List<String> addressTypeList = [];
      if(type == 'inhouse_shipping'){
        addressTypeList = [
          'pending',
          'confirmed',
          'processing'
        ];
      }else{
        addressTypeList = [
          'pending',
          'confirmed',
          'processing',
          'out_for_delivery',
          'delivered',
          'returned',
          'failed',
          'canceled',
        ];
      }

      Response response = Response(requestOptions: RequestOptions(path: ''), data: addressTypeList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updatePaymentStatus({int? orderId, String? status}) async {
    try {
      Response response = await dioClient!.post(AppConstants.paymentStatusUpdate,
        data: {"order_id": orderId, "payment_status": status},);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getOrderDetails(String orderID) async {
    try {
      final response = await dioClient!.get('${AppConstants.orderDetails}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> uploadAfterSellDigitalProduct(File? filePath, String token, String orderId) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.digitalProductUploadAfterSell}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if (kDebugMode) {
      print('Here is ===>$filePath');
    }
    if(filePath != null) {
      Uint8List list = await filePath.readAsBytes();
      var part = http.MultipartFile('digital_file_after_sell', filePath.readAsBytes().asStream(), list.length, filename: basename(filePath.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'order_id': orderId,
      '_method' :'put'
    });

    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase, data: res.body));
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


  @override
  Future<HttpClientResponse> productDownload(String? url) async {
    HttpClient client = HttpClient();
    final response = await client.getUrl(Uri.parse(url!)).then((HttpClientRequest request) {
      return request.close();
    },
    );
    return response;
  }

}