abstract class OrderServiceInterface {
  Future<dynamic> getOrderList(int offset, String status);
  Future<dynamic> setDeliveryCharge(int? orderID, String? deliveryCharge, String? expectedDeliveryDate);
  Future<dynamic> assignThirdPartyDeliveryMan(String name,String trackingId, int? orderId);
  Future<dynamic> orderAddressEdit({String? orderID, String? addressType, String? contactPersonName, String? phone, String? city, String? zip,
    String? address, String? email, String? latitude, String? longitude,
  });
}