import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class ShippingRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getShipping();
  Future<ApiResponse> getShippingMethod(String token);
  Future<ApiResponse> updateShipping(String? title,String? duration,double? cost, int? id);
  Future<ApiResponse> getCategoryWiseShippingMethod();
  Future<ApiResponse> getSelectedShippingMethodType();
  Future<ApiResponse> setShippingMethodType( String? type);
  Future<ApiResponse> setCategoryWiseShippingCost(List<int? >  ids, List<double> cost, List<int> multiPly);
  Future<ApiResponse> shippingOnOff(int? id,int status);
}