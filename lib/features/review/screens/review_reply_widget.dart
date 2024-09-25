import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/image_diaglog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/rating_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/review/domain/models/review_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/review/controllers/product_review_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';


class ReviewReplyScreen extends StatefulWidget {
  final ReviewModel? reviewModel;
  final int? index;
  final int? productId;
  final bool? formProduct;
  const ReviewReplyScreen({Key? key, this.reviewModel, this.index, this.productId, this.formProduct = true}) : super(key: key);

  @override
  State<ReviewReplyScreen> createState() => _ReviewReplyScreenState();
}

class _ReviewReplyScreenState extends State<ReviewReplyScreen> {

  @override
  void initState() {
    Provider.of<ProductReviewController>(context, listen: false).emptyReplyText();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title : getTranslated('review_reply', context), isAction: true, isSwitch: true,
        index: widget.index,
        productReviewSwitch: widget.formProduct!,
        reviewSwitch: !widget.formProduct!,
        switchAction: (value){
          if(value){
            Provider.of<ProductReviewController>(context, listen: false).reviewStatusOnOff(context, widget.reviewModel!.id, 1, widget.index, fromProduct: widget.formProduct!);
          }else{
            Provider.of<ProductReviewController>(context, listen: false).reviewStatusOnOff(context, widget.reviewModel!.id, 0, widget.index, fromProduct: widget.formProduct!);
          }
        },),
      body: Consumer<ProductReviewController>(
          builder: (context, review, _) {
            if(widget.reviewModel?.reply != null){
              review.reviewReplyController.text = widget.reviewModel?.reply?.replyText ?? ' ';
            }

          return Column(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                  
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(flex: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                  child: Container(
                                    width: Dimensions.stockOutImageSize,
                                    height: Dimensions.stockOutImageSize,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!,
                                          spreadRadius: 0.5, blurRadius: 0.3)],
                  
                                    ),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                                        child: CustomImageWidget(image: '${widget.reviewModel!.product!.thumbnailFullUrl?.path}',)
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              ],
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                  
                  
                          Flexible(flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                  
                                  widget.reviewModel?.orderId != null?
                                  Text('${getTranslated('order_id', context)!} # ${widget.reviewModel!.orderId}', style: titilliumRegular.copyWith(color: Theme.of(context).hintColor))
                                  :  const SizedBox(),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  
                                  Text( widget.reviewModel!.product!.name ?? '', style: robotoBold,
                                    maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify),
                  
                                  Row(children: [
                                    FittedBox(child: RatingBar(rating: widget.reviewModel?.rating, size: 15,)),
                  
                                    Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                        child: Text(widget.reviewModel!.rating.toString(),
                                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor))),
                                  ],
                                  ),
                  
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  
                                ]),
                            ),
                          )
                  
                        ]),
                      ),
                  
                  
                  
                      Text(widget.reviewModel!.comment ?? '',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  
                      (widget.reviewModel!.attachmentFullUrl != null && widget.reviewModel!.attachmentFullUrl!.isNotEmpty) ? Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                        child: SizedBox(
                          height: 45,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.reviewModel!.attachmentFullUrl!.length,
                            itemBuilder: (context, index) {
                              String imageUrl = '${widget.reviewModel!.attachmentFullUrl![index].path}';
                              return InkWell(
                                onTap: () => showDialog(context: context, builder: (ctx) =>
                                    ImageDialogWidget(imageUrl:imageUrl), ),
                                child: Container(
                                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholderImage, height: 45, width: 45, fit: BoxFit.cover,
                                      image: imageUrl,
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 40, width: 40, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ) : const SizedBox(),


                  (widget.reviewModel!.attachmentFullUrl != null && widget.reviewModel!.attachmentFullUrl!.isNotEmpty)  ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
                  
                  
                      CustomTextFieldWidget(
                        isDescription: true,
                        controller: review.reviewReplyController,
                        textInputType: TextInputType.multiline,
                        maxLine: 4,
                        border: true,
                        hintText: getTranslated('write_your_reply_here', context),
                      ),
                    ]
                  ),
                ),
              )),


              Container(height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(.125),
                      spreadRadius: 2, blurRadius: 5, offset: Offset.fromDirection(1,2))],
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                width: MediaQuery.of(context).size.width,
                child: !review.isLoading
                  ? CustomButtonWidget(
                    borderRadius: 10,
                    backgroundColor: Theme.of(context).primaryColor,
                    onTap: (){
                      if (review.reviewReplyController.text.isEmpty) {
                        showCustomSnackBarWidget(getTranslated('write_a_review_reply', context), context, isError: false);
                      }else{
                        review.sendReviewReply(
                          context, widget.reviewModel!.id!, widget.productId!,
                          review.reviewReplyController.text,
                          widget.formProduct!
                        );
                      }
                    },
                    // update_reply
                    btnTxt: widget.reviewModel?.reply != null ?
                    getTranslated('update_reply', context) : getTranslated('submit', context)
                  )
                    : Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
              )
            ],
          );
        }
      )

    );
  }
}
