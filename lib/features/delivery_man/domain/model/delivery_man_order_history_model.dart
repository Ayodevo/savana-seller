import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';

class DeliveryManOrderHistoryModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Order>? orders;

  DeliveryManOrderHistoryModel(
      {this.totalSize, this.limit, this.offset, this.orders});

  DeliveryManOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
  }

}


