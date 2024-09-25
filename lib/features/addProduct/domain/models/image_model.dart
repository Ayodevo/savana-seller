import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';

class ImageModel {
  String? type;
  String? color;
  XFile? image;
  String? imageString;
  ColorImage? colorImage;

  ImageModel({this.type, this.color, this.image, this.imageString,this.colorImage});

  ImageModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    color = json['color'];
    image = json['image'];
    imageString = json['image_string'];
    colorImage = json['color_image'] != null
        ? ColorImage.fromJson(json['color_image'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['color'] = color;
    data['image'] = image;
    data['image_string'] = imageString;
    if (colorImage != null) {
      data['color_image'] = colorImage!.toJson();
    }
    return data;
  }
}

class ColorImage {
  String? color;
  ImageFullUrl? imageName;
  String? storage;

  ColorImage({this.color, this.imageName, this.storage});

  ColorImage.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    imageName = json['image_name'] != null
      ? ImageFullUrl.fromJson(json['image_name'])
      : null;
    storage = json['storage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['image_name'] = imageName;
    data['storage'] = storage;
    return data;
  }
}