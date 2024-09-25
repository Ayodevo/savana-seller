import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/srock_limit_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/services/product_service_interface.dart';
import 'package:sixvalley_vendor_app/features/review/controllers/product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/top_selling_product_model.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class ProductController extends ChangeNotifier {
  final ProductServiceInterface productServiceInterface;
  ProductController({required this.productServiceInterface});

  bool _isLoading = false;
  List<int> _offsetList = [];
  int _offset = 1;
  bool _isPaginationLoading = false;
  bool get isLoading => _isLoading;
  int get offset => _offset;
  final List<bool> _isOn = [];
  List<bool> get isOn=>_isOn;
  bool get isPaginationLoading => _isPaginationLoading;

  List<Product> _stockOutProductList = [];
  List<Product> _mostPopularProductList = [];
  final List<Products> _topSellingProductList = [];
  List<Product> _posProductList = [];
  TopSellingProductModel? _topSellingProductModel;
  TopSellingProductModel? get topSellingProductModel => _topSellingProductModel;
  List<Product> get mostPopularProductList => _mostPopularProductList;
  List<Products> get topSellingProductList => _topSellingProductList;
  List<Product> get stockOutProductList => _stockOutProductList;
  List<Product> get posProductList => _posProductList;
  ProductModel? _posProductModel;
  ProductModel? get posProductModel => _posProductModel;
  int? _sellerPageSize;
  int? _stockOutProductPageSize;
  int? get sellerPageSize => _sellerPageSize;
  int? get stockOutProductPageSize => _stockOutProductPageSize;
  int? _variantIndex;
  List<int>? _variationIndex;
  int? get variantIndex => _variantIndex;
  List<int>? get variationIndex => _variationIndex;
  int? _quantity = 0;
  int? get quantity => _quantity;

  int? _digitalVariationIndex = 0;
  int? get digitalVariationIndex => _digitalVariationIndex;

  int? _digitalVariationSubindex = 0;
  int? get digitalVariationSubindex => _digitalVariationSubindex;

  ProductModel? _sellerProductModel;
  ProductModel? get sellerProductModel => _sellerProductModel;

  StockLimitStatus? _stockLimitStatus;
  StockLimitStatus? get stockLimitStatus => _stockLimitStatus;

  bool _showCookies = true;
  bool get showCookies => _showCookies;


  void initData(Product product, int? minimumOrderQuantity, BuildContext context) {
    _variantIndex = 0;
    _quantity = minimumOrderQuantity;
    _variationIndex = [];
    for (int i= 0; i<= product.choiceOptions!.length; i++) {
      _variationIndex!.add(0);
    }
  }

  void setQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }

  void setCartVariantIndex(int? minimumOrderQuantity,int index, BuildContext context) {
    _variantIndex = index;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }

  void setCartVariationIndex(int? minimumOrderQuantity, int index, int i, BuildContext context) {
    _variationIndex![index] = i;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }

   List<int?> _reviewProductIds = [];
   List<int?> get reviewProductIds => _reviewProductIds;


  Future <void> initSellerProductList(String sellerId, int offset, BuildContext context, String languageCode,String search, {bool reload = true}) async {
    _reviewProductIds = [];
    _reviewProductIds.add(0);
    if(reload) {
      _isLoading = true;
    }
      ApiResponse apiResponse = await productServiceInterface.getSellerProductList(sellerId, offset,languageCode, search);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(offset == 1){
          _sellerProductModel = null;
          _sellerProductModel = ProductModel.fromJson(apiResponse.response!.data, fromGetProducts: true);
        }else{
          _sellerProductModel!.products!.addAll(ProductModel.fromJson(apiResponse.response!.data, fromGetProducts: true).products??[],);
          _sellerPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
          _sellerProductModel!.offset = ProductModel.fromJson(apiResponse.response!.data).offset;
          _sellerProductModel!.totalSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        }
        if(_sellerProductModel!.products != null){
          Provider.of<ProductReviewController>(Get.context!,listen: false).setProductIndex();
          for(int i= 0; i<_sellerProductModel!.products!.length; i++){
            _reviewProductIds.add(_sellerProductModel!.products![i].id);
          }
        }
        _isLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
  }

  List<int?> _cartQuantity = [];
  List<int?> get cartQuantity => _cartQuantity;

  Future <void> getPosProductList(int offset, BuildContext context,List <String> id, {bool reload = true}) async {
    _isLoading = true;
      ApiResponse apiResponse = await productServiceInterface.getPosProductList(offset, id);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(offset == 1 ){
          _cartQuantity = [];
          _posProductModel = ProductModel.fromJson(apiResponse.response!.data);
        }else{
          _posProductModel!.totalSize =  ProductModel.fromJson(apiResponse.response!.data).totalSize;
          _posProductModel!.offset =  ProductModel.fromJson(apiResponse.response!.data).offset;
          _posProductModel!.products!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!)  ;
        }
        for(int i = 0; i< _posProductModel!.products!.length; i++){
          _cartQuantity.add(0);
        }
        _isLoading = false;
      } else {
        _isLoading = false;
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();

  }

  void setCartQuantity(int? quantity, int index){
    _cartQuantity[index] = quantity;

  }

  bool _showDialog = false;
  bool get showDialog=> _showDialog;

  void shoHideDialog(bool showDialog, {bool notify = true}){
    _showDialog = showDialog;
    if(notify){
      notifyListeners();
    }
  }

  Future <void> getSearchedPosProductList(BuildContext context, String search, List<String> ids, {bool filter = false}) async {
    if(!filter){
      shoHideDialog(true);
    }

      ApiResponse apiResponse = await productServiceInterface.getSearchedPosProductList(search, ids);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _posProductList = [];
        _posProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _sellerPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
  }

  Future<void> getStockOutProductList(int offset, String languageCode, {bool reload = false}) async {
    if(reload || offset == 1) {
      _offset = 1;
      _offsetList = [];
      _stockOutProductList = [];
      _isLoading = true;
    }
    if(!_offsetList.contains(offset)){
      _offsetList.add(offset);
      ApiResponse apiResponse = await productServiceInterface.getStockLimitedProductList(offset,languageCode);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _stockOutProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _stockOutProductPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        _isPaginationLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();

    }else{
      if(_isLoading || _isPaginationLoading) {
        _isPaginationLoading = false;
        _isLoading = false;
      }
    }
  }

  Future<void> getMostPopularProductList(int offset, BuildContext context, String languageCode, {bool reload = false}) async {
    if(reload || offset == 1) {
      _offset = 1;
      _offsetList = [];
      _mostPopularProductList = [];
    }
    if(!_offsetList.contains(offset)){
      _offsetList.add(offset);
      ApiResponse apiResponse = await productServiceInterface.getMostPopularProductList(offset,languageCode);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _mostPopularProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        // _stockOutProductPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();

    }else{
      if(_isLoading) {
        _isLoading = false;
      }
    }

  }

  Future<void> getTopSellingProductList(int offset, BuildContext context, String languageCode, {bool reload = true}) async {
      ApiResponse apiResponse = await productServiceInterface.getTopSellingProductList(offset,languageCode);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(offset == 1 ){
          _topSellingProductModel = TopSellingProductModel.fromJson(apiResponse.response!.data);
        }else{
          _topSellingProductModel!.totalSize =  TopSellingProductModel.fromJson(apiResponse.response!.data).totalSize;
          _topSellingProductModel!.offset =  TopSellingProductModel.fromJson(apiResponse.response!.data).offset;
          _topSellingProductModel!.products!.addAll(TopSellingProductModel.fromJson(apiResponse.response!.data).products!)  ;
        }
        _isLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
  }

  Future<void> deleteProduct(BuildContext context, int? productID) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await productServiceInterface.deleteProduct(productID);
    if(response.response!.statusCode == 200) {
      Navigator.pop(Get.context!);
      showCustomSnackBarWidget(getTranslated('product_deleted_successfully', Get.context!),Get.context!, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }


  void setOffset(int offset) {
    _offset = offset;
  }


  void showBottomLoader() {
    _isPaginationLoading = true;
    notifyListeners();
  }


  Future<void> getStockLimitStatus(BuildContext context) async {
    ApiResponse response = await productServiceInterface.getStockLimitStatus();
    if(response.response!.statusCode == 200) {
      _stockLimitStatus = StockLimitStatus.fromJson(response.response!.data);
    }else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  bool isShowCookies() {
    return productServiceInterface.isShowCookies();
  }


  Future<void> setShowCookies() {
    _showCookies = false;
    notifyListeners();
    return productServiceInterface.setIsShowCookies();
  }


  void setShowCookie(bool isShow,{bool notify = false}) {
    _showCookies = isShow;
    if(notify){
      notifyListeners();
    }
  }

  Future<void> removeCookies() {
    return productServiceInterface.removeShowCookies();
  }

  void setDigitalVariationIndex(int? minimumOrderQuantity, int index, int subIndex, BuildContext context) {
    _quantity = minimumOrderQuantity;
    _digitalVariationIndex = index;
    _digitalVariationSubindex = subIndex;
    notifyListeners();
  }

  void initDigitalVariationIndex() {
    _digitalVariationIndex = 0;
    _digitalVariationSubindex = 0;
  }

}
