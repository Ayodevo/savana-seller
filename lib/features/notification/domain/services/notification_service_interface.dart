

abstract class NotificationServiceInterface {
  Future<dynamic> getNotificationList(int offset);
  Future<dynamic> seenNotification(int id);
}