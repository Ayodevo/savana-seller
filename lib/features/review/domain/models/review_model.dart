import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';

class ReviewModel {
  int? id;
  int? productId;
  int? customerId;
  int? orderId;
  String? comment;
  List<String>? attachment;
  double? rating;
  int? status;
  String? createdAt;
  String? updatedAt;
  Product? product;
  Customer? customer;
  Reply? reply;
  List<ImageFullUrl>? attachmentFullUrl;
  bool? isSaved;

  ReviewModel(
      {this.id,
        this.productId,
        this.customerId,
        this.orderId,
        this.comment,
        this.attachment,
        this.rating,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.customer,
        this.reply,
        this.attachmentFullUrl,
        this.isSaved});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    customerId = json['customer_id'];
    if(json['order_id'] != null){
      orderId = json['order_id'];
    }
    comment = json['comment'];
    if(json['attachment'] != null){
      try{
        // attachment = json['attachment'].cast<String>();
      }catch(e){
        // attachment = jsonDecode(json['attachment']).cast<String>();
      }

    }

    rating = json['rating'].toDouble();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    customer = json['customer'] != null ?  Customer.fromJson(json['customer']) : null;
    reply = json['reply'] != null ?  Reply.fromJson(json['reply']) : null;
    if (json['attachment_full_url'] != null) {
      attachmentFullUrl = <ImageFullUrl>[];
      json['attachment_full_url'].forEach((v) {
        attachmentFullUrl!.add(ImageFullUrl.fromJson(v));
      });
    }
    isSaved = json['is_saved']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['customer_id'] = customerId;
    data['comment'] = comment;
    data['attachment'] = attachment;
    data['rating'] = rating;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (reply != null) {
      data['reply'] = reply!.toJson();
    }
    return data;
  }
}

// class Product {
//   int? id;
//   String? name;
//   String? thumbnail;
//   ImageFullUrl? thumbnailFullUrl;
//   String? productType;
//   Product(
//       {this.id,
//         this.name,
//         this.thumbnail,
//         this.productType,
//         this.thumbnailFullUrl
//       });
//
//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     thumbnail = json['thumbnail'];
//     thumbnailFullUrl = json['thumbnail_full_url'] != null
//       ? ImageFullUrl.fromJson(json['thumbnail_full_url'])
//       : null;
//     productType = json['product_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['thumbnail'] = thumbnail;
//     data['product_type'] = productType;
//     return data;
//   }
// }

// class Customer {
//   int? id;
//   String? name;
//   String? fName;
//   String? lName;
//   String? image;
//   ImageFullUrl? imageFullUrl;
//
//
//   Customer(
//       {this.id,
//         this.name,
//         this.fName,
//         this.lName,
//         this.image,
//         this.imageFullUrl
//        });
//
//   Customer.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     fName = json['f_name'];
//     lName = json['l_name'];
//     image = json['image'];
//     imageFullUrl = json['image_full_url'] != null
//       ? ImageFullUrl.fromJson(json['image_full_url'])
//       : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['f_name'] = fName;
//     data['l_name'] = lName;
//     data['image'] = image;
//     return data;
//   }
// }

class Reply {
  int? id;
  int? reviewId;
  String? addedBy;
  String? replyText;
  String? createdAt;
  String? updatedAt;

  Reply(
      {this.id,
        this.reviewId,
        this.addedBy,
        this.replyText,
        this.createdAt,
        this.updatedAt});

  Reply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviewId = json['review_id'];
    addedBy = json['added_by'];
    replyText = json['reply_text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review_id'] = this.reviewId;
    data['added_by'] = this.addedBy;
    data['reply_text'] = this.replyText;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
