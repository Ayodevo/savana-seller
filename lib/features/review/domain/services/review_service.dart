

import 'package:sixvalley_vendor_app/features/review/domain/repositories/product_review_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/review/domain/services/review_service_interface.dart';

class ReviewService implements ReviewServiceInterface{
  final ProductReviewRepositoryInterface productReviewRepoInterface;
  ReviewService({required this.productReviewRepoInterface});

  @override
  Future filterProductReviewList(int? productId, int? customerId, int status, String? from, String? to) {
    return productReviewRepoInterface.filterProductReviewList(productId, customerId, status, from, to);
  }

  @override
  Future productReviewList() {
    return productReviewRepoInterface.productReviewList();
  }

  @override
  Future reviewStatusOnOff(int? reviewId, int status) {
    return productReviewRepoInterface.reviewStatusOnOff(reviewId, status);
  }

  @override
  Future searchProductReviewList(String search) {
    return productReviewRepoInterface.searchProductReviewList(search);
  }

  @override
  Future getProductWiseReviewList(int? productId, int offset) {
    return productReviewRepoInterface.getProductWiseReviewList(productId, offset);
  }


  @override
  Future sendReviewReply(int? reviewId,String replyText) {
    return productReviewRepoInterface.sendReviewReply(reviewId, replyText);
  }

}