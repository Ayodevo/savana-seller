
class EditProductModel {
  int? id;
  String? name;
  String? details;
  List<Translations>? translations;
  List<String>? digitalProductFileTypes;
  Map<String, dynamic>? digitalProductExtensions;
  List<DigitalVariation>? digitalVariation;
  SeoInfo? seoInfo;

  EditProductModel(
    {this.id,
      this.name,
      this.details,
      this.translations,
      this.digitalProductFileTypes,
      this.digitalProductExtensions,
      this.digitalVariation,
      this.seoInfo
    });

  EditProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    details = json['details'];
    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
    if(json['digital_product_file_types'] != null) {
      digitalProductFileTypes = json['digital_product_file_types'].cast<String>();
    }

    if(json['digital_product_extensions'] != null && json['digital_product_extensions'] is !List) {
      digitalProductExtensions = (json['digital_product_extensions'] as Map<String, dynamic>).map(
         (key, value) => MapEntry(key, List<String>.from(value)),
      );
    }

    if (json['digital_variation'] != null) {
      digitalVariation = <DigitalVariation>[];
      json['digital_variation'].forEach((v) {
        digitalVariation!.add(DigitalVariation.fromJson(v));
      });
    }
    seoInfo = json['seo_info'] != null
        ? new SeoInfo.fromJson(json['seo_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['details'] = details;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    if (digitalVariation != null) {
      data['digital_variation'] =
          digitalVariation!.map((v) => v.toJson()).toList();
    }
    if (seoInfo != null) {
      data['seo_info'] = seoInfo!.toJson();
    }
    return data;
  }
}


class Translations {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;

  Translations(
      {this.id,
        this.translationableType,
        this.translationableId,
        this.locale,
        this.key,
        this.value});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = int.parse(json['translationable_id'].toString());
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['variant_key'] = variantKey;
    data['sku'] = sku;
    data['price'] = price;
    data['file'] = file;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }


}



class SeoInfo {
  int? id;
  int? productId;
  String? title;
  String? description;
  String? index;
  String? noFollow;
  String? noImageIndex;
  String? noArchive;
  String? noSnippet;
  String? maxSnippet;
  String? maxSnippetValue;
  String? maxVideoPreview;
  String? maxVideoPreviewValue;
  String? maxImagePreview;
  String? maxImagePreviewValue;
  String? image;
  String? createdAt;
  String? updatedAt;

  SeoInfo(
      {this.id,
        this.productId,
        this.title,
        this.description,
        this.index,
        this.noFollow,
        this.noImageIndex,
        this.noArchive,
        this.noSnippet,
        this.maxSnippet,
        this.maxSnippetValue,
        this.maxVideoPreview,
        this.maxVideoPreviewValue,
        this.maxImagePreview,
        this.maxImagePreviewValue,
        this.image,
        this.createdAt,
        this.updatedAt});

  SeoInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'];
    description = json['description'];
    index = json['index'] == '' ? '1' : '0';
    noFollow = json['no_follow'] == '' ? '0' : '1';
    noImageIndex = json['no_image_index']  == '' ? '0' : '1';
    noArchive = json['no_archive']  == '' ? '0' : '1';
    noSnippet = json['no_snippet'];
    maxSnippet = json['max_snippet'];
    maxSnippetValue = json['max_snippet_value'];
    maxVideoPreview = json['max_video_preview'];
    maxVideoPreviewValue = json['max_video_preview_value'];
    maxImagePreview = json['max_image_preview'];
    maxImagePreviewValue = json['max_image_preview_value'];
    if(json['image'] != null){
      image = json['image'];
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['title'] = title;
    data['description'] = description;
    data['index'] = index;
    data['no_follow'] = noFollow;
    data['no_image_index'] = noImageIndex;
    data['no_archive'] = noArchive;
    data['no_snippet'] = noSnippet;
    data['max_snippet'] = maxSnippet;
    data['max_snippet_value'] = maxSnippetValue;
    data['max_video_preview'] = maxVideoPreview;
    data['max_video_preview_value'] = maxVideoPreviewValue;
    data['max_image_preview'] = maxImagePreview;
    data['max_image_preview_value'] = maxImagePreviewValue;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}