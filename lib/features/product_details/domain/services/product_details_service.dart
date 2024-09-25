

import 'package:sixvalley_vendor_app/features/product_details/domain/repositories/product_details_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/product_details/domain/services/product_details_service_interface.dart';

class ProductDetailsService implements ProductDetailsServiceInterface {

  final ProductDetailsRepositoryInterface productDetailsRepositoryInterface;
  ProductDetailsService({required this.productDetailsRepositoryInterface});

  @override
  Future getProductDetails(int? productId) {
    return productDetailsRepositoryInterface.getProductDetails(productId);
  }

  @override
  Future productStatusOnOff(int? productId, int status) {
    return productDetailsRepositoryInterface.productStatusOnOff(productId, status);
  }
}