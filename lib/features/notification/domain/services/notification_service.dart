import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/notification/domain/services/notification_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class NotificationService implements NotificationServiceInterface{
  final NotificationRepositoryInterface notificationRepoInterface;
  NotificationService({required this.notificationRepoInterface});


  @override
  Future getNotificationList(int offset) async{
    return await notificationRepoInterface.getList(offset: offset);
  }

  @override
  Future seenNotification(int id) async{
    ApiResponse response = await notificationRepoInterface.seenNotification(id);
    if(response.response!.statusCode == 200) {
        return ResponseModel(true, '');
    }else{
      ApiChecker.checkApi( response);
    }
  }
}