import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/barcode/domain/services/barcode_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class BarcodeController extends ChangeNotifier{

  final BarcodeServiceInterface barcodeServiceInterface;
  BarcodeController({required this.barcodeServiceInterface});


  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;
  bool _isGetting = false;
  bool get isGetting => _isGetting;
  String? _printBarCode = '';
  String? get printBarCode =>_printBarCode;


  void setBarCodeQuantity(int quantity){
    _barCodeQuantity = quantity;
    if (kDebugMode) {
      print('Quantity is ==>$_barCodeQuantity');
    }
    notifyListeners();
  }

  Future<void> barCodeDownload(BuildContext context,int? id, int quantity) async {
    _isGetting = true;
    ApiResponse apiResponse = await barcodeServiceInterface.barCodeDownLoad(id, quantity);
    if(apiResponse.response!.statusCode == 200) {
      _printBarCode = apiResponse.response!.data;
      showCustomSnackBarWidget(getTranslated('barcode_downloaded_successfully', Get.context!),Get.context!,isError: false);

      _isGetting = false;
    }else {
      ApiChecker.checkApi(apiResponse);
    }
    _isGetting = false;
    notifyListeners();
  }
  
}