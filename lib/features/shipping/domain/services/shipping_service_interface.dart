import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';

abstract class ShippingServiceInterface {
  Future<dynamic> getShipping();
  Future<dynamic> getShippingMethod(String token);
  Future<dynamic> addShipping(ShippingModel? shipping);
  Future<dynamic> updateShipping(String? title,String? duration,double? cost, int? id);
  Future<dynamic> deleteShipping(int? id);
  Future<dynamic> getCategoryWiseShippingMethod();
  Future<dynamic> getSelectedShippingMethodType();
  Future<dynamic> setShippingMethodType( String? type);
  Future<dynamic> setCategoryWiseShippingCost(List<int? >  ids, List<double> cost, List<int> multiPly);
  Future<dynamic> shippingOnOff(int? id,int status);
}