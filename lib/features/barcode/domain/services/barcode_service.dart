

import 'package:sixvalley_vendor_app/features/barcode/domain/repositories/barcode_reposity_interface.dart';
import 'package:sixvalley_vendor_app/features/barcode/domain/services/barcode_service_interface.dart';

class BarcodeService implements BarcodeServiceInterface{
  final BarcodeRepositoryInterface barcodeRepositoryInterface;
  BarcodeService({required this.barcodeRepositoryInterface});


  @override
  Future barCodeDownLoad(int? id, int quantity) {
    return barcodeRepositoryInterface.barCodeDownLoad(id, quantity);
  }
}