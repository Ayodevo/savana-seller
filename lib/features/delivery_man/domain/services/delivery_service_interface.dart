import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_body.dart';

abstract class DeliveryServiceInterface {
  Future<dynamic> getDeliveryManList();
  Future<dynamic> deliveryManWithdrawList(int offset, String status);
  Future<dynamic> getDeliveryManReviewList(int offset, int? id);
  Future<dynamic> deliveryManWithdrawDetails(int? id);
  Future<dynamic> deliveryManWithdrawApprovedDenied(int? id, String note, int approved);
  Future<dynamic> deliveryManList(int offset, String search);
  Future<dynamic> deliveryManDetails(int? deliveryManId);
  Future<dynamic> deliveryManOrderList(int offset, int? deliverymanId);
  Future<dynamic> deliveryManEarningList(int offset, int? deliverymanId);
  Future<dynamic> getTopDeliveryManList();
  Future<dynamic> assignDeliveryMan(int? orderId, int? deliveryManId);
  Future<dynamic> deliveryManStatusOnOff(int? id, int status);
  Future<dynamic> collectCashFromDeliveryMan(int? deliveryManId, String amount);
  Future<dynamic> deleteDeliveryMan(int? deliveryManId);
  Future<dynamic> getDeliverymanOrderHistoryLog(int? orderId);
  Future<dynamic> addNewDeliveryMan(XFile? profileImage, List<XFile?> identityImage, DeliveryManBody deliveryManBody,String token,{bool isUpdate = false});
  Future<dynamic> getDeliveryManCollectedCashList(int? id, int offset);
}