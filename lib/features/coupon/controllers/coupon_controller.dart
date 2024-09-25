import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/customer_model.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class CouponController with ChangeNotifier {
  final CouponServiceInterface couponServiceInterface;

  CouponController({required this.couponServiceInterface});

  CouponModel? _couponModel;
  CouponModel? get couponModel => _couponModel;
  List<Customers>? _couponCustomerList;
  List<Customers>? get couponCustomerList =>_couponCustomerList;
  final List<int?> _couponCustomerIds = [];
  List<int?> get couponCustomerIds => _couponCustomerIds;
  int? _couponCustomerIndex = 0;
  int? get couponCustomerIndex => _couponCustomerIndex;
  int? _selectedCustomerIdForCoupon = 0;
  int? get selectedCustomerIdForCoupon => _selectedCustomerIdForCoupon;
  final TextEditingController _searchCustomerController = TextEditingController();
  TextEditingController get searchCustomerController => _searchCustomerController;
  String _customerSelectedName = '';
  String get customerSelectedName => _customerSelectedName;
  final String _customerSelectedMobile = '';
  String get customerSelectedMobile => _customerSelectedMobile;
  int? _customerId = 0;
  int? get customerId => _customerId;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isAdd = false;
  bool get isAdd => _isAdd;
  String? _selectedCouponType = 'discount_on_purchase';
  String? get selectedCouponType => _selectedCouponType ;
  final List<String> _couponTypeList = ['discount_on_purchase', 'free_delivery'];
  List<String>  get couponTypeList => _couponTypeList;
  String? _discountTypeName = 'amount';
  String? get discountTypeName => _discountTypeName;
  List<String> discountTypeList = ['amount','percentage'];
  DateTime? startDate;
  DateTime? endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateFormat get dateFormat => _dateFormat;

  void setSelectedCouponType(String? type){
    _selectedCouponType = type;
    notifyListeners();
  }


  void setSelectedDiscountNameType(String? type){
    _discountTypeName = type;
    notifyListeners();
  }

  Future<void> getCouponList(BuildContext context, int offset,{bool reload = true}) async {
    ApiResponse apiResponse = await couponServiceInterface.getCouponList(offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1) {
        _couponModel = null;
        _couponModel = CouponModel.fromJson(apiResponse.response!.data);
      }else {
        _couponModel!.totalSize = CouponModel.fromJson(apiResponse.response!.data).totalSize;
        _couponModel!.offset = CouponModel.fromJson(apiResponse.response!.data).offset;
        _couponModel!.coupons!.addAll(CouponModel.fromJson(apiResponse.response!.data).coupons!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNewCoupon(BuildContext context, Coupons coupons, bool update) async {
    _isAdd = true;
    ApiResponse apiResponse = await couponServiceInterface.addNewCoupon(coupons, update: update);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getCouponList(Get.context!, 1);
      _isAdd = false;
      startDate = null;
      endDate = null;
      Navigator.pop(Get.context!);
      update?
      showCustomSnackBarWidget(getTranslated('coupon_updated_successfully', Get.context!), Get.context!, isError: false):
      showCustomSnackBarWidget(getTranslated('coupon_added_successfully', Get.context!), Get.context!, isError: false);
    } else {
      _isAdd = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  Future<void> updateCouponStatus(BuildContext context, int? id, int status, index) async {
    ApiResponse response = await couponServiceInterface.updateCouponStatus(id, status);
    if (response.response!.statusCode == 200) {
      _couponModel!.coupons![index].status = status;
      showCustomSnackBarWidget(getTranslated('coupon_status_update_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi( response);
    }
    notifyListeners();
  }


  Future<void> deleteCoupon(BuildContext context, int? id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await couponServiceInterface.deleteCoupon(id);
    if (apiResponse.response!.statusCode == 200) {
      await getCouponList(context, 1, reload: true);
      showCustomSnackBarWidget(getTranslated('coupon_deleted_successfully', Get.context!), Get.context!, isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }


  void selectDate(String type, BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start'){
        startDate = date;
      }else{
        endDate = date;
      }
      if(date == null){
      }
      notifyListeners();
    });
  }

  void setCouponCustomerIndex(int index,int customerId, bool notify) {
    _couponCustomerIndex = index;
    _selectedCustomerIdForCoupon = customerId;
    if(notify) {
      notifyListeners();
    }
  }

  void setCustomerInfo(int? id, String name, bool notify) {
    _customerId = id;
    _customerSelectedName = name;
    if(notify) {
      notifyListeners();
    }
  }

  Future<void> getCouponCustomerList(BuildContext context,String search ) async {
    _isLoading = true;
    ApiResponse response = await couponServiceInterface.getCouponCustomerList(search);
    if(response.response!.statusCode == 200) {
      _isLoading = false;
      _couponCustomerList = [];
      _couponCustomerList!.addAll(CustomerModel.fromJson(response.response!.data).customers!);
      if(_couponCustomerList!.isNotEmpty){
        for(int index = 0; index < _couponCustomerList!.length; index++) {
          _couponCustomerIds.add(_couponCustomerList![index].id);
        }
        _couponCustomerIndex = _couponCustomerIds[0];
        _selectedCustomerIdForCoupon = _couponCustomerIds[0];
      }
    }else {
      ApiChecker.checkApi( response);
    }
    _isLoading = false;
    notifyListeners();
  }


  void clearCouponData() {
    startDate = null;
    endDate = null;
    _couponCustomerIndex = 0;
  }


}
