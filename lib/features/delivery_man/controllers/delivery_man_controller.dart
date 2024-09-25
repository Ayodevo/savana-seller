import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/collected_cash_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_body.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_earning_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_order_history_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_review_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_withdraw_detail_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_withdraw_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/order_history_log_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_detail_model.dart' as d;
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/services/delivery_service_interface.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/order/controllers/order_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class DeliveryManController extends ChangeNotifier {
  final DeliveryServiceInterface deliveryServiceInterface;
  DeliveryManController({required this.deliveryServiceInterface});
  List<DeliveryManModel>? _deliveryManList;
  List<DeliveryManModel>? get  deliveryManList => _deliveryManList;
  List<DeliveryMan>? _topDeliveryManList;
  List<DeliveryMan>? get topDeliveryManList =>_topDeliveryManList;
  List<DeliveryMan>? _listOfDeliveryMan;
  List<DeliveryMan>? get listOfDeliveryMan =>_listOfDeliveryMan;
  int? _deliveryManIndex = 0;
  int? get deliveryManIndex => _deliveryManIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _addOrderStatusErrorText;
  String? get addOrderStatusErrorText => _addOrderStatusErrorText;
  List<int?> _deliveryManIds = [];
  List<int?> get deliveryManIds => _deliveryManIds;
  d.DeliveryManDetailsModel? _deliveryManDetails;
  d.DeliveryManDetailsModel? get deliveryManDetails =>_deliveryManDetails;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController identityNumber = TextEditingController();
  TextEditingController addressController = TextEditingController();
  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode identityNumberNode = FocusNode();
  FocusNode addressNode = FocusNode();
  XFile? _profileImage;
  XFile? get profileImage => _profileImage;
  XFile? _identityImage;
  XFile? get identityImage => _identityImage;
  List<XFile?> _identityImages = [];
  List<XFile?> get identityImages => _identityImages;
  List<Order> _deliverymanOrderList = [];
  List<Order> get deliverymanOrderList => _deliverymanOrderList;
  DeliveryManEarningModel? _deliveryManEarning;
  DeliveryManEarningModel? get deliveryManEarning=> _deliveryManEarning;
  final List<Earning> _earningList =[];
  List<Earning> get earningList => _earningList;
  List<OrderHistoryLogModel> _changeLogList =[];
  List<OrderHistoryLogModel> get changeLogList => _changeLogList;
  final List<String> _deliveryTypeList = ['select_delivery_type','by_self_delivery_man', 'by_third_party_delivery_service'];
  List<String> get deliveryTypeList => _deliveryTypeList;
  List<Withdraws> _withdrawList = [];
  List<Withdraws> get withdrawList => _withdrawList;
  List<DeliveryManReview> _deliveryManReviewList = [];
  List<DeliveryManReview> get deliveryManReviewList => _deliveryManReviewList;
  Details? _details;
  Details? get details => _details;
  int _selectedDeliveryTypeIndex = 0;
  int get selectedDeliveryTypeIndex => _selectedDeliveryTypeIndex;



  void pickImage(bool isProfile, bool isRemove) async {
    if(isRemove) {
      _profileImage = null;
      _identityImages = [];
    }else {
      if (isProfile) {
        _profileImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      }else {
        _identityImage = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (_identityImage != null) {
          _identityImages.add(_identityImage);

        }
      }
    }

    notifyListeners();

  }


  void removeImage(int index){
    _identityImages.removeAt(index);
    notifyListeners();
  }


  int _selectionTabIndex = 1;
  int get selectionTabIndex =>_selectionTabIndex;
  void setIndexForTabBar(int index, {bool isNotify = true}){
    _selectionTabIndex = index;
    if(isNotify){
      notifyListeners();
    }
  }

  Future<void> getDeliveryManList(Order? orderModel) async {
    _deliveryManIds =[];
    _deliveryManIds.add(0);
    _deliveryManIndex = 0;
    ApiResponse apiResponse = await deliveryServiceInterface.getDeliveryManList();
    _deliveryManList = [];
    apiResponse.response!.data.forEach((deliveryMan) => _deliveryManList!.add(DeliveryManModel.fromJson(deliveryMan)));
    for(int index = 0; index < _deliveryManList!.length; index++) {
      _deliveryManIds.add(_deliveryManList![index].id);
    }

    if(orderModel!.deliveryManId != null){
      setDeliverymanIndex(deliveryManIds.indexOf(int.parse(orderModel.deliveryManId.toString())), false);
    }

    notifyListeners();
  }

  Future<void> deliveryManListURI(int offset, String search, {bool reload = true}) async {
    if(reload){
      _listOfDeliveryMan = [];
      _isLoading = true;
    }
    ApiResponse apiResponse = await deliveryServiceInterface.deliveryManList(offset, search);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _listOfDeliveryMan = [];
      _listOfDeliveryMan!.addAll(TopDeliveryManModel.fromJson(apiResponse.response!.data).deliveryMan!);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getDeliveryManOrderList(BuildContext context, int offset, int? deliveryManId, {bool reload = true}) async {
    if(reload){
      _deliverymanOrderList = [];
      _isLoading = true;
    }
    ApiResponse apiResponse = await deliveryServiceInterface.deliveryManOrderList(offset, deliveryManId);
    _deliverymanOrderList.addAll(DeliveryManOrderHistoryModel.fromJson(apiResponse.response!.data).orders!);
    _isLoading = false;
    notifyListeners();
  }



  Future<void> getDeliveryManEarningList(BuildContext context, int offset, int? deliveryManId, {bool reload = true}) async {
    if(reload){
      _deliveryManEarning = null;
    }
    _isLoading = true;
    ApiResponse apiResponse = await deliveryServiceInterface.deliveryManEarningList(offset, deliveryManId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1) {
        _deliveryManEarning = DeliveryManEarningModel.fromJson(apiResponse.response!.data);
      }else{
        _deliveryManEarning!.totalSize = DeliveryManEarningModel.fromJson(apiResponse.response!.data).totalSize;
        _deliveryManEarning!.offset = DeliveryManEarningModel.fromJson(apiResponse.response!.data).offset;
        _deliveryManEarning!.orders!.addAll(DeliveryManEarningModel.fromJson(apiResponse.response!.data).orders!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }


  Future<void> getDeliveryManDetails(int? deliveryManId) async {
    _isLoading = true;
    ApiResponse apiResponse = await deliveryServiceInterface.deliveryManDetails(deliveryManId);
    _deliveryManDetails = d.DeliveryManDetailsModel.fromJson(apiResponse.response!.data);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getTopDeliveryManList(BuildContext context, {bool reload = true}) async {
    if(reload){
      _isLoading = false;
      _topDeliveryManList = [];
    }
    _isLoading = true;
    ApiResponse apiResponse = await deliveryServiceInterface.getTopDeliveryManList();
    _topDeliveryManList!.addAll(TopDeliveryManModel.fromJson(apiResponse.response!.data).deliveryMan!);
    _isLoading = false;
    notifyListeners();
  }


  Future<void> getDeliveryManOrderHistoryLogList(BuildContext context, int? orderId) async {
    _isLoading = true;
    _changeLogList =[];
    _changeLogList = await deliveryServiceInterface.getDeliverymanOrderHistoryLog(orderId);
    _isLoading = false;
    notifyListeners();
  }


  void setDeliveryTypeIndex(int index, bool notify){
    _selectedDeliveryTypeIndex = index;
    if(notify){
      notifyListeners();
    }

  }


  Future<void> assignDeliveryMan(BuildContext context,int? orderId, int? deliveryManId) async {
    _isLoading = true;
    ResponseModel responseModel = await deliveryServiceInterface.assignDeliveryMan(orderId, deliveryManId);
    if(responseModel.isSuccess){
      Provider.of<OrderController>(Get.context!, listen: false).getOrderList(Get.context!, 1,'all');
      Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderDetails(orderId.toString());
      showCustomSnackBarWidget(getTranslated('delivery_man_assign_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deliveryManStatusOnOff(BuildContext context,int? id, int status) async {
    _isLoading = true;
    ResponseModel responseModel = await deliveryServiceInterface.deliveryManStatusOnOff(id, status);
    if(responseModel.isSuccess){
      getDeliveryManDetails(id);
      _deliveryManDetails!.deliveryMan!.isActive = status;
      _isLoading = false;
      showCustomSnackBarWidget(getTranslated('status_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> collectCashFromDeliveryMan(BuildContext context, int? deliveryManId, String amount) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel = await deliveryServiceInterface.collectCashFromDeliveryMan(deliveryManId, amount);
    _isLoading= false;
    if(responseModel.isSuccess){
      Navigator.pop(Get.context!);
      getDeliveryManDetails(deliveryManId);
      showCustomSnackBarWidget(getTranslated('amount_collected_from_deliveryman', Get.context!), Get.context!, isToaster: true);
    }else{
      showCustomSnackBarWidget(responseModel.message, Get.context!, isToaster: true);
    }
    _isLoading = false;
    notifyListeners();
  }


  Future<void> deleteDeliveryMan(BuildContext context, int? deliveryManId) async {
    ResponseModel responseModel = await deliveryServiceInterface.deleteDeliveryMan(deliveryManId);
    if(responseModel.isSuccess){
        deliveryManListURI(1,'');
        showCustomSnackBarWidget(responseModel.message, Get.context!, isError: false);
    }
    notifyListeners();
  }


  void setDeliverymanIndex(int? index, bool notify) {
    _deliveryManIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  final List<String> _identityTypeList = ['Passport', 'Driving Licence', 'Nid', 'Company Id' ];
  List<String> get identityTypeList => _identityTypeList;

  String? _identityType;
  String? get identityType => _identityType;

  void setIdentityType (String? setValue){
    if (kDebugMode) {
      print('------$setValue====$_identityType');
    }
    _identityType = setValue;

  }
  String? _countryDialCode = '+880';
  String? get countryDialCode => _countryDialCode;

  void setCountryDialCode (String? setValue){
    if (kDebugMode) {
      print('------$setValue====$_identityType');
    }
    _countryDialCode = setValue;

  }



  Future<ResponseModel> addNewDeliveryMan(BuildContext context, DeliveryManBody deliveryManBody, {bool isUpdate = false}) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel  responseModel = await deliveryServiceInterface.addNewDeliveryMan(_profileImage, _identityImages,
        deliveryManBody, Provider.of<AuthController>(context, listen: false).getUserToken(), isUpdate: isUpdate);
    if(responseModel.isSuccess){
        firstNameController.clear();
        lastNameController.clear();
        phoneController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        identityNumber.clear();
        addressController.clear();
        _profileImage = null;
        _identityImage = null;
        _identityImages = [];
        isUpdate?
        showCustomSnackBarWidget(getTranslated("delivery_man_updated_successfully", Get.context!), Get.context!, isError: false):
        showCustomSnackBarWidget(getTranslated("delivery_man_added_successfully", Get.context!), Get.context!, isError: false);
    }
    _isLoading = false;
    notifyListeners();
    return ResponseModel(true, '');
  }

  Future<void> getDeliveryManWithdrawDetails(BuildContext context, int? id) async {
    _isLoading = true;
    _details = await deliveryServiceInterface.deliveryManWithdrawDetails(id);
    log("===response==>${_details?.toJson()}");
    _isLoading = false;
    notifyListeners();
  }



  Future<void> getDeliveryManWithdrawList(int offset, String status, {bool reload = true}) async {
    if(reload){
      _withdrawList = [];
      _isLoading = true;
    }
    ApiResponse apiResponse = await deliveryServiceInterface.deliveryManWithdrawList(offset, status);
    _withdrawList.addAll(DeliveryManWithdrawModel.fromJson(apiResponse.response!.data).withdraws!);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getDeliveryManReviewList(BuildContext context, int offset, int? id , {bool reload = true}) async {
    if(reload){
      _deliveryManReviewList = [];
      _isLoading = true;
    }
    ApiResponse apiResponse = await deliveryServiceInterface.getDeliveryManReviewList(offset, id);
    _deliveryManReviewList.addAll(DeliveryManReviewModel.fromJson(apiResponse.response!.data).reviews!);
    _isLoading = false;
    notifyListeners();
  }


  Future<void> deliveryManWithdrawApprovedDenied(BuildContext context,int? id, String note, int approved, int? index) async {
    _isLoading = true;
    ResponseModel responseModel = await deliveryServiceInterface.deliveryManWithdrawApprovedDenied(id, note, approved);
    if(responseModel.isSuccess){
        Navigator.pop(Get.context!);
        _withdrawList[index!].approved = approved;
        getDeliveryManWithdrawList(1, 'all');
      }
    _isLoading = false;
    notifyListeners();
  }


  int _withdrawTypeIndex = 0;
  int get withdrawTypeIndex => _withdrawTypeIndex;

  void setIndex(BuildContext context,int index) {
    _withdrawTypeIndex = index;
    if(_withdrawTypeIndex == 0){
      getDeliveryManWithdrawList( 1,'all', reload: true);
    }
    else if(_withdrawTypeIndex == 1){
      getDeliveryManWithdrawList( 1,'pending', reload: true);
    }
    else if(_withdrawTypeIndex == 2){
      getDeliveryManWithdrawList( 1,'approved', reload: true);
    }else if(_withdrawTypeIndex == 3){
      getDeliveryManWithdrawList( 1,'denied', reload: true);
    }
    notifyListeners();
  }


  CollectedCashModel? _collectedCashModel;
  CollectedCashModel? get collectedCashModel => _collectedCashModel;

  Future<void> getDeliveryCollectedCashList(BuildContext context, int? deliveryManId, int offset) async {

    ApiResponse apiResponse = await deliveryServiceInterface.getDeliveryManCollectedCashList(deliveryManId, offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1 ){
        _collectedCashModel = null;
        _collectedCashModel = CollectedCashModel.fromJson(apiResponse.response!.data);
      }else{
        _collectedCashModel!.totalSize =  CollectedCashModel.fromJson(apiResponse.response!.data).totalSize;
        _collectedCashModel!.offset =  CollectedCashModel.fromJson(apiResponse.response!.data).offset;
        _collectedCashModel!.collectedCash!.addAll(CollectedCashModel.fromJson(apiResponse.response!.data).collectedCash!)  ;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

}