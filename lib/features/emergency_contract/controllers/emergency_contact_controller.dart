import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/emergency_contract/domain/models/emergency_contact_model.dart';
import 'package:sixvalley_vendor_app/features/emergency_contract/domain/services/emergency_contruct_service_interface.dart';
import 'package:sixvalley_vendor_app/main.dart';

class EmergencyContactController extends ChangeNotifier {
  final EmergencyServiceInterface emergencyServiceInterface;
  EmergencyContactController({required this.emergencyServiceInterface});


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<ContactList> _contactList =[];
  List<ContactList> get contactList => _contactList;
  late EmergencyContactModel _emergencyContactModel;


  String? _countryDialCode = '+880';
  String? get countryDialCode => _countryDialCode;



  Future<void> getEmergencyContactList() async {

    _isLoading = true;
    _emergencyContactModel = await emergencyServiceInterface.getEmergencyContactList();
    _contactList = [];
    _contactList.addAll(_emergencyContactModel.contactList!);
    _isLoading = false;
    notifyListeners();
  }




  Future<void> statusOnOffEmergencyContact(BuildContext context, int? id, int status, int? index) async {

     ResponseModel responseModel = await emergencyServiceInterface.statusOnOffEmergencyContact(id, status);
     if(responseModel.isSuccess){
       _contactList[index!].status = status;
     }
    _isLoading = false;
    notifyListeners();
  }


  Future<void> deleteEmergencyContact(BuildContext context, int? id) async {

    ResponseModel responseModel = await emergencyServiceInterface.deleteEmergencyContact(id);
    if(responseModel.isSuccess){
      getEmergencyContactList();
    }
    notifyListeners();
  }

  Future<void> addNewEmergencyContact(BuildContext context, String name, String phone,int? id, {bool isUpdate = false}) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel = await emergencyServiceInterface.addNewEmergencyContact(name, phone,id, isUpdate: isUpdate);
    if(responseModel.isSuccess){
      getEmergencyContactList();
      Navigator.pop(Get.context!);
    }
    _isLoading = false;
    notifyListeners();
  }


  void setCountryDialCode (String? setValue){
    _countryDialCode = setValue;
  }

}