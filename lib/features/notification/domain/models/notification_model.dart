class NotificationItemModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? newNotificationItem;
  List<NotificationItem>? notification;

  NotificationItemModel(
      {this.totalSize,
        this.limit,
        this.offset,
        this.newNotificationItem,
        this.notification});

  NotificationItemModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    newNotificationItem = json['new_notification'];
    if (json['notification'] != null) {
      notification = <NotificationItem>[];
      json['notification'].forEach((v) {
        notification!.add(NotificationItem.fromJson(v));
      });
    }
  }

}

class NotificationItem {
  int? id;
  String? title;
  String? description;
  String? image;
  String? createdAt;
  int? notificationSeenStatus;

  NotificationItem(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.createdAt,
        this.notificationSeenStatus});

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    createdAt = json['created_at'];
    notificationSeenStatus = json['notification_seen_status'];
  }

}
