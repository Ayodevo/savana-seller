import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_body.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_withdraw_detail_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/order_history_log_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/repositories/delivery_man_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/services/delivery_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/main.dart';

class DeliveryService implements DeliveryServiceInterface{
  DeliveryManRepositoryInterface deliveryManRepoInterface;
  DeliveryService({required this.deliveryManRepoInterface});
  @override
  Future addNewDeliveryMan(XFile? profileImage, List<XFile?> identityImage, DeliveryManBody deliveryManBody, String token, {bool isUpdate = false}) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.addNewDeliveryMan(profileImage, identityImage, deliveryManBody, token, isUpdate: isUpdate);
    if(apiResponse.response!.statusCode == 200) {
      return ResponseModel(true, '');
    }
  }

  @override
  Future assignDeliveryMan(int? orderId, int? deliveryManId) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.assignDeliveryMan(orderId, deliveryManId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      return ResponseModel(true, '');
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future collectCashFromDeliveryMan(int? deliveryManId, String amount) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.collectCashFromDeliveryMan(deliveryManId, amount);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      return ResponseModel(true, '');
    }else{
      Map map = apiResponse.response!.data;
      return ResponseModel(false, map['message']);
    }
  }

  @override
  Future deleteDeliveryMan(int? deliveryManId) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.deleteDeliveryMan(deliveryManId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String? message = apiResponse.response!.data['message'];
      return ResponseModel(true, message);
    }
  }

  @override
  Future deliveryManDetails(int? deliveryManId) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.deliveryManDetails(deliveryManId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      return apiResponse;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future deliveryManEarningList(int offset, int? deliverymanId) async{
    return await deliveryManRepoInterface.deliveryManEarningList(offset, deliverymanId);
  }

  @override
  Future deliveryManList(int offset, String search) async{
    return await deliveryManRepoInterface.deliveryManSearchList(offset, search);
  }

  @override
  Future deliveryManOrderList(int offset, int? deliverymanId) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.deliveryManOrderList(offset, deliverymanId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      return apiResponse;
     } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future deliveryManStatusOnOff(int? id, int status) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.deliveryManStatusOnOff(id, status);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
    return ResponseModel(true, '');
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future deliveryManWithdrawApprovedDenied(int? id, String note, int approved) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.deliveryManWithdrawApprovedDenied(id, note, approved);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String? message = apiResponse.response!.data['message'];
      showCustomSnackBarWidget(message, Get.context!, isToaster: true);
      return ResponseModel(true, message);
    } else {
      String? message = apiResponse.response!.data['message'];
      showCustomSnackBarWidget(message, Get.context!, isToaster: true);
    }
  }

  @override
  Future deliveryManWithdrawDetails(int? id) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.deliveryManWithdrawDetails(id);
    Details? details;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      details = DeliveryManWithdrawDetailModel.fromJson(apiResponse.response!.data).details;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    return details;
  }

  @override
  Future deliveryManWithdrawList(int offset, String status) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.deliveryManWithdrawList(offset, status);
   if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      return apiResponse;
   } else {
     ApiChecker.checkApi(apiResponse);
   }
  }


  @override
  Future getDeliveryManList() async{
    ApiResponse apiResponse = await deliveryManRepoInterface.getDeliveryManList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
     return apiResponse;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future getDeliveryManReviewList(int offset, int? id) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.getDeliveryManReviewList(offset, id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      return apiResponse;
      } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future getDeliverymanOrderHistoryLog(int? orderId) async{
    ApiResponse apiResponse = await deliveryManRepoInterface.getDeliverymanOrderHistoryLog(orderId);
    List<OrderHistoryLogModel> changeLogList =[];
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      apiResponse.response!.data.forEach((changeLog){
        OrderHistoryLogModel log = OrderHistoryLogModel.fromJson(changeLog);
        changeLogList.add(log);
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    return changeLogList;
  }

  @override
  Future getTopDeliveryManList() async{
    ApiResponse apiResponse = await deliveryManRepoInterface.getTopDeliveryManList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
     return apiResponse;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  Future getDeliveryManCollectedCashList(int? id, int offset) async{
    return await deliveryManRepoInterface.getDeliveryManCollectedCashList(id, offset);

  }
}