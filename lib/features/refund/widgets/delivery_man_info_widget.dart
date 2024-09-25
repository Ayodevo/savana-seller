import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/refund/controllers/refund_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryManInfoWidget extends StatelessWidget {
  final RefundController? refundReq;
  const DeliveryManInfoWidget({Key? key, this.refundReq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(color: Theme.of(context).cardColor,
        boxShadow: ThemeShadow.getShadow(context),
       ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(getTranslated('deliveryman_contact_details', context)!,
            style: titilliumBold.copyWith(color: ColorResources.getTextColor(context))),
        const SizedBox(height: Dimensions.paddingSizeMedium),

        Row(children: [ClipRRect(borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
              errorWidget: (ctx, url, err) => Image.asset(Images.placeholderImage, height: 50,width: 50, fit: BoxFit.cover),
              placeholder: (ctx, url) => Image.asset(Images.placeholderImage,height: 50,width: 50, fit: BoxFit.cover),
              imageUrl: '${Provider.of<SplashController>(context, listen: false).
              baseUrls!.deliveryManImageUrl}/${refundReq!.refundDetailsModel!.deliverymanDetails!.image}',
              height: 50,width: 50, fit: BoxFit.cover),),
          const SizedBox(width: Dimensions.paddingSizeSmall),



          Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text('${refundReq!.refundDetailsModel!.deliverymanDetails!.fName ?? ''} '
                '${refundReq!.refundDetailsModel!.deliverymanDetails!.lName ?? ''}',
                style: robotoMedium.copyWith(color: ColorResources.getTextColor(context),
                    fontSize: Dimensions.fontSizeDefault)),
            InkWell(
              onTap: () => _launchUrl(Platform.isIOS? 'tel://${refundReq!.refundDetailsModel!.deliverymanDetails!.phone!}' : 'tel:${refundReq!.refundDetailsModel!.deliverymanDetails!.phone!}'),
              child: Row(
                children: [
                  SizedBox(width: 20, child: Image.asset(Images.phone),),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text('${refundReq!.refundDetailsModel!.deliverymanDetails!.phone}',
                      style: robotoRegular.copyWith(color: ColorResources.getHintColor(context),
                          fontSize: Dimensions.fontSizeDefault)),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

            InkWell(
              onTap: () async {
                final Uri email =  Uri(
                  scheme: 'mailto',
                  path: refundReq!.refundDetailsModel!.deliverymanDetails!.email ?? '',
                );

                await launchUrl(email, mode: LaunchMode.externalApplication);
                // Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context ,1);
                // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>
                //     ChatScreen(userId: refundReq!.refundDetailsModel!.deliverymanDetails?.id,
                //         name: '${refundReq!.refundDetailsModel!.deliverymanDetails?.fName} '
                //             '${refundReq!.refundDetailsModel!.deliverymanDetails?.lName}')));
              },
              child: Row(
                children: [
                  SizedBox(width: 20, child: Image.asset(Images.email),),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(refundReq!.refundDetailsModel!.deliverymanDetails!.email ?? '',
                      style: robotoRegular.copyWith(color: ColorResources.getHintColor(context), fontSize: Dimensions.fontSizeDefault)),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),



          ],
          )),

          // InkWell(onTap: ()=> _launchUrl(Platform.isIOS? 'tel://${refundReq!.refundDetailsModel!.deliverymanDetails!.phone!}' : 'tel:${refundReq!.refundDetailsModel!.deliverymanDetails!.phone!}'),
          //   child: Container(width: 50,height: 50,
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).hintColor.withOpacity(.125),
          //       borderRadius: BorderRadius.circular(50)
          //     ),
          //     child: Center(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          //         child: Image.asset(Images.phone, color: Theme.of(context).primaryColor,),
          //       ),
          //     ),),
          // ),
          // const SizedBox(width: Dimensions.paddingSizeSmall,),
          //
          // InkWell(onTap: (){
          //   Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context ,1);
          //   Navigator.of(context).push(MaterialPageRoute(builder: (_)=>
          //       ChatScreen(userId: refundReq!.refundDetailsModel!.deliverymanDetails?.id,
          //           name: '${refundReq!.refundDetailsModel!.deliverymanDetails?.fName} '
          //               '${refundReq!.refundDetailsModel!.deliverymanDetails?.lName}')));
          // },
          //   child: Container(width: 50,height: 50,
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).hintColor.withOpacity(.125),
          //       borderRadius: BorderRadius.circular(50)
          //     ),
          //     child: Center(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          //         child: Image.asset(Images.email, color: Theme.of(context).primaryColor,),
          //       ),
          //     ),),
          // ),
        ],
        )
      ]),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}