import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_details_model.dart';


class OrderModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Order>? orders;

  OrderModel({this.totalSize, this.limit, this.offset, this.orders});

  OrderModel.fromJson(Map<String, dynamic> json) {
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


class Order {
  int? id;
  int? _customerId;
  String? _customerType;
  String? _paymentStatus;
  String? orderStatus;
  String? _paymentMethod;
  String? _transactionRef;
  double? _orderAmount;
  BillingAddressData? _shippingAddressData;
  BillingAddressData? _billingAddressData;
  String? _createdAt;
  String? _updatedAt;
  double? _discountAmount;
  double? _shippingCost;
  String? _discountType;
  Customer? _customer;
  int? _deliveryManId;
  String? _orderNote;
  String? _orderType;
  Shipping? _shipping;
  double? _extraDiscount;
  String? _extraDiscountType;
  String? _deliveryType;
  String? _thirdPartyServiceName;
  String? _thirdPartyTrackingId;
  double? _deliverymanCharge;
  String? _expectedDeliveryDate;
  DeliveryMan? deliveryMan;
  OfflinePayments? _offlinePayments;
  String?tRef;
  String? paymentBy;
  String? paymentNote;
  bool? isGuest;
  String? verificationCode;
  double? totalProductPrice;
  double? totalProductDiscount;
  double? totalTaxAmount;
  List<OrderDetailsModel>? orderDetails;

  Order(
      {int? id,
        int? customerId,
        String? customerType,
        String? paymentStatus,
        String? orderStatus,
        String? paymentMethod,
        String? transactionRef,
        double? orderAmount,
        BillingAddressData? shippingAddressData,
        BillingAddressData? billingAddressData,
        double? shippingCost,
        String? createdAt,
        String? updatedAt,
        double? discountAmount,
        String? discountType,
        Customer? customer,
        int? deliveryManId,
        String? orderNote,
        String? orderType,
        Shipping? shipping,
        double? extraDiscount,
        String? extraDiscountType,
        String? deliveryType,
        String? thirdPartyServiceNam,
        String? thirdPartyTrackingId,
        double? deliverymanCharge,
        String? expectedDeliveryDate,
        DeliveryMan? deliveryMan,
        OfflinePayments? offlinePayments,
        String? tRef,
        String? paymentBy,
        String? paymentNote,
        int? isGuest,
        String? verificationCode,

      }) {
    id = id;
    _customerId = customerId;
    _customerType = customerType;
    _paymentStatus = paymentStatus;
    orderStatus = orderStatus;
    _paymentMethod = paymentMethod;
    _transactionRef = transactionRef;
    _orderAmount = orderAmount;
    _shippingAddressData = shippingAddressData;
    _billingAddressData = billingAddressData;
    _shippingCost = shippingCost;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _discountAmount = discountAmount;
    _discountType = discountType;
    _customer = customer;
    _deliveryManId = deliveryManId;
    _orderNote = orderNote;
    _orderType = orderType;
    if (shipping != null) {
      _shipping = shipping;
    }
    if (extraDiscount != null) {
      _extraDiscount = extraDiscount;
    }
    if (extraDiscountType != null) {
      _extraDiscountType = extraDiscountType;
    }
    if (deliveryType != null) {
      _deliveryType = deliveryType;
    }
    if (thirdPartyServiceNam != null) {
      _thirdPartyServiceName = thirdPartyServiceNam;
    }
    if (thirdPartyTrackingId != null) {
      _thirdPartyTrackingId = thirdPartyTrackingId;
    }
    _deliverymanCharge = deliverymanCharge;
    _expectedDeliveryDate = expectedDeliveryDate;
    if (deliveryMan != null) {
      this.deliveryMan = deliveryMan;
    }
    if (offlinePayments != null) {
      _offlinePayments = offlinePayments;
    }
    this.tRef;
    this.paymentBy;
    this.paymentNote;
    this.isGuest;
    this.verificationCode;
    this.totalProductPrice;
    this.totalProductDiscount;
    this.totalTaxAmount;
    this.orderDetails;
  }


  int? get customerId => _customerId;
  String? get customerType => _customerType;
  String? get paymentStatus => _paymentStatus;
  String? get paymentMethod => _paymentMethod;
  String? get transactionRef => _transactionRef;
  double? get orderAmount => _orderAmount;
  double? get shippingCost => _shippingCost;
  BillingAddressData? get shippingAddressData => _shippingAddressData;
  BillingAddressData? get billingAddressData => _billingAddressData;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  double? get discountAmount => _discountAmount;
  String? get discountType => _discountType;
  Customer? get customer => _customer;
  int? get deliveryManId =>_deliveryManId;
  String? get orderNote => _orderNote;
  String? get orderType => _orderType;
  Shipping? get shipping => _shipping;
  double? get extraDiscount => _extraDiscount;
  String? get extraDiscountType => _extraDiscountType;
  String? get deliveryType => _deliveryType;
  String? get  thirdPartyServiceName => _thirdPartyServiceName;
  String? get  thirdPartyTrackingId => _thirdPartyTrackingId;
  double? get deliverymanCharge => _deliverymanCharge;
  String? get expectedDeliveryDate => _expectedDeliveryDate;
  OfflinePayments? get offlinePayments => _offlinePayments;


  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _customerId = json['customer_id'];
    _customerType = json['customer_type'];
    _paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    _paymentMethod = json['payment_method'];
    _transactionRef = json['transaction_ref'];
    paymentBy = json['payment_by'];
    paymentNote = json['payment_note'];
    if(json['order_amount'] != null){
      try{
        _orderAmount = json['order_amount'].toDouble();
      }catch(e){
        _orderAmount = double.parse(json['order_amount'].toString());
      }
    }
    if(json['shipping_cost'] != null){
      _shippingCost = json['shipping_cost'].toDouble();
    }

    if(json['shipping_address_data'] != null){
      _shippingAddressData =  BillingAddressData.fromJson(json['shipping_address_data']);

    }
    if(json['billing_address_data'] != null){
      _billingAddressData =  BillingAddressData.fromJson(json['billing_address_data']);
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if(json['delivery_man_id'] != null){
      _deliveryManId = json['delivery_man_id'];
    }

    if(json['discount_amount']!=null){
      _discountAmount = json['discount_amount'].toDouble();
    }

    _discountType = json['discount_type'];
    _customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    _orderNote = json['order_note'];
    _orderType = json['order_type'];
    _shipping = json['shipping'] != null
        ? Shipping.fromJson(json['shipping'])
        : null;
    if(json['extra_discount'] != null){
      _extraDiscount = json['extra_discount'].toDouble();
    }

    _extraDiscountType = json['extra_discount_type'];
    if(json['delivery_type']!=null && json['delivery_type']!= ""){
      _deliveryType = json['delivery_type'];
    }
    if(json['delivery_service_name']!=null && json['delivery_service_name']!= ""){
      _thirdPartyServiceName = json['delivery_service_name'];
    }
    if(json['third_party_delivery_tracking_id']!=null && json['third_party_delivery_tracking_id']!= ""){
      _thirdPartyTrackingId = json['third_party_delivery_tracking_id'];
    }
    if(json['deliveryman_charge'] != null){
      try{
        _deliverymanCharge = json['deliveryman_charge'].toDouble();
      }catch(e){
        _deliverymanCharge = double.parse(json['deliveryman_charge'].toString());
      }
    }

    _expectedDeliveryDate = json['expected_delivery_date'];
    deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null;
    _offlinePayments = json['offline_payments'] != null ? OfflinePayments.fromJson(json['offline_payments']) : null;
    isGuest = json['is_guest']??false;
    verificationCode = json['verification_code'];
    if(json['total_product_price'] != null){
      totalProductPrice = double.parse(json['total_product_price'].toString());
    }

    if(json['total_product_discount'] != null){
      totalProductDiscount = double.parse(json['total_product_discount'].toString());
    }

    if(json['total_tax_amount'] != null){
      totalTaxAmount = double.parse(json['total_tax_amount'].toString());
    }
    if (json['order_details'] != null) {
      orderDetails = <OrderDetailsModel>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(OrderDetailsModel.fromJson(v));
      });
    }

  }

}

class Customer {
  int? _id;
  String? _name;
  String? _fName;
  String? _lName;
  String? _phone;
  String? _image;
  ImageFullUrl? _imageFullPath;
  String? _email;
  String? _emailVerifiedAt;
  String? _createdAt;
  String? _updatedAt;
  String? _streetAddress;
  String? _country;
  String? _city;
  String? _zip;
  String? _houseNo;
  String? _apartmentNo;
  String? _cmFirebaseToken;
  DeliveryMan? _deliveryMan;

  Customer(
      {int? id,
        String? name,
        String? fName,
        String? lName,
        String? phone,
        String? image,
        ImageFullUrl? imageFullPath,
        String? email,
        String? emailVerifiedAt,
        String? createdAt,
        String? updatedAt,
        String? streetAddress,
        String? country,
        String? city,
        String? zip,
        String? houseNo,
        String? apartmentNo,
        String? cmFirebaseToken,
        DeliveryMan? deliveryMan,
      }) {
    _id = id;
    _name = name;
    _fName = fName;
    _lName = lName;
    _phone = phone;
    _image = image;
    _email = email;
    _emailVerifiedAt = emailVerifiedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _streetAddress = streetAddress;
    _country = country;
    _city = city;
    _zip = zip;
    _houseNo = houseNo;
    _apartmentNo = apartmentNo;
    _cmFirebaseToken = cmFirebaseToken;
    if (deliveryMan != null) {
      _deliveryMan = deliveryMan;
    }
    _imageFullPath = imageFullPath;
  }

  int? get id => _id;
  String? get name => _name;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get phone => _phone;
  String? get image => _image;
  String? get email => _email;
  String? get emailVerifiedAt => _emailVerifiedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get streetAddress => _streetAddress;
  String? get country => _country;
  String? get city => _city;
  String? get zip => _zip;
  String? get houseNo => _houseNo;
  String? get apartmentNo => _apartmentNo;
  String? get cmFirebaseToken => _cmFirebaseToken;
  DeliveryMan? get deliveryMan => _deliveryMan;
  ImageFullUrl? get imageFullPath => _imageFullPath;

  Customer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    if(json['f_name']!=null){
      _fName = json['f_name'];
    }

    if(json['l_name']!=null){
      _lName = json['l_name'];
    }

    _phone = json['phone'];
    _image = json['image'];
    _email = json['email'];
    _emailVerifiedAt = json['email_verified_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _streetAddress = json['street_address'];
    _country = json['country'];
    _city = json['city'];
    _zip = json['zip'];
    _houseNo = json['house_no'];
    _apartmentNo = json['apartment_no'];
    _cmFirebaseToken = json['cm_firebase_token'];
    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
    _imageFullPath = json['image_full_url'] != null
      ? ImageFullUrl.fromJson(json['image_full_url'])
      : null;
  }

}


class BillingAddressData {
  int? id;
  String? contactPersonName;
  String? addressType;
  String? address;
  String? city;
  String? zip;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? country;
  String? latitude;
  String? longitude;

  BillingAddressData(
      {this.id,
        this.contactPersonName,
        this.addressType,
        this.address,
        this.city,
        this.zip,
        this.phone,
        this.email,
        this.createdAt,
        this.updatedAt,
        this.country,
        this.latitude,
        this.longitude,
        });

  BillingAddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactPersonName = json['contact_person_name'];
    addressType = json['address_type'];
    address = json['address'];
    city = json['city'];
    zip = json['zip'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];

  }

}

class Shipping {
  int? _id;
  int? _creatorId;
  String? _creatorType;
  String? _title;
  double? _cost;
  String? _duration;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  Shipping(
      {int? id,
        int? creatorId,
        String? creatorType,
        String? title,
        double? cost,
        String? duration,
        int? status,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (creatorId != null) {
      _creatorId = creatorId;
    }
    if (creatorType != null) {
      _creatorType = creatorType;
    }
    if (title != null) {
      _title = title;
    }
    if (cost != null) {
      _cost = cost;
    }
    if (duration != null) {
      _duration = duration;
    }
    if (status != null) {
      _status = status;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  int? get creatorId => _creatorId;
  String? get creatorType => _creatorType;
  String? get title => _title;
  double? get cost => _cost;
  String? get duration => _duration;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Shipping.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _creatorId = json['creator_id'];
    _creatorType = json['creator_type'];
    _title = json['title'];
    _cost = double.parse(json['cost']);
    _duration = json['duration'];
    _status = json['status'] ? 1 : 0;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

}

class OfflinePayments {
  int? id;
  List<dynamic>? infoKey;
  List<dynamic>? infoValue;
  String? createdAt;

  OfflinePayments(
      {this.id,
        this.infoKey,
        this.infoValue,
        this.createdAt,

      });

  OfflinePayments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    infoKey = (json['payment_info'].length>0)? json['payment_info'].entries.map((e)=> e.key).toList():[];
    infoValue = (json['payment_info'].length>0)? json['payment_info'].entries.map((e)=> e.value).toList():[];
    createdAt = json['created_at'];
  }

}


class PaymentInfo {
  String? methodId;
  String? methodName;
  String? transactionId;
  String? accountNumber;
  String? accountHolderName;

  PaymentInfo(
      {this.methodId,
        this.methodName,
        this.transactionId,
        this.accountNumber,
        this.accountHolderName});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    methodId = json['method_id'];
    methodName = json['method_name'];
    transactionId = json['transaction_id'];
    accountNumber = json['account_number'];
    accountHolderName = json['account_holder_name'];
  }

}



