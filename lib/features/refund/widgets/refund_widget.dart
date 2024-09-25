import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/refund/widgets/refund_attachment_list_widget.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/screens/refund_details_screen.dart';

class RefundWidget extends StatelessWidget {
  final RefundModel? refundModel;
  final bool isDetails;
  const RefundWidget({Key? key, required this.refundModel, this.isDetails = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDetails? null:() => Navigator.push(context, MaterialPageRoute(builder: (_) => RefundDetailsScreen(
          refundModel: refundModel, orderDetailsId: refundModel!.orderDetailsId,
          variation: refundModel!.orderDetails!.variant))),
      child: Padding(padding: isDetails? EdgeInsets.zero : const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeMedium),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          if(!isDetails)
            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeMedium),
                child: Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(refundModel!.createdAt!)),
                    style: robotoRegular.copyWith(color: Theme.of(context).hintColor))),


         Container(
           decoration: BoxDecoration(
             color: Theme.of(context).cardColor,
             borderRadius: isDetails? BorderRadius.zero : BorderRadius.circular(Dimensions.paddingSizeSmall),
             boxShadow: [BoxShadow(color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).primaryColor.withOpacity(0):
             Theme.of(context).hintColor.withOpacity(.25), blurRadius: 2, spreadRadius: 2, offset: const Offset(1,2))]),
           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
               if(!isDetails)
               Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
                 child: Row(children: [
                   Text('${getTranslated('order_no', context)}# ', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),

                   Text(' ${refundModel!.orderId.toString()}', style: robotoMedium.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.fontSizeLarge),),
                 ],
                 ),
               ),

               Padding(padding:  EdgeInsets.only(top : isDetails? 10 : 0),
                 child: Container(margin: const EdgeInsets.only(left: 15, right: 15),
                   decoration: BoxDecoration(
                     border: isDetails? Border.all(color: Theme.of(context).primaryColor.withOpacity(.125)): Border.all(width: 0,color: Colors.transparent),
                       borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeOrder, vertical: Dimensions.paddingSizeSmall),

                   child: refundModel != null ?
                   Row(children: [
                     refundModel!.product != null?
                     Container(width: Dimensions.stockOutImageSize, height: Dimensions.stockOutImageSize,
                       decoration: const BoxDecoration(color: Colors.white,
                           borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall))),
                       child: ClipRRect(
                           borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall),),
                           child: CustomImageWidget(image: '${refundModel!.product!.thumbnailFullUrl?.path}',)

                       ) ,
                     ):const SizedBox(),
                     const SizedBox(width: Dimensions.paddingSizeSmall),

                     Expanded(
                       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                         const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                         refundModel!.product != null?
                         Text(refundModel!.product!.name.toString(),
                             maxLines: 1, overflow: TextOverflow.ellipsis,
                             style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)):const SizedBox(),
                         refundModel!.product != null?
                         const SizedBox(height: Dimensions.paddingSizeExtraSmall,):const SizedBox(),

                         refundModel!.product != null?
                         Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                           child: Text(PriceConverter.convertPrice(context, refundModel!.product?.unitPrice),
                               style: robotoMedium.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme? Colors.white :
                               Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                         ) : const SizedBox(),

                         Row( mainAxisAlignment: MainAxisAlignment.start, children: [
                           SizedBox(height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall,

                             child: Image.asset(Images.orderPendingIcon),),
                           Padding(padding: const EdgeInsets.all(8.0),
                             child: Text(getTranslated(refundModel!.status, context)!,
                                 style: robotoRegular.copyWith(color: refundModel!.status?.toLowerCase() == 'pending'?
                                 ColorResources.getPrimary(context): (refundModel!.status?.toLowerCase() == 'approved' || refundModel!.status?.toLowerCase() == 'refunded')?
                                 ColorResources.getGreen(context): ColorResources.getRed(context))),
                           ),
                         ],
                         ),
                         const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                         if(isDetails)
                           Row(children: [
                             SizedBox(height: Dimensions.iconSizeDefault, width: Dimensions.iconSizeDefault,
                               child: Image.asset(refundModel!.paymentInfo == 'cash_on_delivery'? Images.cashPaymentIcon:
                               refundModel!.paymentInfo == 'pay_by_wallet'? Images.payByWalletIcon : Images.digitalPaymentIcon),),
                             const SizedBox(width: Dimensions.paddingSizeSmall),
                             Text(refundModel!.order != null? getTranslated(refundModel!.order!.paymentMethod, context)??'':'',
                                 style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                           ],),
                       ],),),
                   ],
                   ):const SizedBox(),
                 ),
               ),
             ],
             ),

             if(isDetails)
             Divider(color: Theme.of(context).primaryColor.withOpacity(.5), thickness: .15),
             isDetails?
             Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.fontSizeDefault),
               child: Column(mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,children: [
                   Row(children: [
                     SizedBox(width: 20, child: Image.asset(Images.reason)),
                     const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                     Expanded(child: Text('${getTranslated('refund_reason', context)}: ',
                         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
                     ),
                   ],
                   ),
                   if(isDetails)
                     Divider(color: Theme.of(context).primaryColor.withOpacity(.5), thickness: .15,),


                   Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                     child: Text( refundModel!.refundReason!,overflow: TextOverflow.ellipsis,
                         maxLines: isDetails? 250 : 1,
                         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                   ),

                   refundModel?.refundReason != null ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

                 ],),
             ):
             Column(
               children: [
                 Divider(color: Theme.of(context).primaryColor.withOpacity(.5), thickness: .15,),
                 Padding(
                   padding: const EdgeInsets.fromLTRB(Dimensions.fontSizeDefault,0, Dimensions.fontSizeDefault, Dimensions.fontSizeDefault),
                   child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                     Text('${getTranslated('reason', context)}: ',
                         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),

                     Expanded(
                       child: Text( refundModel!.refundReason!,overflow: TextOverflow.ellipsis,
                           maxLines: isDetails? 50 : 1,
                           style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                     ),
                   ],),
                 ),
               ],
             ),

             refundModel!.images != null && refundModel!.images!.isNotEmpty && isDetails ?
             RefundAttachmentListWidget(refundModel: refundModel) : const SizedBox(),
           ],
           ))
          ],
        ),
      ),
    );
  }
}
