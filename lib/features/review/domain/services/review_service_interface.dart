
abstract class ReviewServiceInterface {
  Future<dynamic> productReviewList();
  Future<dynamic> filterProductReviewList(int? productId, int? customerId, int status, String? from, String? to);
  Future<dynamic> searchProductReviewList(String search);
  Future<dynamic> reviewStatusOnOff(int? reviewId, int status);
  Future<dynamic> getProductWiseReviewList(int? productId,int offset);
  Future<dynamic> sendReviewReply(int? reviewId,String replyText);

}