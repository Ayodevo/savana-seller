import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/image_full_url.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/attr.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/attribute_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/brand_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/category_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/file_upload_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/product_image_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/services/add_product_service_interface.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/edt_product_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/image_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/variant_type_model.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/dashboard_screen.dart';



class AddProductController extends ChangeNotifier {
  final AddProductServiceInterface shopServiceInterface;

  AddProductController({required this.shopServiceInterface});

  int _totalQuantity =0;
  int get totalQuantity => _totalQuantity;
  String? _unitValue;
  String? get unitValue => _unitValue;
  List<AttributeModel>? _attributeList = [];
  int _discountTypeIndex = 0;
  int _taxTypeIndex = 0;
  String _imagePreviewSelectedType = 'large';
  List<CategoryModel>? _categoryList;
  List<BrandModel>? _brandList;
  List<SubCategory>? _subCategoryList;
  List<SubSubCategory>? _subSubCategoryList;
  int? _categorySelectedIndex;
  int? _subCategorySelectedIndex;
  int? _subSubCategorySelectedIndex;
  int? _categoryIndex = 0;
  int? _subCategoryIndex = 0;
  int? _subSubCategoryIndex = 0;
  int? _brandIndex = 0;
  int _unitIndex = 0;
  List<String> _selectedDigitalVariation = [];
  List<List<String>> _digitalVariationExtension = [];
  List<List<FileUploadModel>> _variationFileList = [];
  List<TextEditingController> extentionControllerList = [];
  List<List<String>> editVariantKeys = [];
  List<List<bool>> _isDigitalVariationLoading = [];
  MetaSeoInfo? _metaSeoInfo = MetaSeoInfo();
  final TextEditingController maxSnippetController = TextEditingController();
  final TextEditingController maxImagePreviewController = TextEditingController();

  int get unitIndex => _unitIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? get categorySelectedIndex => _categorySelectedIndex;
  int? get subCategorySelectedIndex => _subCategorySelectedIndex;
  int? get subSubCategorySelectedIndex => _subSubCategorySelectedIndex;
  List<int> _selectedColor = [];
  List<int> get selectedColor =>_selectedColor;
  List<int?> _categoryIds = [];
  List<int?> _subCategoryIds = [];
  List<int?> _subSubCategoryIds = [];
  List<int?> get categoryIds => _categoryIds;
  List<int?> get subCategoryIds => _subCategoryIds;
  List<int?> get subSubCategoryIds => _subSubCategoryIds;
  EditProductModel? _editProduct;
  EditProductModel? get editProduct => _editProduct;
  List<VariantTypeModel> _variantTypeList =[];
  List<AttributeModel>? get attributeList => _attributeList;
  int get discountTypeIndex => _discountTypeIndex;
  int get taxTypeIndex => _taxTypeIndex;
  String get imagePreviewSelectedType => _imagePreviewSelectedType;
  List<CategoryModel>? get categoryList => _categoryList;
  List<SubCategory>? get subCategoryList => _subCategoryList;
  List<SubSubCategory>? get subSubCategoryList => _subSubCategoryList;
  List<BrandModel>? get brandList => _brandList;
  XFile? _pickedLogo;
  XFile? _pickedCover;
  XFile? _pickedMeta;
  XFile? _coveredImage;
  List <XFile>_productImage = [];
  bool _isMultiply = false;
  bool get isMultiply => _isMultiply;
  XFile? get pickedLogo => _pickedLogo;
  XFile? get pickedCover => _pickedCover;
  XFile? get pickedMeta => _pickedMeta;
  XFile? get coveredImage => _coveredImage;
  List<XFile> get productImage => _productImage;
  int? get categoryIndex => _categoryIndex;
  int? get subCategoryIndex => _subCategoryIndex;
  int? get subSubCategoryIndex => _subSubCategoryIndex;
  int? get brandIndex => _brandIndex;
  List<VariantTypeModel> get variantTypeList => _variantTypeList;
  final picker = ImagePicker();
  List<TextEditingController> _titleControllerList = [];
  List<TextEditingController> _descriptionControllerList = [];
  List<String?> _colorCodeList =[];
  List<String?> get colorCodeList => _colorCodeList;
  List<TextEditingController>  get titleControllerList=> _titleControllerList;
  List<TextEditingController> get descriptionControllerList=> _descriptionControllerList;
  final TextEditingController _productCode = TextEditingController();
  TextEditingController get productCode => _productCode;
  List<FocusNode>? _titleNode;
  List<FocusNode>? _descriptionNode;
  List<FocusNode>? get titleNode => _titleNode;
  List<FocusNode>? get descriptionNode => _descriptionNode;
  int _productTypeIndex = 0;
  int get productTypeIndex => _productTypeIndex;
  int _digitalProductTypeIndex = 0;
  int get digitalProductTypeIndex => _digitalProductTypeIndex;
  File? _selectedFileForImport ;
  File? get selectedFileForImport =>_selectedFileForImport;
  String? _digitalProductFileName;
  String?  get digitalProductFileName =>_digitalProductFileName;
  List<bool?> _selectedCategory = [];
  List<bool?> get selectedCategory => _selectedCategory;
  int _totalVariantQuantity = 0;
  int get totalVariantQuantity => _totalVariantQuantity;
  // List<String?>? productReturnImage  = [];
  List<Map<String, dynamic>>? productReturnImage  = [];
  int _variationTotalQuantity = 0;
  int get variationTotalQuantity  => _variationTotalQuantity;
  final TextEditingController _totalQuantityController = TextEditingController(text: '1');
  TextEditingController get totalQuantityController => _totalQuantityController;
  bool _isCategoryLoading = false;
  bool get isCategoryLoading => _isCategoryLoading;
  int? _selectedPageIndex = 0;
  int? get selectedPageIndex => _selectedPageIndex;
  List<String> get selectedDigitalVariation => _selectedDigitalVariation;
  List<List<String>> get digitalVariationExtantion => _digitalVariationExtension;
  List<List<FileUploadModel>> get variationFileList => _variationFileList;
  List<List<bool>> get isDigitalVariationLoading => _isDigitalVariationLoading;
  MetaSeoInfo? get metaSeoInfo => _metaSeoInfo;

  List<String> pages = ['general_info', 'variation_setup', 'product_seo'];
  List<String> imagePreviewType = ['large', 'medium', 'small'];


  void setTitle(int index, String title) {
    _titleControllerList[index].text = title;
  }
  
  void setDescription(int index, String description) {
    _descriptionControllerList[index].text = description;
  }
  
  getTitleAndDescriptionList(List<Language> languageList, EditProductModel? edtProduct){
    _titleControllerList = [];
    _descriptionControllerList = [];
    for(int i= 0; i<languageList.length; i++){
      if(edtProduct != null){
        if(i==0){
          _titleControllerList.insert(i,TextEditingController(text: edtProduct.name)) ;
          _descriptionControllerList.add(TextEditingController(text: edtProduct.details)) ;
        } else{
          for (var lan in edtProduct.translations!) {
            if(lan.locale == languageList[i].code && lan.key == 'name'){
              _titleControllerList.add(TextEditingController(text: lan.value)) ;
            }
            if(lan.locale == languageList[i].code && lan.key == 'description'){
              _descriptionControllerList.add(TextEditingController(text: lan.value));
            }
          }
        }
      }
      else{
        _titleControllerList.add(TextEditingController());
        _descriptionControllerList.add(TextEditingController());
      }
    }
    if(edtProduct != null){
      if(_titleControllerList.length < languageList.length) {
        int l1 = languageList.length-_titleControllerList.length;
        for(int i=0; i<l1; i++) {
          _titleControllerList.add(TextEditingController(text: editProduct!.name));
        }
      }
      if(_descriptionControllerList.length < languageList.length) {
        int l0 = languageList.length-_descriptionControllerList.length;
        for(int i=0; i<l0; i++) {
          _descriptionControllerList.add(TextEditingController(text: editProduct!.details));
        }
      }
    }else {
      if(_titleControllerList.length < languageList.length) {
        int l = languageList.length-_titleControllerList.length;
        for(int i=0; i<l; i++) {
          _titleControllerList.add(TextEditingController());
        }
      }
      if(_descriptionControllerList.length < languageList.length) {
        int l2 = languageList.length-_descriptionControllerList.length;
        for(int i=0; i<l2; i++) {
          _descriptionControllerList.add(TextEditingController());
        }
      }
    }
  }

  Future <void> getAttributeList(BuildContext context, Product? product, String language) async {
    _attributeList = null;
    _discountTypeIndex = 0;
    // _categoryIndex = 0;
    // _subCategoryIndex = 0;
    // _subSubCategoryIndex = 0;
    _variationTotalQuantity = 0;
    _pickedLogo = null;
    _pickedMeta = null;
    _pickedCover = null;
    _selectedColor = [];
    _variantTypeList = [];
    ApiResponse response = await shopServiceInterface.getAttributeList(language);
    if (response.response != null && response.response!.statusCode == 200) {
      _attributeList = [];
      withColor =[];
      _attributeList!.add(AttributeModel(attribute: Attr(id : 0, name:'Color'), active: false,
          controller: TextEditingController(), variants: []));
      response.response!.data.forEach((attribute) {
        if (product != null && product.attributes!=null && product.attributes!.isNotEmpty) {
          bool active = product.attributes!.contains(Attr.fromJson(attribute).id);
          if (kDebugMode) {
            print('--------${Attr.fromJson(attribute).id}/$active/${product.attributes}');
          }
          List<String> options = [];
          if (active && product.choiceOptions != null && product.choiceOptions!.isNotEmpty) {
            options.addAll(product.choiceOptions![product.attributes!.indexOf(Attr.fromJson(attribute).id)].options!);
          }
          _attributeList!.add(AttributeModel(
            attribute: Attr.fromJson(attribute),
            active: active,
            controller: TextEditingController(), variants: options,
          ));
        } else {
          _attributeList!.add(
              AttributeModel(attribute: Attr.fromJson(attribute), active: false,
                controller: TextEditingController(), variants: [],
              ));
        }
      });
    } else {
      ApiChecker.checkApi( response);
    }
   notifyListeners();
  }


  void calculateVariationQuantity(){
    if(_variantTypeList.isNotEmpty) {
      _variationTotalQuantity = 0;
      for(int i=0; i<_variantTypeList.length; i++) {
        _variationTotalQuantity = _variationTotalQuantity + int.parse(_variantTypeList[i].qtyController.text);
      }
    }
    _totalQuantityController.text = _variationTotalQuantity.toString();
    notifyListeners();
  }

  void setAttributeItemList(int index){
    _attributeList![index].active = true;
  }

  void removeImage(int index,bool fromColor){
    if(fromColor){
      if (kDebugMode) {
        print('==$index/${withColor[index].image}/${withColor[index].color}');
      }
      withColor[index].image = null;
    }else{
      withoutColor.removeAt(index);
    }
    notifyListeners();
  }


  void setAttribute(){
    _attributeList![0].active = true;
  }
  String discountType= 'flat';

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(_discountTypeIndex == 0){
      discountType = 'percent';
    }else{
      discountType = 'flat';
    }
    if(notify) {
      notifyListeners();
    }
  }
  
  void setTaxTypeIndex(int index, bool notify) {
    _taxTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setImagePreviewType(String type, bool notify) {
    _imagePreviewSelectedType = type;
    if(notify) {
      notifyListeners();
    }
  }

  void toggleAttribute(BuildContext context,int index, Product? product) {
    _attributeList![index].active = !_attributeList![index].active;
    generateVariantTypes(context,product);
    notifyListeners();
  }

  void toggleMultiply(BuildContext context) {
    _isMultiply = !_isMultiply;
    notifyListeners();
  }

  void addVariant(BuildContext context, int index, String? variant, Product? product, bool notify) {
    _attributeList![index].variants.add(variant);
    generateVariantTypes(context,product);
    if(notify) {
      notifyListeners();
    }
  }
  void addColorCode(String? colorCode, {int? index}){
    if(index == 0){
      _colorCodeList = [];
      withColor = [];
    }
    _colorCodeList.add(colorCode);
    withColor.add(ImageModel(color: colorCode));
    notifyListeners();

  }
  void removeColorCode(int index){
    _colorCodeList.removeAt(index);
    withColor.removeAt(index);
    notifyListeners();
  }
  
  void removeVariant(BuildContext context,int mainIndex, int index, Product? product) {
    _attributeList![mainIndex].variants.removeAt(index);
    generateVariantTypes(context, product);
    notifyListeners();
  }
  
  ///Move to Add Product Directory
  Future<void> getBrandList(BuildContext context, String language) async {
    ApiResponse response = await shopServiceInterface.getBrandList(language);
    if (response.response!.statusCode == 200) {
      _brandList = [];
      response.response!.data.forEach((brand) => _brandList!.add(BrandModel.fromJson(brand)));
    } else {
      ApiChecker.checkApi(response);
    }

    notifyListeners();

  }

  ///Move to pos Directory
  void setSelectedCategoryForFilter(int index, bool? selected){
    _selectedCategory[index] = selected;
    notifyListeners();
  }

  ///Move to Product List
  Future<void> getCategoryList(BuildContext context, Product? product, String language) async {
    log("====category call==> ");
    _categoryIds =[];
    _subCategoryIds =[];
    _subSubCategoryIds =[];
    _categoryIds.add(0);
    _subCategoryIds.add(0);
    _subSubCategoryIds.add(0);
    _categoryIndex = 0;
    _colorCodeList =[];
    _selectedCategory = [];
    ApiResponse response = await shopServiceInterface.getCategoryList(language);
    if (response.response != null && response.response!.statusCode == 200) {
      _categoryList = [];
      response.response!.data.forEach((category) => _categoryList!.add(CategoryModel.fromJson(category)));
      _categoryIndex = 0;

      for(int index = 0; index < _categoryList!.length; index++) {
        _categoryIds.add(_categoryList![index].id);
        _selectedCategory.add(false);
      }

      if(product != null && product.categoryIds != null &&product.categoryIds!.isNotEmpty){
        setCategoryIndex(_categoryIds.indexOf(int.parse(product.categoryIds![0].id!)), false);
        getSubCategoryList(Get.context!,_categoryIds.indexOf(int.parse(product.categoryIds![0].id!)), false, product);
        if (_subCategoryList != null && _subCategoryList!.isNotEmpty) {
          for (int index = 0; index < _subCategoryList!.length; index++) {
            _subCategoryIds.add(_subCategoryList![index].id);
          }

          if(product.categoryIds!.length>1){
            setSubCategoryIndex(_subCategoryIds.indexOf(int.parse(product.categoryIds![1].id!)), false);
            getSubSubCategoryList(_subCategoryIds.indexOf(int.parse(product.categoryIds![1].id!)), false);
          }
        }

        if (_subSubCategoryList != null) {
          for (int index = 0; index < _subSubCategoryList!.length; index++) {
            _subSubCategoryIds.add(_subSubCategoryList![index].id);
          }
          if(product.categoryIds!.length>2){
            setSubSubCategoryIndex(_subSubCategoryIds.indexOf(int.parse(product.categoryIds![2].id!)), false);
            setSubSubCategoryIndex(_subSubCategoryIds.indexOf(int.parse(product.categoryIds![2].id!)), false);
          }
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }



  Future<void> getSubCategoryList(BuildContext context, int? selectedIndex, bool notify, Product? product) async {
    _subCategoryIndex = 0;
    if(categoryIndex != 0) {
      _subCategoryList = [];
      _subCategoryList!.addAll(_categoryList![categoryIndex!-1].subCategories!);
    }
    if(notify){
      _subCategoryIds = [];
      _subCategoryIds.add(0);
      _subCategoryIndex = 0;
      _subSubCategoryIds = [];
      _subSubCategoryIds.add(0);
      _subSubCategoryIndex = 0;
      for (var element in _subCategoryList!) {
        _subCategoryIds.add(element.id);
      }
      notifyListeners();
    }
  }

  ///Move to Add Product Directory
  Future<void> getEditProduct(BuildContext context,int? id) async {
    _editProduct = null;
    ApiResponse response = await shopServiceInterface.getEditProduct(id);
    if (response.response != null && response.response!.statusCode == 200) {
      _editProduct = EditProductModel.fromJson(response.response!.data);
      if(_editProduct?.seoInfo != null) {
        convertSeoInfoToMetaSeoInfo(_editProduct!.seoInfo!);
      }
      getTitleAndDescriptionList(Provider.of<SplashController>(Get.context!,listen: false).configModel!.languageList!, _editProduct);
      initDigitalProductVariation(_editProduct!);
    } else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  void convertSeoInfoToMetaSeoInfo(SeoInfo seoInfo) {
    _metaSeoInfo = MetaSeoInfo(
      metaIndex: seoInfo.index,
      metaNoFollow: seoInfo.noFollow,
      metaNoImageIndex: seoInfo.noImageIndex,
      metaNoArchive: seoInfo.noArchive,
      metaNoSnippet: seoInfo.noSnippet,
      metaMaxSnippet: seoInfo.maxSnippet,
      metaMaxSnippetValue: seoInfo.maxSnippetValue,
      metaMaxVideoPreview: seoInfo.maxVideoPreview,
      metaMaxVideoPreviewValue: seoInfo.maxVideoPreviewValue,
      metaMaxImagePreview: seoInfo.maxImagePreview,
      metaMaxImagePreviewValue: seoInfo.maxImagePreviewValue,
    );
  }

  void initDigitalProductVariation(EditProductModel editProduct) {
    _selectedDigitalVariation = [];
    _digitalVariationExtension = [];
    extentionControllerList = [];
    editVariantKeys = [];
    _variationFileList = [];
    _isDigitalVariationLoading = [];



    if(editProduct.digitalProductFileTypes != null) {
      for(int i=0; i< editProduct.digitalProductFileTypes!.length; i++) {
        _digitalVariationExtension.add([]);
        extentionControllerList.add(TextEditingController());
        editVariantKeys.add([]);
        _variationFileList.add([]);
        _isDigitalVariationLoading.add([]);
        _selectedDigitalVariation.add(capitalizeFirstLetter(editProduct.digitalProductFileTypes![i]));
      }
    }

    if(editProduct.digitalProductExtensions != null){
      editProduct.digitalProductExtensions!.forEach((key, value) {
        for(int i=0; i<_selectedDigitalVariation.length; i++){
          if(key.toLowerCase() == _selectedDigitalVariation[i].toLowerCase()){
            _digitalVariationExtension[i].addAll(value);
          }
        }
      });
    }


    for (int i=0; i<_selectedDigitalVariation.length; i++) {
      for(int index = 0; index < _digitalVariationExtension[i].length; index++) {
        String ext = removeSpacesAndLowercase(_digitalVariationExtension[i][index]);
        editVariantKeys[i].add('${_selectedDigitalVariation[i].toLowerCase()}-$ext');
      }
    }

    for (int i=0; i<_selectedDigitalVariation.length; i++) {
      for(int index = 0; index < editVariantKeys[i].length; index++) {
        for(int j=0; j < editProduct.digitalVariation!.length;  j++) {
          if(editVariantKeys[i][index] == editProduct.digitalVariation![j].variantKey){
            _variationFileList[i].add(
              FileUploadModel(
                priceController: TextEditingController(text: editProduct.digitalVariation![j].price.toString()),
                skuController: TextEditingController(text: editProduct.digitalVariation![j].sku.toString()),
                file: null,
                fileName: editProduct.digitalVariation![j].file?.toString(),
              ),
            );
            _isDigitalVariationLoading[i].add(false);
          }
        }
      }
    }
  }




  DigitalVariationModel  getDigitalVariationModel() {
    DigitalVariationModel  digitalvariationModel = DigitalVariationModel();
    digitalvariationModel.variationType = [];
    digitalvariationModel.digitalVariantKey = [];
    digitalvariationModel.digitalVariantFiles = {};
    digitalvariationModel.digitalVariantSku = {};
    digitalvariationModel.digitalVariantPrice = {};
    digitalvariationModel.digitalVariantKeyMap = {};
    digitalvariationModel.variationKeys = [];

    digitalvariationModel.variationType = processList(_selectedDigitalVariation);

    digitalvariationModel.variationKeys?.addAll(_digitalVariationExtension);

    for (int i=0; i<digitalvariationModel.variationType!.length; i++) {
      for(int index = 0; index < _digitalVariationExtension[i].length; index++) {
        String ext = removeSpacesAndLowercase(_digitalVariationExtension[i][index]);
        digitalvariationModel.digitalVariantKey?.add('${digitalvariationModel.variationType![i]}_$ext');
      }
    }


    int count = -1;
    for (int i=0; i<digitalvariationModel.variationType!.length; i++) {
      for(int index = 0; index < _variationFileList[i].length; index++) {
        count++;
        String key = digitalvariationModel.digitalVariantKey![count];
        digitalvariationModel.digitalVariantFiles?.addAll(
            <String,dynamic>{
              key : _variationFileList[i][index].file
            }
        );
        if(i==1 && index ==0){
          print("=======>>${digitalvariationModel.digitalVariantFiles}");
        }

        digitalvariationModel.digitalVariantSku?.addAll(
            <String,dynamic>{
              key : _variationFileList[i][index].skuController!.text
            }
        );

        digitalvariationModel.digitalVariantPrice?.addAll(
            <String,dynamic>{
              key : _variationFileList[i][index].priceController!.text
            }
        );

        digitalvariationModel.digitalVariantKeyMap?.addAll(
            <String,dynamic>{
              key : replaceUnderscoreWithHyphen(key),
            }
        );
      }
    }

    return digitalvariationModel;
  }





  Future<void> getSubSubCategoryList(int? selectedIndex, bool notify) async {
    _subSubCategoryIndex = 0;
    if(_subCategoryIndex != 0) {
      _subSubCategoryList = [];
      _subSubCategoryList!.addAll(subCategoryList![_subCategoryIndex!-1].subSubCategories!);
    }
    if(notify){
      _subSubCategoryIds = [];
      _subSubCategoryIds.add(0);
      _subSubCategoryIndex = 0;
      if(_subSubCategoryList!.isNotEmpty){
        for (var element in _subSubCategoryList!) {
          _subSubCategoryIds.add(element.id);
        }
      }
      notifyListeners();
    }
  }

  late ImageModel thumbnail;
  late ImageModel metaImage;
  List<ImageModel> withColor = [];
  List<ImageModel> withoutColor = [];
  List<String> withColorKeys = [];
  List<String> withoutColorKeys = [];
  List<ColorImage> colorImageObject = [];
  int totalPickedImage = 0;


  void pickImage(bool isLogo,bool isMeta, bool isRemove, int? index, {bool update = false, bool isAddProduct = false}) async {
    if(isRemove) {
      totalPickedImage--;
      _pickedLogo = null;
      _pickedCover = null;
      _pickedMeta = null;
      _coveredImage = null;
      _productImage = [];
      withColor =[];
      withoutColor =[];
    }else {
      totalPickedImage ++;
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(_pickedLogo != null){
          thumbnail = ImageModel(type: 'thumbnail', color: '', image: _pickedLogo);
          if(isAddProduct){
            metaImage = ImageModel(type: 'meta', color: '', image: _pickedLogo);
            _pickedMeta = pickedLogo;
          }
        }

      } else if(isMeta){
        _pickedMeta = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(_pickedMeta != null){
          metaImage = ImageModel(type: 'meta', color: '', image: _pickedMeta);
        }

      }else {
        _coveredImage = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (_coveredImage != null && index != null) {
          if(update){totalPickedImage --;}
          withColor[index].image =  _coveredImage;
          withColor[index].type =  'product';
        }else if(_coveredImage != null) {
          withoutColor.add(ImageModel(image: _coveredImage, type: 'product',color: ''));
        }
      }
    }

    notifyListeners();

  }

  void setSelectedColorIndex(int index, bool notify) {
    if(!_selectedColor.contains(index)) {
      _selectedColor.add(index);
      if(notify) {
        notifyListeners();
      }
    }notifyListeners();
  }


  void setBrandIndex(int? index, bool notify) {
    _brandIndex = index;
    if(notify) {
      notifyListeners();
    }
  }
  void setUnitIndex(int index, bool notify) {
    _unitIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setCategoryIndex(int? index, bool notify) {
    _categoryIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setSubCategoryIndex(int? index, bool notify) {
    _subCategoryIndex = index;
    if(notify) {
      notifyListeners();
    }
  }
  void setSubSubCategoryIndex(int? index, bool notify) {
    _subSubCategoryIndex = index;
    if(notify) {
      notifyListeners();
    }
  }


  void setStringImage(int index, String image, String colorCode, {String? path}) {
    withColor[index].imageString = image;
    withColor[index].colorImage = ColorImage(color: colorCode, imageName: ImageFullUrl(key: image, path: path));
  }


  int totalUploaded = 0;
  void initUpload(){
    totalUploaded = 0;
    notifyListeners();
  }

  void initColorCode(){
    _colorCodeList = [];
    withColor = [];
  }

  Future addProductImage(BuildContext context, ImageModel imageForUpload, Function callback, {bool update =false, int? index}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await shopServiceInterface.addImage(context, imageForUpload, attributeList![0].active);
    if(response.response != null && response.response!.statusCode == 200) {
      totalUploaded ++;
      _isLoading = false;
      Map map = jsonDecode(response.response!.data);
      String? name = map["image_name"];
      String? type = map["type"];
      log("=img====>$name==> ${map["image_name"]}");
      if(type == 'product'){
        if(map["image_name"] != null && map["image_name"] != "null"){
          productReturnImage?.add({
            "image_name" : name,
            "storage" : map['storage'] ?? "public",
          });
        }

        if(attributeList![0].active){

          if(update && map["color_image"]['color'] != null && index != null && (index < imagesWithColorForUpdate.length)){
            log("===inside/ $update/${map["color_image"]['color']}/${index +1}/${imagesWithColorForUpdate.length}");
            colorImageObject.removeAt(index);
            colorImageObject.insert(index, ColorImage(color:  map['color_image'] != null ? map['color_image']['color'] : null, imageName: ImageFullUrl(key: name), storage: map['storage']));
          }else{
            log("========not Here========");
            colorImageObject.add(ColorImage(color:  map['color_image'] != null ? map['color_image']['color'] : null, imageName: ImageFullUrl(key: name), storage: map['storage']));
          }
        }
      }
      callback(true, name, type, map['color_image'] != null ? map['color_image']['color'] : null);
      notifyListeners();
    }else {
      _isLoading = false;
      ApiChecker.checkApi( response);
      showCustomSnackBarWidget(getTranslated('image_upload_failed', Get.context!), Get.context!);

    }
    notifyListeners();
  }


  Future<void> addProduct(BuildContext context, Product product, AddProductModel addProduct, String? thumbnail, String? metaImage, bool isAdd, List<String?> tags) async {
    _isLoading = true;
    DigitalVariationModel? digitalVariationModel;
    String? token;
    notifyListeners();
    Map<String, dynamic> fields = {};
    if(_variantTypeList.isNotEmpty) {
      List<int?> idList = [];
      List<String?> nameList = [];
      for (var attributeModel in _attributeList!) {
        if(attributeModel.active) {
          if(attributeModel.attribute.id != 0) {
            idList.add(attributeModel.attribute.id);
            nameList.add(attributeModel.attribute.name);
          }
          List<String?> variantString = [];
          for (var variant in attributeModel.variants) {
            variantString.add(variant);
          }
          fields.addAll(<String, dynamic>{'choice_options_${attributeModel.attribute.id}': variantString});
        }
      }
      fields.addAll(<String, dynamic> {
        'choice_attributes': jsonEncode(idList), 'choice_no': jsonEncode(idList), 'choice': jsonEncode(nameList)
      });

      for(int index=0; index<_variantTypeList.length; index++) {
        fields.addAll(<String, dynamic> {'price_${_variantTypeList[index].variantType}': PriceConverter.systemCurrencyToDefaultCurrency(double.parse(_variantTypeList[index].controller.text), context)});
        fields.addAll(<String, dynamic> {'qty_${_variantTypeList[index].variantType}': int.parse(_variantTypeList[index].qtyController.text)});
        fields.addAll(<String, dynamic> {'sku_${_variantTypeList[index].variantType}': "sku_${_variantTypeList[index].variantType}"});
        _totalQuantity += int.parse(_variantTypeList[index].qtyController.text);
      }
      if (kDebugMode) {
        print('=====Total_Quantity======>$_totalQuantity');
      }
    }

    if(_selectedDigitalVariation.isNotEmpty){
      digitalVariationModel = getDigitalVariationModel();
      token = Provider.of<AuthController>(context,listen: false).getUserToken();
    }

    setMetaSeoData(product);



    ApiResponse response = await shopServiceInterface.addProduct(product, addProduct ,fields, productReturnImage, thumbnail, metaImage, isAdd, attributeList![0].active, colorImageObject, tags, _digitalProductFileName, digitalVariationModel, _selectedDigitalVariation.isNotEmpty, token);
    if(response.response != null && response.response?.statusCode == 200) {
      _productCode.clear();
      Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
      showCustomSnackBarWidget(isAdd ? getTranslated('product_added_successfully', Get.context!): getTranslated('product_updated_successfully', Get.context!),Get.context!, isError: false);
       titleControllerList.clear();
      descriptionControllerList.clear();
      _pickedLogo = null;
      _pickedCover = null;
      _coveredImage =null;
      _productImage = [];
      colorImageObject = [];
      productReturnImage=[];
      withColor = [];
      withoutColor = [];
      emptyDigitalProductData();
      _isLoading = false;
      _selectedFileForImport = null;
      _digitalProductFileName = '';
      _metaSeoInfo = MetaSeoInfo();
     }else {
      //colorWithImage = [];
      productReturnImage =[];
      withColor = [];
      colorImageObject = [];
      withoutColor = [];
      _isLoading = false;
      ApiChecker.checkApi( response);
      showCustomSnackBarWidget(getTranslated('product_add_failed', Get.context!), Get.context!, sanckBarType: SnackBarType.error);
    }
    _isLoading = false;
    notifyListeners();
  }


  void setMetaSeoData(Product product) {
    metaSeoInfo?.metaMaxImagePreviewValue = _imagePreviewSelectedType;
    product.metaSeoInfo = metaSeoInfo;
  }

  void loadingFalse() {
    _isLoading = false;
    notifyListeners();
  }





  void generateVariantTypes(BuildContext context, Product? product) {
    List<List<String?>> mainList = [];
    int length = 1;
    bool hasData = false;
    List<int> indexList = [];
    _variantTypeList = [];
    for (var attribute in _attributeList!) {
      if(attribute.active) {
        hasData = true;
        mainList.add(attribute.variants);
        length = length * attribute.variants.length;
        indexList.add(0);
      }
    }
    if(!hasData) {
      length = 0;
    }
    for(int i=0; i<length; i++) {
      String value = '';
      for(int j=0; j<mainList.length; j++) {
        value = value + (value.isEmpty ? '' : '-') + mainList[j][indexList[j]]!.trim();
      }
      if(product != null) {
        double? price = 0;
        int? quantity = 0;
        for(Variation variation in product.variation!) {
          if(variation.type == value) {
            price = variation.price;
            quantity = variation.qty;
            break;
          }
        }
        _variantTypeList.add(VariantTypeModel(
          variantType: value, controller: TextEditingController(text: price! > 0 ? PriceConverter.convertPriceWithoutSymbol(context,price) : ''), node: FocusNode(),
          qtyController: TextEditingController(text: quantity.toString()), qtyNode: FocusNode(),
        ));
        // _variationTotalQuantity
      }else {
        _variantTypeList.add(VariantTypeModel(variantType: value, controller: TextEditingController(), node: FocusNode(),qtyController: TextEditingController(),qtyNode: FocusNode()));
      }
      
      for(int j=0; j<mainList.length; j++) {
        if(indexList[indexList.length-(1+j)] < mainList[mainList.length-(1+j)].length-1) {
          indexList[indexList.length-(1+j)] = indexList[indexList.length-(1+j)] + 1;
          break;
        }else {
          indexList[indexList.length-(1+j)] = 0;
        }
      }
    }
    // if(_variantTypeList.isNotEmpty){
    //   for(int i=0; i<_variantTypeList.length; i++){
    //     int qty = int.tryParse(_variantTypeList[i].qtyController.text) ?? 0;
    //     _variationTotalQuantity = _variationTotalQuantity + qty;
    //   }
    // }
    // print("====TotalVariationCount=====>${_variationTotalQuantity}");
  }
  
  bool hasAttribute() {
    bool hasData = false;
    for(AttributeModel attribute in _attributeList!) {
      if(attribute.active) {
        hasData = true;
        break;
      }
    }
    return hasData;
  }

  void setValueForUnit (String? setValue){
    if (kDebugMode) {
      print('------$setValue====$_unitValue');
    }
    _unitValue = setValue;
  }

  void setProductTypeIndex(int index, bool notify) {
    _productTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }


  void setDigitalProductTypeIndex(int index, bool notify) {
    _digitalProductTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setSelectedFileName(File? fileName){
    _selectedFileForImport = fileName;
    if (kDebugMode) {
      print('Here is your file ===>$_selectedFileForImport');
    }
    notifyListeners();
  }


  Future<ApiResponse> uploadDigitalProduct(String token) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await shopServiceInterface.uploadDigitalProduct(_selectedFileForImport, token);

    if(response.response!.statusCode == 200) {
      if (kDebugMode) {
        print('digital product uploaded');
      }
      _isLoading = false;
      Map map = jsonDecode(response.response!.data);
      _digitalProductFileName = map["digital_file_ready_name"];
      if (kDebugMode) {
        print('-----digital product uploaded---->$_digitalProductFileName');
      }

    }else {
      _isLoading = false;
    }
    _isLoading = false;
    notifyListeners();
    return response;
  }
  
  
  void setTotalVariantTotalQuantity(int total){
    _totalVariantQuantity = total;
  }

  Future<void> updateProductQuantity(BuildContext context, int? productId, int currentStock, List<Variation> variations) async {
    if(kDebugMode){
      print("variation======>${variations.length}/${variations.toList()}");
    }
    List<Variation> updatedVariations = [];
    for(int i=0; i<variations.length; i++){
      updatedVariations.add(Variation(type: variations[i].type,
          sku: variations[i].sku,
          price: variations[i].price,
          qty: int.parse(_variantTypeList[i].qtyController.text)
      ));
    }
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shopServiceInterface.updateProductQuantity(productId, currentStock, updatedVariations);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Navigator.pop(Get.context!);
      showCustomSnackBarWidget(getTranslated('quantity_updated_successfully', Get.context!), Get.context!, isError: false);
      Provider.of<ProductController>(Get.context!, listen: false).getStockOutProductList(1, 'en');
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> deleteProductImage(String id, String name, String? color) async {
    //_isLoading = true;
    ApiResponse apiResponse = await shopServiceInterface.deleteProductImage(id, name, color);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      //_isLoading = false;
      getProductImage(id);
    } else {
      // _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> deleteDigitalVariationFile(int productId, int index, int subIndex) async {
    _isDigitalVariationLoading[index][subIndex] = true;
    notifyListeners();

    String vKey = editVariantKeys[index][subIndex];

    ApiResponse apiResponse = await shopServiceInterface.deleteDigitalVariationFile(productId, vKey);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _variationFileList[index][subIndex].fileName = null;
      _isLoading = false;
      showCustomSnackBarWidget(getTranslated('digital_product_deleted_successfully', Get.context!), Get.context!, sanckBarType: SnackBarType.success);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }

    _isDigitalVariationLoading[index][subIndex] = false;
    notifyListeners();
  }



  List<String> imagesWithoutColor = [];
  List<String> imagesWithColorForUpdate = [];
  ProductImagesModel? productImagesModel;
  Future<void> getProductImage(String id) async {
    imagesWithoutColor = [];
    productReturnImage = [];
    colorImageObject = [];
    imagesWithColorForUpdate =[];
    withColorKeys = [];
    withoutColorKeys = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shopServiceInterface.getProductImage(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      imagesWithoutColor = [];
      productReturnImage = [];
      imagesWithColorForUpdate =[];
      colorImageObject.clear();
      _isLoading = false;
      productImagesModel = ProductImagesModel.fromJson(apiResponse.response?.data);

      if(productImagesModel!.colorImage!.isNotEmpty) {
        colorImageObject = productImagesModel!.colorImage!;
        log("withcolor==>out ${withColor.length}----> ");
        for(int i = 0; i<productImagesModel!.colorImage!.length; i++) {
          ColorImage img = productImagesModel!.colorImage![i];
          if(img.imageName != null && img.imageName?.status == 200) {
            productReturnImage?.add({
              "image_name" : img.imageName?.key,
              "storage" : productImagesModel?.colorImagesStorage![i].storage ?? 'public',
            });
          }
          if(img.color != null){
            imagesWithColorForUpdate.add(img.imageName?.key ??'');
            log("===>vai response ==> ${img.color}");
          }


          if(withColor.isNotEmpty) {
            for(int index=0; index<withColor.length; index++) {
              log("withcolor==> ${withColor[index].color}----> ${img.color}");
              String retColor = withColor[index].color!;
              String? bb;
              if(retColor.contains('#')){
                bb = retColor.replaceAll('#', '');
              }
              log("withcolor==>chk $bb----> ${img.color}");
              if(bb == img.color) {
                setStringImage(index, img.imageName?.key  ?? '', img.color ?? '', path: img.imageName?.path);
                withColorKeys.add(img.imageName?.key ?? '');
              }
            }
          }
          if(img.color == null){
            imagesWithoutColor.add(img.imageName?.path ?? '');
            withoutColorKeys.add(img.imageName?.key ?? '');
          }
        }
      }else{
        List<String> pathList = [];
        List<Map<String, dynamic>> keyList = [];
        for(int i = 0; i < (productImagesModel?.images?.length ?? 0); i++) {
          if(productImagesModel?.images?[i].path != '') {
            pathList.add(productImagesModel?.images![i].path ?? '');
            keyList.add({
              "image_name" : productImagesModel?.images![i].key ?? '',
              "storage" : productImagesModel?.imagesStorage![i].storage ?? 'public',
            });
            withoutColorKeys.add(productImagesModel?.images![i].key ?? '');
          }
        }
        imagesWithoutColor.addAll(pathList);
        productReturnImage?.addAll(keyList);
      }

    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  void resetCategory () {
    _categoryIndex = 0;
    _subCategoryIndex = 0;
    _subSubCategoryIndex = 0;
  }

  void setCurrentStock(String stock){
    _totalQuantityController.text = stock;
  }


  void removeCategory(){
    _categoryList = null;
  }

  void addDigitalProductVariation(String value) {
    _selectedDigitalVariation.add(value);
    _digitalVariationExtension.add([]);
    _variationFileList.add([]);
    extentionControllerList.add(TextEditingController());
    _isDigitalVariationLoading.add([]);
    notifyListeners();
  }

  void removeDigitalVariant(BuildContext context, int index) {
    _selectedDigitalVariation.removeAt(index);
    _digitalVariationExtension.removeAt(index);
    _variationFileList.removeAt(index);
    extentionControllerList.removeAt(index);
    _isDigitalVariationLoading.removeAt(index);
    notifyListeners();
  }

  void addExtension(int index, String text){
    _digitalVariationExtension[index].add(text);
    extentionControllerList[index].text = '';
    _variationFileList[index].add(
       FileUploadModel(
         priceController: TextEditingController(),
         skuController: TextEditingController(text: generateSKU()),
         file: null,
       )
    );
    _isDigitalVariationLoading[index].add(false);
    notifyListeners();
  }

  void removeExtension(int index, int subIndex){
    _digitalVariationExtension[index].removeAt(subIndex);
    _variationFileList[index].removeAt(subIndex);
    _isDigitalVariationLoading[index].removeAt(subIndex);
    notifyListeners();
  }


  void pickFileForDigitalProduct (int index, int subIndex) async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withReadStream: true,
      withData: true,
      allowedExtensions: ['pdf', 'zip', 'jpg', 'png', "jpeg", "gif",  "mp4", "avi", "mov", "mkv", "webm", "mpeg", "mpg", "3gp", "m4v", "mp3", "wav", "aac", "wma", "amr"],
    );

    if(result != null){
      Uint8List? imageBytes = result.files.first.bytes;
      File? _file = await File(result.files.first.path!).writeAsBytes(imageBytes!);

      XFile xFile =  XFile(_file.path);

      _variationFileList[index][subIndex].file = xFile;
      PlatformFile? fileNamed = result.files.first;
      _variationFileList[index][subIndex].fileName = fileNamed.name;
    }

    notifyListeners();
  }


  void removeFileForDigitalProduct (int index, int subIndex) async{
      _variationFileList[index][subIndex].file = null;
      _variationFileList[index][subIndex].fileName = null;
    notifyListeners();
  }

  void  setSelectedPageIndex (int index, {bool isUpdate = true}){
    _selectedPageIndex = index;
    if(isUpdate) {
      notifyListeners();
    }
  }


  List<String> processList(List<String> inputList) {
    return inputList.map((str) => str.toLowerCase().trim()).toList();
  }

  String removeSpacesAndLowercase(String input) {
    return input.replaceAll(' ', '').toLowerCase();
  }
  String replaceUnderscoreWithHyphen(String input) {
    return input.replaceAll('_', '-');
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }


  void updateState(){
    notifyListeners();
  }


  String generateSKU() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
    String sku = '';

    for (int i = 0; i < 6; i++) {
      sku += chars[random.nextInt(chars.length)];
    }
    return sku;
  }

  void emptyDigitalProductData() {
    _selectedDigitalVariation = [];
    _digitalVariationExtension = [];
    _variationFileList = [];
    extentionControllerList = [];
    editVariantKeys = [];
    _isDigitalVariationLoading = [];
  }


}
