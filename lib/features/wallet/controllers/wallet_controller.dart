import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/withdraw_model.dart';
import 'package:sixvalley_vendor_app/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class WalletController with ChangeNotifier{

  final WalletServiceInterface walletServiceInterface;
  WalletController({required this.walletServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  WithdrawModel? withdrawModel;
  List<WithdrawModel> methodList = [];
  int? methodSelectedIndex = 0;
  List<int?> methodsIds = [];

  List<String> inputValueList = [];
  bool validityCheck = false;




  void setTitle(int index, String title) {
    inputFieldControllerList[index].text = title;
  }


  List<TextEditingController> inputFieldControllerList = [];
  void getInputFieldList(){
    inputFieldControllerList = [];
    if(methodList.isNotEmpty){
      for(int i= 0; i< methodList[methodSelectedIndex!].methodFields!.length; i++){
        inputFieldControllerList.add(TextEditingController());
      }
    }

  }

  List <String?> keyList = [];


  void setMethodTypeIndex(int? index, {bool notify = true}){
    methodSelectedIndex = index;
    keyList = [];
    if(methodList.isNotEmpty){
      for(int i= 0; i< methodList[methodSelectedIndex!].methodFields!.length; i++){
        keyList.add(methodList[methodSelectedIndex!].methodFields![i].inputName);
      }
      getInputFieldList();
    }
    if(notify){
      notifyListeners();
    }

  }


  Future<void> getWithdrawMethods(BuildContext context) async{
    methodList = [];
    methodsIds = [];
    ApiResponse response = await walletServiceInterface.getDynamicWithDrawMethod();
      response.response!.data.forEach((method) => methodList.add(WithdrawModel.fromJson(method)));
      methodSelectedIndex = 0;
      getInputFieldList();
      for(int index = 0; index < methodList.length; index++) {
        methodsIds.add(methodList[index].id);
      }
    notifyListeners();
  }



  void checkValidity(){
    for(int i= 0; i< inputValueList.length; i++){
      if(inputValueList[i].isEmpty){
        inputValueList.clear();
        validityCheck = true;
        notifyListeners();
      }
    }

  }


  Future<ApiResponse> updateBalance(String balance, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    for(TextEditingController textEditingController in inputFieldControllerList) {
      inputValueList.add(textEditingController.text.trim());

    }
    ApiResponse apiResponse = await walletServiceInterface.withdrawBalance(keyList, inputValueList, methodList[methodSelectedIndex!].id, balance);
      inputValueList.clear();
      inputFieldControllerList.clear();
      Provider.of<ProfileController>(context, listen: false).getSellerInfo();
      _isLoading = false;
      notifyListeners();
      showCustomSnackBarWidget(getTranslated('withdraw_request_sent_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      Navigator.pop(Get.context!);
    return apiResponse;
  }


}