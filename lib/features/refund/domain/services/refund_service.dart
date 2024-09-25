
import 'package:sixvalley_vendor_app/features/refund/domain/repositories/refund_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/services/refund_service_interface.dart';

class RefundService implements RefundServiceInterface{
  final RefundRepositoryInterface refundRepoInterface;
  RefundService({required this.refundRepoInterface});

  @override
  Future getRefundList() {
   return refundRepoInterface.getList();
  }

  @override
  Future getRefundReqDetails(int? orderDetailsId) {
    return refundRepoInterface.getRefundReqDetails(orderDetailsId);
  }

  @override
  Future getRefundStatusList(String type) {
    return refundRepoInterface.getRefundStatusList(type);
  }

  @override
  Future refundStatus(int? refundId, String status, String note) {
    return refundRepoInterface.refundStatus(refundId, status, note);
  }
}