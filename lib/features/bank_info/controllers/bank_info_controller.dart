import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/business_analytics_filter_data.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/profile_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/bank_info/domain/services/bank_info_service_interface.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/profile_info.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class BankInfoController extends ChangeNotifier {
  final BankInfoServiceInterface bankInfoServiceInterface;

  BankInfoController({required this.bankInfoServiceInterface});

  ProfileInfoModel? _bankInfo;
  List<double?>? _userEarnings;
  List<double?>? _userCommissions;
  ProfileInfoModel? get bankInfo => _bankInfo;
  List<double?>? get userEarnings => _userEarnings;
  List<double?>? get userCommissions => _userCommissions;

  String? _analyticsName = '';
  String? get analyticsName => _analyticsName;
  int _analyticsIndex = 0;
  int get analyticsIndex => _analyticsIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  BusinessAnalyticsFilterDataModel? _businessAnalyticsFilterData;
  BusinessAnalyticsFilterDataModel? get businessAnalyticsFilterData => _businessAnalyticsFilterData;
  int _revenueFilterTypeIndex = 0;
  int get revenueFilterTypeIndex => _revenueFilterTypeIndex;
  String? _revenueFilterType = '';
  String? get revenueFilterType => _revenueFilterType;

  bool _showWarning = true;
  bool get showWarning => _showWarning;

  void setRevenueFilterName(BuildContext context, String? filterName, bool notify) {
    _revenueFilterType = filterName;
    String? callingString;
    if(_revenueFilterType == 'this_year'){
      callingString = 'yearEarn';
    }else if(_revenueFilterType == 'this_month'){
      callingString = 'MonthEarn';
    }else if(_revenueFilterType == 'this_week'){
      callingString = 'WeekEarn';
    }
   getDashboardRevenueData(context, callingString);
    if(notify) {
      notifyListeners();
    }
  }

  void setRevenueFilterType(int index, bool notify) {
    _revenueFilterTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  List<dynamic> _earnings = [];
  List<dynamic> get earnings => _earnings;
  List<dynamic> _commission = [];
  List<dynamic> get commission => _commission;
  double _lim = 0.0;
  double get lim => _lim;


  Future<void> getDashboardRevenueData(BuildContext context, String? filterType) async {
    ApiResponse apiResponse = await bankInfoServiceInterface.chartFilterData(filterType);
    if(apiResponse.response != null  && apiResponse.response!.data != null && apiResponse.response!.statusCode == 200) {
      _userEarnings = [];
      _userCommissions  = [];
      _earnings = [];
      _commission =[];
      _earnings.addAll(apiResponse.response!.data['seller_earn']);
      _commission.addAll(apiResponse.response!.data['commission_earn']);
      for(dynamic data in _earnings) {
        try{
          _userEarnings!.add(data.toDouble());
        }catch(e){
          _userEarnings!.add(double.parse(data.toString()));
        }

      }
      for(dynamic data in _commission) {
        try{
          _userCommissions!.add(data.toDouble());
        }catch(e){
          _userCommissions!.add(double.parse(data.toString()));
        }
      }
      _userEarnings!.insert(0, 0);
      _userCommissions!.insert(0, 0);
      List<double?> counts = [];
      List<double?> comCounts = [];
      counts.addAll(_userEarnings!);
      comCounts.addAll(_userCommissions!);
      counts.sort();
      comCounts.sort();
      double max = 0;
      max = counts.isNotEmpty? counts[counts.length-1]??0 : 0;
      double maxx = 0;
      maxx = counts.isNotEmpty?comCounts[comCounts.length-1]??0:0;
      if(max>maxx){
        _lim = max;
      }else{
        _lim = maxx;
      }
    }else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getBankInfo(BuildContext context) async {
    _bankInfo = await bankInfoServiceInterface.getBankList();
    notifyListeners();
  }

  Future<ResponseModel?> updateBankInfo(BuildContext context,ProfileInfoModel updateUserModel, ProfileBody seller, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel = await bankInfoServiceInterface.updateBank(updateUserModel, seller, token);
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  String getBankToken() {
    return bankInfoServiceInterface.getBankToken();
  }


  void setAnalyticsFilterName(BuildContext context, String? filterName, bool notify) {
    _analyticsName = filterName;
    getAnalyticsFilterData(context, _analyticsName);
    if(notify) {
      notifyListeners();
    }
  }

  void setAnalyticsFilterType(int index, bool notify) {
    _analyticsIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  Future<void> getAnalyticsFilterData(BuildContext context, String? type) async {
    _isLoading = true;
    ApiResponse response = await bankInfoServiceInterface.getOrderFilterData(type);
    if(response.response != null && response.response!.statusCode == 200) {
      _businessAnalyticsFilterData = BusinessAnalyticsFilterDataModel.fromJson(response.response!.data);
      _isLoading = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  void setWarningValue(bool showWarning, {bool isUpdate = false}) {
    _showWarning = showWarning;
    if(isUpdate) {
      notifyListeners();
    }
  }

}
