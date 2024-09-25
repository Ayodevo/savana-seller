abstract class RefundServiceInterface {
  Future<dynamic> getRefundList();
  Future<dynamic> getRefundReqDetails(int? orderDetailsId);
  Future<dynamic> refundStatus(int? refundId , String status, String note);
  Future<dynamic> getRefundStatusList(String type);
}