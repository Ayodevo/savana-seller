import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/image_model.dart';

class ProductImagesModel {
  List<ImagesStorage>? imagesStorage;
  List<ImagesStorage>? colorImagesStorage;
  List<ImageFullUrl>? images;
  List<ColorImage>? colorImage;

  ProductImagesModel({this.images, this.colorImage, this.colorImagesStorage, this.imagesStorage});

  ProductImagesModel.fromJson(Map<String, dynamic> json) {
    if (json['images_full_url'] != null) {
      images = <ImageFullUrl>[];
      json['images_full_url'].forEach((v) {
        images!.add(ImageFullUrl.fromJson(v));
      });
    }

    if (json['color_images_full_url'] != null) {
      colorImage = <ColorImage>[];
      json['color_images_full_url'].forEach((v) {
        colorImage!.add(ColorImage.fromJson(v));
      });
    }

    if (json['images'] != null) {
      imagesStorage = <ImagesStorage>[];
      json['images'].forEach((v) {
        if(v is String){
          imagesStorage!.add(
              ImagesStorage(
                  imageName: v,
                  storage: 'public'
              )
          );
        } else {
          json['images'].forEach((v) {
            imagesStorage!.add(ImagesStorage.fromJson(v));
          });
        }
      });
    }

    if (json['color_image'] != null) {
      colorImagesStorage = <ImagesStorage>[];
      json['color_image'].forEach((v) {
        if(v is String){
          colorImagesStorage!.add(
              ImagesStorage(
                  imageName: v,
                  storage: 'public'
              )
          );
        } else {
          json['color_image'].forEach((v) {
            colorImagesStorage!.add(ImagesStorage.fromJson(v));
          });
        }
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['images'] = images;
    if (colorImage != null) {
      data['color_images_full_url'] = colorImage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ImagesStorage {
  String? imageName;
  String? storage;

  ImagesStorage({this.imageName, this.storage});

  ImagesStorage.fromJson(Map<String, dynamic> json) {
    imageName = json['image_name'];
    storage = json['storage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_name'] = imageName;
    data['storage'] = storage;
    return data;
  }
}

