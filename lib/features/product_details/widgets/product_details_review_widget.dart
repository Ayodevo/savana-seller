import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/review/controllers/product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/review/domain/models/product_review_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/rating_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/product/widgets/product_review_item_widget.dart';

class ProductReviewWidget extends StatefulWidget {
  final Product? productModel;
  const ProductReviewWidget({Key? key, this.productModel}) : super(key: key);
  @override
  State<ProductReviewWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewWidget> {
  ScrollController scrollController = ScrollController();

  late ScrollController _controller;
  String message = "";
  bool activated = false;
  bool endScroll = false;
  _onStartScroll(ScrollMetrics metrics) {
    setState(() {
      message = "start";
    });
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    setState(() {
      message = "scrolling";
    });
  }

  _onEndScroll(ScrollMetrics metrics) {
    setState(() {
      message = "end";
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
      setState(() {
        endScroll = true;
        message = "bottom";
      });
    }

  }
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }
  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(message == 'end' && !endScroll){
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            activated = true;
          });
        }
      });
    }else{
      activated = false;
    }
    return  RefreshIndicator(
      onRefresh: () async{
        Provider.of<ProductReviewController>(context, listen: false).getProductWiseReviewList(context, 1, widget.productModel!.id);
      },
      child: Consumer<ProductReviewController>(
        builder: (context, review,_) {
          double fiveStar = 0.0, fourStar = 0.0, threeStar = 0.0,twoStar = 0.0, oneStar = 0.0;

          if(review.productReviewModel != null && review.productReviewModel!.groupWiseRating!.isNotEmpty){
            List<GroupWiseRating> rating = review.productReviewModel!.groupWiseRating!;
            for(int i =0 ; i< rating.length; i++){
              if(rating[i].rating == 1){
                oneStar = (rating[i].rating! * rating[i].total!) / (rating.length * 5);
              }
              if(rating[i].rating == 2){
                twoStar = (rating[i].rating! * rating[i].total!) / (rating.length * 5);
              }
              if(rating[i].rating == 3){
                threeStar = (rating[i].rating! * rating[i].total!) / (rating.length * 5);
              }
              if(rating[i].rating == 4){
                fourStar = (rating[i].rating! * rating[i].total!) / (rating.length * 5);
              }
              if(rating[i].rating == 5){
                fiveStar = (rating[i].rating! * rating[i].total!) / (rating.length * 5);
              }
            }
          }

          return review.productReviewModel == null  ? const Center(child: CircularProgressIndicator()) : Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                    _onStartScroll(scrollNotification.metrics);
                  } else if (scrollNotification is ScrollUpdateNotification) {
                    _onUpdateScroll(scrollNotification.metrics);
                  } else if (scrollNotification is ScrollEndNotification) {
                    _onEndScroll(scrollNotification.metrics);
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Align(alignment: Provider.of<LocalizationController>(context, listen: false).isLtr?Alignment.centerLeft: Alignment.bottomRight,
                                  child: Text(getTranslated('product_reviews', context)!,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault))),


                              Text((review.productReviewModel?.averageRating ?? review.productReviewModel?.averageRating.toString())??'',
                                  style: robotoBold.copyWith(color:Theme.of(context).colorScheme.primary,
                                      fontSize: Dimensions.fontSizeOverlarge)),

                              RatingBarIndicatorWidget(
                                rating: review.productReviewModel?.averageRating != null? double.parse(review.productReviewModel!.averageRating.toString()) : 0,
                                itemBuilder: (context, index) => Icon(
                                    Icons.star_rate_rounded,
                                    color: Theme.of(context).primaryColor.withOpacity(.75)),
                                itemCount: 5,
                                itemSize: Dimensions.iconSizeLarge,
                                unratedColor: Theme.of(context).primaryColor.withOpacity(.35),
                                direction: Axis.horizontal,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                child: Text("${review.productReviewModel?.totalSize} ${getTranslated('reviews', context)}",
                                  style: robotoRegular.copyWith(),
                                ),
                              ),
                            ],
                          ),


                          _progressBar(
                            title: 'excellent',
                            percent: fiveStar,
                          ),
                          _progressBar(
                            title: 'good',
                            percent: fourStar,
                          ),
                          _progressBar(
                            title: 'average',
                            percent: threeStar,
                          ),
                          _progressBar(
                            title: 'below_average',
                            percent: twoStar,
                          ),
                          _progressBar(
                            title: 'poor',
                            percent: oneStar,
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          //   child: Divider(color: Theme.of(context).hintColor, thickness: 1,),
                          // ),


                          SingleChildScrollView(
                            controller: scrollController,
                            child: PaginatedListViewWidget(
                              reverse: false,
                              scrollController: scrollController,
                              totalSize: review.productReviewModel!.totalSize,
                              offset: review.productReviewModel != null ? int.parse(review.productReviewModel!.offset!) : null,
                              onPaginate: (int? offset) async {
                                await review.getProductWiseReviewList(context, offset!, widget.productModel!.id);
                              },
                              itemView: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: review.productReviewList.length,
                                  itemBuilder: (context, index){
                                    return ProductReviewItemWidget(reviewModel: review.productReviewList[index], index: index, productId: widget.productModel!.id!);
                                  }),
                            ),
                          )

                          //ReviewList

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // activated?
              // const SeeMoreButtonWidget(): const SizedBox(),
            ],
          );
        }
      ),
    );
  }
  Widget _progressBar(
      {required String title, required double percent, Color ? colr}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getTranslated(title, context)!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8C8C8C)),
          ),
          const SizedBox(width: 10,),
          SizedBox(
            width: 220,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              child: LinearProgressIndicator(
                value: percent,
                valueColor: AlwaysStoppedAnimation<Color>(colr ?? Theme.of(context).primaryColor.withOpacity(0.30)),
                backgroundColor: const Color(0xFFEAEAEA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
