import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sixvalley_vendor_app/features/review/controllers/product_review_controller.dart';
import 'package:sixvalley_vendor_app/features/review/domain/models/review_model.dart';
import 'package:sixvalley_vendor_app/features/review/screens/review_reply_widget.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/rating_bar_widget.dart';

class ProductReviewItemWidget extends StatelessWidget {
  final ReviewModel reviewModel;
  final int index;
  final int productId;
  const ProductReviewItemWidget({Key? key, required this.reviewModel, required this.index, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          boxShadow: [
            BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.10), offset: Offset(0, 6), blurRadius: 15, spreadRadius: -3),
          ],
        ),

        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
                boxShadow: const [
                   BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    spreadRadius: -3,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),


                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(getTranslated('review_id', context)!, style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor)),
                            Text(' ${reviewModel.id}', style: titilliumBold),
                          ],
                          ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        reviewModel.createdAt != null?
                        Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(reviewModel.createdAt!)),style: robotoRegular.copyWith(color: Theme.of(context).hintColor),) : const SizedBox(),
                      ],
                    ),
                  ),

                  FlutterSwitch(
                    width: 40, height: 22, toggleSize: 18,
                    padding: 2,
                    value: reviewModel.status == 1 ? true : false,
                    onToggle: (bool value) {
                      if(value){
                        Provider.of<ProductReviewController>(context, listen: false).reviewStatusOnOff(context, reviewModel.id, 1, index, fromProduct: true);
                      }else{
                        Provider.of<ProductReviewController>(context, listen: false).reviewStatusOnOff(context, reviewModel.id, 0, index, fromProduct: true);
                      }
                    },
                  )


                ],
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(children: [
                  if(reviewModel.customer != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
                    child: SizedBox(width: Dimensions.productImageSize,
                      height: Dimensions.productImageSize,
                      child: CustomImageWidget(image:"${reviewModel.customer?.imageFullUrl?.path}"),),),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if(reviewModel.customer != null)
                      Text("${reviewModel.customer!.fName!} ${reviewModel.customer!.lName!}",
                        style: robotoMedium.copyWith(),
                      ),
                      if(reviewModel.customer == null)
                        Text(getTranslated('customer_not_available', context)!,
                        style: robotoMedium.copyWith(),),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    reviewModel.orderId != null ?
                    Text('${getTranslated('order_id', context)!} # ${reviewModel.orderId}', style: titilliumRegular.copyWith(color: Theme.of(context).hintColor)) : const SizedBox(),


                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Row(children: [
                        FittedBox(child: RatingBar(rating: reviewModel.rating, size: 15,)),

                        Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                          child: Text(reviewModel.rating.toString(),
                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor))),
                        ],
                      )
                  ])),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),

                  Provider.of<SplashController>(context, listen: false).configModel!.reviewReplyStatus == true ?
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> ReviewReplyScreen(reviewModel: reviewModel, index: index, productId: productId,)));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                        color: reviewModel.reply != null ?  Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05) : Theme.of(context).colorScheme.surfaceTint
                      ),
                      child: Text( reviewModel.reply != null ? getTranslated('view_reply', context)!  :getTranslated('review_reply', context)!, style : robotoBold.copyWith(color: reviewModel.reply != null ?  Theme.of(context).colorScheme.surfaceTint : Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                    ),
                  ) : const SizedBox()
                ],
              ),
            ),

            (reviewModel.comment != null && reviewModel.comment!.isNotEmpty) ?
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: ReadMoreText(
                reviewModel.comment ?? '',
                trimMode: TrimMode.Line,
                trimLines: 3,
                textAlign: TextAlign.justify,
                colorClickableText: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
                preDataTextStyle: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05)),
                moreStyle: TextStyle(color : Theme.of(context).colorScheme.surfaceTint),
                lessStyle: TextStyle(color : Theme.of(context).colorScheme.surfaceTint),
                trimCollapsedText: getTranslated('view_moree', context)!,
                trimExpandedText: getTranslated('view_less', context)!,
              ),
            ) : const SizedBox(),


            // Text(reviewModel?.comment ?? '',
            //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.justify,
            // ),

            // Padding(padding: const EdgeInsets.only(left: 2,top : Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeDefault),
            //     child: Text(reviewModel.comment??'',
            //       style: robotoRegular.copyWith(),
            //       textAlign: TextAlign.start,
            //     )),
            //
            // (reviewModel.attachment != null && reviewModel.attachment!.isNotEmpty) ?
            // SizedBox(height: Dimensions.productImageSize,
            //   child: ListView.builder(
            //       itemCount: reviewModel.attachment!.length,
            //       shrinkWrap: true,
            //       scrollDirection: Axis.horizontal,
            //       itemBuilder: (context, index){
            //         return GestureDetector(
            //           onTap: () => showDialog(context: context, builder: (ctx) =>
            //               ImageDialogWidget(imageUrl:'$review/review/${reviewModel.attachment![index]}')),
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            //             child: Container(decoration: BoxDecoration(
            //               color: Theme.of(context).cardColor,
            //             ),
            //                 width: Dimensions.productImageSize,height: Dimensions.imageSize,
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            //                   child: CustomImageWidget(image: '$review/review/${reviewModel.attachment![index]}',
            //                     width: Dimensions.productImageSize,height: Dimensions.productImageSize,),
            //                 )),
            //           ),
            //         );
            //       }),):const SizedBox()
          ],
        ),
      ),
    );
  }
}
