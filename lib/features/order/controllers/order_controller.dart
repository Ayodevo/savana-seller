import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order/domain/services/order_service_interface.dart';
import 'package:sixvalley_vendor_app/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class OrderController extends ChangeNotifier {
  final OrderServiceInterface orderServiceInterface;
  OrderController({required this.orderServiceInterface});

  String? _paymentStatus;
  String? get paymentStatus =>_paymentStatus;
  String? _orderStatus;
  String? get orderStatus =>_orderStatus;
  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;

  final bool _selfDelivery = false;
  final bool _thirdPartyDelivery = false;
  bool get selfDelivery => _selfDelivery;
  bool get thirdPartyDelivery => _thirdPartyDelivery;

  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;

  PlatformFile? fileNamed;
  File? file;
  int?  fileSize;
  bool assigning = false;
  final int _offset = 1;
  int get offset => _offset;
  DateTime? _startDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateFormat get dateFormat => _dateFormat;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;


  String _orderType = 'all';
  String get orderType => _orderType;

  String? _addOrderStatusErrorText;
  String? get addOrderStatusErrorText => _addOrderStatusErrorText;

  List<String>? _paymentImageList;
  List<String>? get paymentImageList => _paymentImageList;


  bool _isAddressLoading = false;
  bool get isAddressLoading => _isAddressLoading;



  Future<void> getOrderList(BuildContext? context, int offset, String status, {bool reload = true}) async {
    if(reload){
      _orderModel = null;
    }
    _isLoading = true;
    ApiResponse apiResponse = await orderServiceInterface.getOrderList(offset, status);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1 ){
        _orderModel = OrderModel.fromJson(apiResponse.response!.data);
      }else{
        _orderModel!.totalSize =  OrderModel.fromJson(apiResponse.response!.data).totalSize;
        _orderModel!.offset =  OrderModel.fromJson(apiResponse.response!.data).offset;
        _orderModel!.orders!.addAll(OrderModel.fromJson(apiResponse.response!.data).orders!)  ;
      }

      for(Order order in _orderModel!.orders!){
        _paymentStatus = order.paymentStatus;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }



  void setIndex(BuildContext context, int index, {bool notify = true}) {
    _orderTypeIndex = index;
    if(_orderTypeIndex == 0){
      _orderType = 'all';
      getOrderList(context, 1, 'all');
    }else if(_orderTypeIndex == 1){
      _orderType = 'pending';
      getOrderList(context, 1, 'pending');
    }else if(_orderTypeIndex == 2){
      _orderType = 'processing';
      getOrderList(context, 1, 'processing');
    }else if(_orderTypeIndex == 3){
      _orderType = 'delivered';
      getOrderList(context, 1, 'delivered');
    }else if(_orderTypeIndex == 4){
      _orderType = 'return';
      getOrderList(context, 1, 'returned');
    }else if(_orderTypeIndex == 5){
      _orderType = 'failed';
      getOrderList(context, 1, 'failed');
    }else if(_orderTypeIndex == 6){
      _orderType = 'cancelled';
      getOrderList(context, 1, 'canceled');
    }else if(_orderTypeIndex == 7){
      _orderType = 'confirmed';
      getOrderList(context, 1, 'confirmed');
    }else if(_orderTypeIndex == 8){
      _orderType = 'out_for_delivery';
      getOrderList(context, 1, 'out_for_delivery');
    }
    if(notify){
      notifyListeners();
    }

  }


  Future setDeliveryCharge({int? orderId, String? deliveryCharge, String? deliveryDate, BuildContext? context}) async {
    ApiResponse apiResponse = await orderServiceInterface.setDeliveryCharge(orderId,deliveryCharge, deliveryDate);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderDetails(orderId.toString());
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBarWidget(message, Get.context!, isError: false);
      _startDate = null;
    }else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  Future <void> selectDate(BuildContext context)async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
        _startDate = date;
      notifyListeners();
    });
  }



  Future<ApiResponse> assignThirdPartyDeliveryMan(BuildContext context, String name,String trackingId, int? orderId) async {
    assigning = true;
    notifyListeners();
    ApiResponse apiResponse = await orderServiceInterface.assignThirdPartyDeliveryMan(name, trackingId, orderId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderDetails(orderId.toString());
      showCustomSnackBarWidget(getTranslated('third_party_delivery_type_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      assigning = false;
      getOrderList(Get.context!, 1,'all');
    } else {
      assigning = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponse> editShippingAndBillingAddress({String? orderID, String? addressType, String? contactPersonName, String? phone,
    String? city, String? zip, String? address, String? email, String? latitude, String? longitude,}) async {
    assigning = true;
    _isAddressLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderServiceInterface.orderAddressEdit(orderID: orderID,addressType: addressType, contactPersonName: contactPersonName,
    phone: phone, city: city, zip: zip, address: address, email: email, latitude: latitude, longitude: longitude);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      showCustomSnackBarWidget(getTranslated('address_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);

    } else {
      assigning = false;
      ApiChecker.checkApi(apiResponse);
    }
    _isAddressLoading = false;
    notifyListeners();
    return apiResponse;
  }


}
