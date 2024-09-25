import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/product_details/domain/services/product_details_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class ProductDetailsController extends ChangeNotifier{

  final ProductDetailsServiceInterface productDetailsServiceInterface;
  ProductDetailsController({required this.productDetailsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Product? _productDetails;
  Product? get productDetails => _productDetails;



  Future<void> getProductDetails(int? productId) async {
    _isLoading = true;
    ApiResponse apiResponse = await productDetailsServiceInterface.getProductDetails(productId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _productDetails = Product.fromJson(apiResponse.response!.data);
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> productStatusOnOff( BuildContext context, int? productId, int status) async {
    ApiResponse apiResponse = await productDetailsServiceInterface.productStatusOnOff(productId, status);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _productDetails!.status = status;
      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isError: false);
      getProductDetails(productId);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


}