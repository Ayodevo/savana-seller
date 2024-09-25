import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileUploadModel {
  TextEditingController? priceController;
  TextEditingController? skuController;
  XFile? file;
  String? fileName;


  FileUploadModel(
    {
      this.priceController,
      this.skuController,
      this.file,
      this.fileName
    }
  );
}