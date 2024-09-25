
import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';

class OrderDetailsModel {
  int? id;
  int? orderId;
  int? productId;
  int? sellerId;
  String? digitalFileAfterSell;
  ProductDetails? productDetails;
  int? qty;
  double? price;
  double? tax;
  double? discount;
  String? taxModel;
  String? deliveryStatus;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;
  String? shippingMethodId;
  String? variant;
  String? variation;
  String? discountType;
  int? refundRequest;
  List<VerificationImages>? verificationImages;
  ImageFullUrl? digitalFileAfterSellFullUrl;
  ImageFullUrl? digitalFileReadyFullUrl;
  Order? order;

  OrderDetailsModel(
      {this.id,
        this.orderId,
        this.productId,
        this.sellerId,
        this.digitalFileAfterSell,
        this.productDetails,
        this.qty,
        this.price,
        this.tax,
        this.discount,
        this.taxModel,
        this.deliveryStatus,
        this.paymentStatus,
        this.createdAt,
        this.updatedAt,
        this.shippingMethodId,
        this.variant,
        this.variation,
        this.discountType,
        this.refundRequest,
        this.verificationImages,
        this.digitalFileAfterSellFullUrl,
        this.digitalFileReadyFullUrl,
        this.order
      });

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    sellerId = json['seller_id'];
    digitalFileAfterSell = json['digital_file_after_sell'];
    productDetails = (json['product_details'] != null && json['product_details'] is !String) ? ProductDetails.fromJson(json['product_details']) : null;
    qty = json['qty'];
    price = json['price'].toDouble();
    tax = json['tax'].toDouble();
    discount = json['discount'].toDouble();
    taxModel = json['tax_model'];
    deliveryStatus = json['delivery_status'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shippingMethodId = json['shipping_method_id'];
    variant = json['variant'];
    variation = json['variation'];
    discountType = json['discount_type'];
    refundRequest = json['refund_request'];
    if (json['verification_images'] != null) {
      verificationImages = <VerificationImages>[];
      json['verification_images'].forEach((v) {
        verificationImages!.add(VerificationImages.fromJson(v));
      });
    }
    digitalFileAfterSellFullUrl = json['digital_file_after_sell_full_url'] != null
      ? ImageFullUrl.fromJson(json['digital_file_after_sell_full_url']) : null;


    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

}



class ProductDetails {
  int? _id;
  String? _addedBy;
  int? _userId;
  String? _name;
  String? _productType;
  List<CategoryIds>? _categoryIds;
  int? _brandId;
  String? _unit;
  int? _minQty;
  List<String>? _images;
  String? _thumbnail;
  List<Colores>? _colors;
  List<ChoiceOptions>? _choiceOptions;
  List<Variation>? _variation;
  double? _unitPrice;
  double? _purchasePrice;
  double? _tax;
  String? _taxModel;
  String? _taxType;
  double? _discount;
  String? _discountType;
  int? _currentStock;
  String? _details;
  int? _freeShipping;
  String? _createdAt;
  String? _updatedAt;
  String? _digitalProductType;
  String? _digitalFileReady;
  ImageFullUrl? _thumbnailFullUrl;
  List<DigitalVariation>? _digitalVariation;
  ImageFullUrl? digitalFileReadyFullUrl;


  ProductDetails(
      {int? id,
        String? addedBy,
        int? userId,
        String? name,
        String? productType,
        List<CategoryIds>? categoryIds,
        int? brandId,
        String? unit,
        int? minQty,
        List<String>? images,
        String? thumbnail,
        ImageFullUrl? thumbnailFullUrl,
        List<Colores>? colors,
        List<String>? attributes,
        List<ChoiceOptions>? choiceOptions,
        List<Variation>? variation,
        double? unitPrice,
        double? purchasePrice,
        double? tax,
        String? taxModel,
        String? taxType,
        double? discount,
        String? discountType,
        int? currentStock,
        String? details,
        String? createdAt,
        String? updatedAt,
        String? digitalProductType,
        String? digitalFileReady,
        List<DigitalVariation>? digitalVariation,
      }) {
    _id = id;
    _addedBy = addedBy;
    _userId = userId;
    _name = name;
    _productType = productType;
    _categoryIds = categoryIds;
    _brandId = brandId;
    _unit = unit;
    _minQty = minQty;
    _images = images;
    _thumbnail = thumbnail;
    _colors = colors;
    _choiceOptions = choiceOptions;
    _variation = variation;
    _unitPrice = unitPrice;
    _purchasePrice = purchasePrice;
    _tax = tax;
    _taxModel = taxModel;
    _taxType = taxType;
    _discount = discount;
    _discountType = discountType;
    _currentStock = currentStock;
    _details = details;
    _freeShipping = freeShipping;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _thumbnailFullUrl = thumbnailFullUrl;
    if (digitalProductType != null) {
      _digitalProductType = digitalProductType;
    }
    if (digitalFileReady != null) {
      _digitalFileReady = digitalFileReady;
    }

    if (digitalVariation != null) {
      _digitalVariation = digitalVariation;
    }
    this.digitalFileReadyFullUrl;
  }

  int? get id => _id;
  String? get addedBy => _addedBy;
  int? get userId => _userId;
  String? get name => _name;
  String? get productType => _productType;
  List<CategoryIds>? get categoryIds => _categoryIds;
  int? get brandId => _brandId;
  String? get unit => _unit;
  int? get minQty => _minQty;
  List<String>? get images => _images;
  String? get thumbnail => _thumbnail;
  ImageFullUrl? get thumbnailFullUrl => _thumbnailFullUrl;
  List<Colores>? get colors => _colors;
  List<ChoiceOptions>? get choiceOptions => _choiceOptions;
  List<Variation>? get variation => _variation;
  double? get unitPrice => _unitPrice;
  double? get purchasePrice => _purchasePrice;
  double? get tax => _tax;
  String? get taxModel => _taxModel;
  String? get taxType => _taxType;
  double? get discount => _discount;
  String? get discountType => _discountType;
  int? get currentStock => _currentStock;
  String? get details => _details;
  int? get freeShipping => _freeShipping;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get digitalProductType => _digitalProductType;
  String? get digitalFileReady => _digitalFileReady;
  List<DigitalVariation>? get digitalVariation => _digitalVariation;


  ProductDetails.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addedBy = json['added_by'];
    _userId = json['user_id'];
    _name = json['name'];
    _productType = json['product_type'];
    if (json['category_ids'] != null) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    _brandId = json['brand_id'];
    _unit = json['unit'];
    _minQty = json['min_qty'];
    if(json['images'] is List){
      _images = json['images'].cast<String>();
    }
    _thumbnail = json['thumbnail'];
    if (json['colors_formatted'] != null) {
      _colors = [];
      json['colors_formatted'].forEach((v) {
        _colors!.add(Colores.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions!.add(ChoiceOptions.fromJson(v));
      });
    }
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation!.add(Variation.fromJson(v));
      });
    }
    _unitPrice = json['unit_price'].toDouble();
    _purchasePrice = json['purchase_price'].toDouble();
    _tax = json['tax'].toDouble();
    if(json['tax_model'] == null){
      _taxModel = 'exclude';
    }else{
      _taxModel = json['tax_model'];
    }
    _taxType = json['tax_type'];
    _discount = json['discount'].toDouble();
    _discountType = json['discount_type'];
    _currentStock = json['current_stock'];
    _details = json['details'];
    _freeShipping = json['free_shipping'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if(json['digital_product_type']!=null){
      _digitalProductType = json['digital_product_type'];
    }
    if(json['digital_file_ready']!=null){
      _digitalFileReady = json['digital_file_ready'];
    }
    _thumbnailFullUrl = json['thumbnail_full_url'] != null
        ? ImageFullUrl.fromJson(json['thumbnail_full_url'])
        : null;
    if (json['digital_variation'] != null) {
      _digitalVariation = <DigitalVariation>[];
      json['digital_variation'].forEach((v) {
        _digitalVariation!.add(DigitalVariation.fromJson(v));
      });
    }
    digitalFileReadyFullUrl = json['digital_file_ready_full_url'] != null
        ? ImageFullUrl.fromJson(json['digital_file_ready_full_url']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['added_by'] = _addedBy;
    data['user_id'] = _userId;
    data['name'] = _name;
    data['product_type'] = productType;
    if (_categoryIds != null) {
      data['category_ids'] = _categoryIds!.map((v) => v.toJson()).toList();
    }
    data['brand_id'] = _brandId;
    data['unit'] = _unit;
    data['min_qty'] = _minQty;
    data['images'] = _images;
    data['thumbnail'] = _thumbnail;
    if (_colors != null) {
      data['colors_formatted'] = _colors!.map((v) => v.toJson()).toList();
    }
    if (_choiceOptions != null) {
      data['choice_options'] =
          _choiceOptions!.map((v) => v.toJson()).toList();
    }
    if (_variation != null) {
      data['variation'] = _variation!.map((v) => v.toJson()).toList();
    }
    data['unit_price'] = _unitPrice;
    data['purchase_price'] = _purchasePrice;
    data['tax'] = _tax;
    data['tax_model'] = _taxModel;
    data['tax_type'] = _taxType;
    data['discount'] = _discount;
    data['discount_type'] = _discountType;
    data['current_stock'] = _currentStock;
    data['details'] = _details;
    data['free_shipping'] = _freeShipping;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['digital_product_type'] = digitalProductType;
    data['digital_file_ready'] = digitalFileReady;
    return data;
  }
}

class CategoryIds {
  String? _id;
  int? _position;

  CategoryIds({String? id, int? position}) {
    _id = id;
    _position = position;
  }

  String? get id => _id;
  int? get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['position'] = _position;
    return data;
  }
}

class Colores {
  String? _name;
  String? _code;

  Colores({String? name, String? code}) {
    _name = name;
    _code = code;
  }

  String? get name => _name;
  String? get code => _code;

  Colores.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    data['code'] = _code;
    return data;
  }
}

class ChoiceOptions {
  String? _name;
  String? _title;
  List<String>? _options;

  ChoiceOptions({String? name, String? title, List<String>? options}) {
    _name = name;
    _title = title;
    _options = options;
  }

  String? get name => _name;
  String? get title => _title;
  List<String>? get options => _options;

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    data['title'] = _title;
    data['options'] = _options;
    return data;
  }
}

class Variation {
  String? _type;
  double? _price;
  String? _sku;
  int? _qty;

  Variation({String? type, double? price, String? sku, int? qty}) {
    _type = type;
    _price = price;
    _sku = sku;
    _qty = qty;
  }

  String? get type => _type;
  double? get price => _price;
  String? get sku => _sku;
  int? get qty => _qty;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _price = json['price'].toDouble();
    _sku = json['sku'];
    _qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = _type;
    data['price'] = _price;
    data['sku'] = _sku;
    data['qty'] = _qty;
    return data;
  }
}

class Shipping {
  int? _id;
  int? _creatorId;
  String? _creatorType;
  String? _title;
  int? _cost;
  String? _duration;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  Shipping(
      {int? id,
        int? creatorId,
        String? creatorType,
        String? title,
        int? cost,
        String? duration,
        int? status,
        String? createdAt,
        String? updatedAt}) {
    _id = id;
    _creatorId = creatorId;
    _creatorType = creatorType;
    _title = title;
    _cost = cost;
    _duration = duration;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get creatorId => _creatorId;
  String? get creatorType => _creatorType;
  String? get title => _title;
  int? get cost => _cost;
  String? get duration => _duration;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Shipping.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _creatorId = json['creator_id'];
    _creatorType = json['creator_type'];
    _title = json['title'];
    _cost = json['cost'];
    _duration = json['duration'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['creator_id'] = _creatorId;
    data['creator_type'] = _creatorType;
    data['title'] = _title;
    data['cost'] = _cost;
    data['duration'] = _duration;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
class VerificationImages {
  int? id;
  int? orderId;
  String? image;
  ImageFullUrl? imageFullUrl;
  String? createdAt;
  String? updatedAt;

  VerificationImages(
      {this.id, this.orderId, this.image, this.imageFullUrl, this.createdAt, this.updatedAt});

  VerificationImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = int.parse(json['order_id'].toString());
    image = json['image'];
    imageFullUrl = json['icon_full_url'] != null
      ? ImageFullUrl.fromJson(json['icon_full_url'])
      : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class DigitalVariation {
  int? id;
  int? productId;
  String? variantKey;
  String? sku;
  int? price;
  String? file;
  String? createdAt;
  String? updatedAt;

  DigitalVariation(
      {this.id,
        this.productId,
        this.variantKey,
        this.sku,
        this.price,
        this.file,
        this.createdAt,
        this.updatedAt});

  DigitalVariation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    variantKey = json['variant_key'];
    sku = json['sku'];
    price = json['price'];
    file = json['file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['variant_key'] = this.variantKey;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['file'] = this.file;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }


}