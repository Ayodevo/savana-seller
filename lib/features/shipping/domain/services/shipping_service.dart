
import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/repositories/shipping_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/services/shipping_service_interface.dart';

class ShippingService implements ShippingServiceInterface{
  final ShippingRepositoryInterface shippingRepoInterface;
  ShippingService({required this.shippingRepoInterface});

  @override
  Future addShipping(ShippingModel? shipping) {
    return shippingRepoInterface.add(shipping);
  }

  @override
  Future deleteShipping(int? id) {
    return shippingRepoInterface.delete(id!);
  }

  @override
  Future getCategoryWiseShippingMethod() {
    return shippingRepoInterface.getCategoryWiseShippingMethod();
  }

  @override
  Future getSelectedShippingMethodType() {
    return shippingRepoInterface.getSelectedShippingMethodType();
  }

  @override
  Future getShipping() {
    return shippingRepoInterface.getShipping();
  }

  @override
  Future getShippingMethod(String token) {
   return shippingRepoInterface.getShippingMethod(token);
  }

  @override
  Future setCategoryWiseShippingCost(List<int?> ids, List<double> cost, List<int> multiPly) {
    return shippingRepoInterface.setCategoryWiseShippingCost(ids, cost, multiPly);
  }

  @override
  Future setShippingMethodType(String? type) {
    return shippingRepoInterface.setShippingMethodType(type);
  }

  @override
  Future shippingOnOff(int? id, int status) {
   return shippingRepoInterface.shippingOnOff(id, status);
  }

  @override
  Future updateShipping(String? title, String? duration, double? cost, int? id) {
    return shippingRepoInterface.updateShipping(title, duration, cost, id);
  }
}