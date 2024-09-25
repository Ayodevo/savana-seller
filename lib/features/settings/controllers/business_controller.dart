import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/settings/domain/models/business_model.dart';
import 'package:sixvalley_vendor_app/features/settings/domain/services/business_service_interface.dart';

class BusinessController extends ChangeNotifier {
  final BusinessServiceInterface businessServiceInterface;

  BusinessController({required this.businessServiceInterface});

  List<BusinessModel>? _businessList;
  List<BusinessModel>? get businessList => _businessList;



  Future<void> getBusinessList(BuildContext context) async {
    _businessList = await businessServiceInterface.getBusinessList();
    notifyListeners();
  }

}
