

abstract class EmergencyServiceInterface {
  Future<dynamic> getEmergencyContactList();
  Future<dynamic> addNewEmergencyContact(String name, String phone,int? id, {bool isUpdate = false});
  Future<dynamic> deleteEmergencyContact(int? id);
  Future<dynamic> statusOnOffEmergencyContact(int? id, int status);
}