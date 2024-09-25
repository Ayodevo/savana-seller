import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class ShopModel {
  int? id;
  String? name;
  String? address;
  String? contact;
  String? image;
  ImageFullUrl? imageFullUrl;
  String? createdAt;
  String? updatedAt;
  String? banner;
  ImageFullUrl? bannerFullUrl;
  String? bottomBanner;
  ImageFullUrl? bottomBannerFullUrl;
  String? offerBanner;
  ImageFullUrl? offerBannerFullUrl;
  double? ratting;
  int? rattingCount;
  bool? temporaryClose;
  String? vacationEndDate;
  String? vacationStartDate;
  bool? vacationStatus;



  ShopModel(
      {this.id,
        this.name,
        this.address,
        this.contact,
        this.image,
        this.imageFullUrl,
        this.createdAt,
        this.updatedAt,
        this.banner,
        this.bannerFullUrl,
        this.bottomBanner,
        this.bottomBannerFullUrl,
        this.offerBanner,
        this.offerBannerFullUrl,
        this.ratting,
        this.rattingCount,
        this.temporaryClose,
        this.vacationEndDate,
        this.vacationStartDate,
        this.vacationStatus
      });

  ShopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    contact = json['contact'];
    image = json['image'];
    imageFullUrl = json['image_full_url'] != null
      ? ImageFullUrl.fromJson(json['image_full_url'])
      : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    banner = json['banner'];
    bottomBanner = json['bottom_banner'];
    offerBanner = json['offer_banner'];
    ratting = json['rating'].toDouble();
    rattingCount = json['rating_count'];
    temporaryClose = json['temporary_close']??false;
    vacationEndDate = json['vacation_end_date'];
    vacationStartDate = json['vacation_start_date'];
    vacationStatus = json['vacation_status']??false;
    offerBannerFullUrl = json['offer_banner_full_url'] != null
      ? ImageFullUrl.fromJson(json['offer_banner_full_url'])
      : null;
    bannerFullUrl = json['banner_full_url'] != null
        ? ImageFullUrl.fromJson(json['banner_full_url'])
        : null;
    bottomBannerFullUrl = json['bottom_banner_full_url'] != null
        ? ImageFullUrl.fromJson(json['bottom_banner_full_url'])
        : null;
  }

}
