import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class ProfileInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? image;
  ImageFullUrl? imageFullUrl;
  String? email;
  String? password;
  String? status;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? bankName;
  String? branch;
  String? accountNo;
  String? holderName;
  String? authToken;
  double? salesCommissionPercentage;
  String? gst;
  int? productCount;
  int? posActive;
  int? ordersCount;
  Wallet? wallet;
  double? minimumOrderAmount;
  double? freeOverDeliveryAmount;
  int? freeOverDeliveryAmountStatus;

  ProfileInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.image,
        this.imageFullUrl,
        this.email,
        this.password,
        this.status,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.bankName,
        this.branch,
        this.accountNo,
        this.holderName,
        this.authToken,
        this.salesCommissionPercentage,
        this.gst,
        this.posActive,
        this.productCount,
        this.ordersCount,
        this.wallet,
        this.minimumOrderAmount,
        this.freeOverDeliveryAmount,
        this.freeOverDeliveryAmountStatus
      });

  ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    accountNo = json['account_no'];
    holderName = json['holder_name'];
    authToken = json['auth_token'];
    if(json['sales_commission_percentage']!=null){
      try{
        salesCommissionPercentage = (json['sales_commission_percentage']).toDouble();
      }catch(e){
        salesCommissionPercentage = double.parse(json['sales_commission_percentage'].toString());
      }


    }
    if(json['gst']!=null){
      gst = json['gst'];
    }
    posActive = int.parse(json['pos_status'].toString());
    productCount = json['product_count'];
    ordersCount = json['orders_count'];
    wallet =
    json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    if(json['minimum_order_amount'] != null){
      try{
        minimumOrderAmount = json['minimum_order_amount'].toDouble();
      }catch(e){
        minimumOrderAmount = double.parse(json['minimum_order_amount'].toString());
      }
    }else{
      minimumOrderAmount = 0;
    }
    if(json['free_delivery_over_amount'] != null){
      try{
        freeOverDeliveryAmount = json['free_delivery_over_amount'].toDouble();
      }catch(e){
        freeOverDeliveryAmount = double.parse(json['free_delivery_over_amount'].toString());
      }
    }else{
      freeOverDeliveryAmount = 0;
    }

    if(json['free_delivery_status'] != null){
      try{
        freeOverDeliveryAmountStatus = json['free_delivery_status'];
      }catch(e){
        freeOverDeliveryAmountStatus = int.parse(json['free_delivery_status'].toString());
      }
    }else{
      freeOverDeliveryAmountStatus = 0;
    }

    imageFullUrl = json['image_full_url'] != null
        ? ImageFullUrl.fromJson(json['image_full_url'])
        : null;
  }


}

class Wallet {
  int? id;
  double? totalEarning;
  double? withdrawn;
  String? createdAt;
  String? updatedAt;
  double? commissionGiven;
  double? pendingWithdraw;
  double? deliveryChargeEarned;
  double? collectedCash;
  double? totalTaxCollected;

  Wallet(
      {this.id,
        this.totalEarning,
        this.withdrawn,
        this.createdAt,
        this.updatedAt,
        this.commissionGiven,
        this.pendingWithdraw,
        this.deliveryChargeEarned,
        this.collectedCash,
        this.totalTaxCollected});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalEarning = json['total_earning'].toDouble();
    withdrawn = json['withdrawn'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    commissionGiven = json['commission_given'].toDouble();
    pendingWithdraw = json['pending_withdraw'].toDouble();
    deliveryChargeEarned = json['delivery_charge_earned'].toDouble();
    collectedCash = json['collected_cash'].toDouble();
    totalTaxCollected = json['total_tax_collected'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total_earning'] = totalEarning;
    data['withdrawn'] = withdrawn;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['commission_given'] = commissionGiven;
    data['pending_withdraw'] = pendingWithdraw;
    data['delivery_charge_earned'] = deliveryChargeEarned;
    data['collected_cash'] = collectedCash;
    data['total_tax_collected'] = totalTaxCollected;
    return data;
  }
}
