class AddProductModel{
  List<String>? titleList;
  List<String>? descriptionList;
  List<String?>? languageList;
  List<String?>? colorCodeList;
  List<String>? thumbnailList;
  String? videoUrl;

  AddProductModel({this.titleList, this.descriptionList, this.languageList, this.colorCodeList, this.thumbnailList, this.videoUrl});
}



class DigitalVariationModel{
  List<String>? variationType;
  List<String>? digitalVariantKey;
  List<List<String>>? variationKeys;
  Map<String, dynamic>? digitalVariantSku;
  Map<String, dynamic>? digitalVariantPrice;
  Map<String, dynamic>? digitalVariantFiles;
  Map<String, dynamic>? digitalVariantKeyMap;

  DigitalVariationModel({this.variationType, this.digitalVariantKey, this.digitalVariantSku, this.digitalVariantPrice});
}