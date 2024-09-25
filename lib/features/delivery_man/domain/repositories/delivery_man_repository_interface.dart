
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_body.dart';
import 'package:sixvalley_vendor_app/interface/repository_interface.dart';

abstract class DeliveryManRepositoryInterface implements RepositoryInterface{
  Future<ApiResponse> getDeliveryManList();
  Future<ApiResponse> deliveryManWithdrawList(int offset, String status);
  Future<ApiResponse> getDeliveryManReviewList(int offset, int? id);
  Future<ApiResponse> deliveryManWithdrawDetails(int? id);
  Future<ApiResponse> deliveryManWithdrawApprovedDenied(int? id, String note, int approved);
  Future<ApiResponse> deliveryManSearchList(int offset, String search);
  Future<ApiResponse> deliveryManDetails(int? deliveryManId);
  Future<ApiResponse> deliveryManOrderList(int offset, int? deliverymanId);
  Future<ApiResponse> deliveryManEarningList(int offset, int? deliverymanId);
  Future<ApiResponse> getTopDeliveryManList();
  Future<ApiResponse> assignDeliveryMan(int? orderId, int? deliveryManId);
  Future<ApiResponse> deliveryManStatusOnOff(int? id, int status);
  Future<ApiResponse> collectCashFromDeliveryMan(int? deliveryManId, String amount);
  Future<ApiResponse> deleteDeliveryMan(int? deliveryManId);
  Future<ApiResponse> getDeliverymanOrderHistoryLog(int? orderId);
  Future<ApiResponse> addNewDeliveryMan(XFile? profileImage, List<XFile?> identityImage, DeliveryManBody deliveryManBody,String token,{bool isUpdate = false});
  Future<ApiResponse> getDeliveryManCollectedCashList(int? id, int offset);
}