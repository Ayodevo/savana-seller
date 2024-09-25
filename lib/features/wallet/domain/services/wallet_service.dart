

import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class WalletService implements WalletServiceInterface{
  final WalletRepositoryInterface walletRepoInterface;
  WalletService({required this.walletRepoInterface});

  @override
  Future getDynamicWithDrawMethod() async{
    ApiResponse apiResponse = await walletRepoInterface.getDynamicWithDrawMethod();
    if(apiResponse.response!.statusCode == 200) {
      return apiResponse;
    }else{
      ApiChecker.checkApi( apiResponse);
    }
  }


  @override
  Future withdrawBalance(List<String?> typeKey, List<String> typeValue, int? id, String balance) async {
    ApiResponse apiResponse = await walletRepoInterface.withdrawBalance(
        typeKey, typeValue, id, balance);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      return apiResponse;
    }
  }
}