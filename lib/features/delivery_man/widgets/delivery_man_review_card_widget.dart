import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_review_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';


class DeliveryManReviewCardWidget extends StatelessWidget {
  final DeliveryManReview reviewModel;
  const DeliveryManReviewCardWidget({Key? key, required this.reviewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
      child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(.07), blurRadius: 1,spreadRadius: 1)]),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [


          Row(children: [
            if(reviewModel.customer != null)ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
                child: SizedBox(width: Dimensions.productImageSize, height: Dimensions.productImageSize,
                    child: CustomImageWidget(image:"${reviewModel.customer!.imageFullUrl?.path}"))),
            const SizedBox(width: Dimensions.paddingSizeSmall,),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              reviewModel.customer != null?
              Text("${reviewModel.customer!.fName!} ${reviewModel.customer!.lName!}",
                style: robotoMedium.copyWith(),
              ):Text(getTranslated('customer_not_available', context)!,
                style: robotoMedium.copyWith(),),


              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Row(children: [
                SizedBox(width: Dimensions.iconSizeSmall,
                    child: Image.asset(Images.ratting)),

                Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                    child: Text(reviewModel.rating.toString(),
                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor))),
                const Spacer(),

                Text(DateConverter.reviewDate(DateTime.parse(reviewModel.createdAt!)),
                  style: robotoRegular.copyWith(color: Theme.of(context).hintColor),)
              ]),

              Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall,
                  bottom: Dimensions.paddingSizeExtraSmall),
                  child: Row(children: [
                    Text('${getTranslated('order_id', context)}# '),
                    Text(reviewModel.orderId.toString(),style: robotoBold)]))

            ])),
          ],
          ),

          Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,top : Dimensions.paddingSizeExtraSmall),
              child: Text(reviewModel.comment!, style: robotoRegular.copyWith(), textAlign: TextAlign.start)),
        ],
        ),
      ),
    );
  }
}
