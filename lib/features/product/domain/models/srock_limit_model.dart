import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';

class StockLimitStatus {
  String? status;
  int? productCount;
  Product? product;

  StockLimitStatus({this.status, this.productCount, this.product});

  StockLimitStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    productCount = json['product_count'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['product_count'] = productCount;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}


