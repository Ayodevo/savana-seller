
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class OrderRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getOrderList(int offset, String status);
  Future<ApiResponse> setDeliveryCharge(int? orderID, String? deliveryCharge, String? expectedDeliveryDate);
  Future<ApiResponse> assignThirdPartyDeliveryMan(String name,String trackingId, int? orderId);
  Future<ApiResponse> orderAddressEdit({String? orderID, String? addressType, String? contactPersonName, String? phone, String? city, String? zip,
    String? address, String? email, String? latitude, String? longitude,
  });
}