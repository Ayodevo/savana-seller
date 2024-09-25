import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';


class CustomerInfoWidget extends StatelessWidget {
  final RefundModel? refundModel;
  const CustomerInfoWidget({Key? key, this.refundModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!,
            spreadRadius: 0.5, blurRadius: 0.3)],),


      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(getTranslated('customer_information', context)!,
            style: robotoMedium.copyWith(color: ColorResources.getTextColor(context))),
        const SizedBox(height: Dimensions.paddingSizeMedium),

        Row(children: [ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CustomImageWidget(width: 50, height: 50,
              image: '${refundModel!.customer!.imageFullUrl?.path}')),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${refundModel!.customer!.fName ?? ''} ${refundModel!.customer!.lName ?? ''}',
                style: robotoMedium.copyWith(color: ColorResources.getTextColor(context),
                    fontSize: Dimensions.fontSizeDefault)),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

            InkWell(
              onTap: () =>  _launchUrl(Platform.isIOS? 'tel://${refundModel!.customer!.phone}' : 'tel:${refundModel!.customer!.phone}'),
              child: Row(
                children: [
                  SizedBox(width: 20, child: Image.asset(Images.phone),),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text('${refundModel!.customer!.phone}',
                      style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                          fontSize: Dimensions.fontSizeDefault)),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall,),

            InkWell(
              onTap: () {},
              child: Row(children: [
                  SizedBox(width: 20, child: Image.asset(Images.email),),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(refundModel!.customer!.email ?? '',
                      style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                          fontSize: Dimensions.fontSizeDefault)),
                ],
              ),
            ),

          ],
          ))
        ],
        )
      ]),);
  }
}


Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}