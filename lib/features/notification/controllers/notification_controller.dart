import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/notification/domain/models/notification_model.dart';
import 'package:sixvalley_vendor_app/features/notification/domain/services/notification_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class NotificationController with ChangeNotifier{

  final NotificationServiceInterface notificationServiceInterface ;
  NotificationController({required this.notificationServiceInterface});


  NotificationItemModel? notificationModel;


  Future<void> getNotificationList(int offset) async{
    ApiResponse apiResponse = await notificationServiceInterface.getNotificationList(offset);
    if(apiResponse.response?.statusCode == 200) {
      if(offset == 1){
        notificationModel = NotificationItemModel.fromJson(apiResponse.response?.data);
      }else{
        notificationModel?.notification?.addAll(NotificationItemModel.fromJson(apiResponse.response?.data).notification!);
        notificationModel?.offset = NotificationItemModel.fromJson(apiResponse.response?.data).offset;
        notificationModel?.totalSize = NotificationItemModel.fromJson(apiResponse.response?.data).totalSize;
      }
    }else{
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  Future<void> seenNotification(int id) async{
    ResponseModel responseModel = await notificationServiceInterface.seenNotification(id);
    if(responseModel.isSuccess){
      getNotificationList(1);
    }
    notifyListeners();
  }
}