import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';

import 'package:sixvalley_vendor_app/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/screens/shop_update_screen.dart';



class ShopInformationWidget extends StatelessWidget {
  final ShopController? resProvider;
  const ShopInformationWidget({Key? key, this.resProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSize = 90;
    return resProvider!.shopModel != null?
    Stack(children: [
        Column(children: [
            Container(transform: Matrix4.translationValues(0, -15, 0),
              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.125)),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(crossAxisAlignment :CrossAxisAlignment.start, children: [
                  Column(children: [
                      Container(width: imageSize, height: imageSize,
                        decoration:  BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.075)),
                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))),

                        child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                          child: CustomImageWidget(image: '${resProvider!.shopModel?.imageFullUrl?.path}'))),
                      const SizedBox(height: Dimensions.paddingSizeSmall),


                    ],
                  ),

                  const SizedBox(width: Dimensions.paddingSizeMedium),


                  Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(padding: const EdgeInsets.fromLTRB(0,5,40,0),
                        child: Text(resProvider!.shopModel?.name ?? '',
                          style: robotoBold.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.fontSizeDefault))),

                      const SizedBox(height: Dimensions.paddingSizeMedium),
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(width: Dimensions.iconSizeDefault,
                              child:Image.asset(Images.callI)),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(child: Text(resProvider!.shopModel?.contact ?? '',
                              style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context)), maxLines: 2,
                              overflow: TextOverflow.ellipsis,softWrap: false))]),
                      const SizedBox(height: Dimensions.paddingSizeMedium),

                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(width: Dimensions.iconSizeDefault, child:Image.asset(Images.shopAddress)),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(child: Text(resProvider!.shopModel?.address ?? '',
                            style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context)), maxLines: 2,
                            overflow: TextOverflow.ellipsis,softWrap: false,),
                          ),
                        ],
                      ),
                    ],),),

                ],),
              ),
            ),



            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeDefault),
              child: Consumer<ShopController>(
                builder: (context, resProvider,_) {
                  return  Consumer<ProfileController>(
                    builder: (context, profile,_) {
                      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(child: ShopInfoMenu(count: resProvider.shopModel!.ratting!, title: 'ratting',icon: Images.rattingIcon, ratting: true,),),
                          const SizedBox(width: Dimensions.paddingSizeSmall,),
                          Expanded(child: ShopInfoMenu(count: double.parse(resProvider.shopModel!.rattingCount!.toString()), title: 'reviews', icon: Images.reviewIcon,),),
                          const SizedBox(width: Dimensions.paddingSizeSmall,),
                          Expanded(child: ShopInfoMenu(count: double.parse(profile.userInfoModel!.productCount.toString()), title: 'products',icon: Images.product,),)


                      ],);
                    }
                  );
                }
              ),
            )
          ],
        ),
      Align(alignment: Alignment.topRight,
        child: InkWell(
          onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShopUpdateScreen())),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                width: 30,height: 30, decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
            ),
                child: Image.asset(Images.editProfileIcon)),
          ),
        ),
      )
      ],
    ):const CustomLoaderWidget();
  }
}

class ShopInfoMenu extends StatelessWidget {
  final double count;
  final String title;
  final String icon;
  final bool ratting;
  const ShopInfoMenu({Key? key, required this.count, required this.title, required this.icon,  this.ratting = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Container(height: MediaQuery.of(context).size.width/4.5,
          width: MediaQuery.of(context).size.width/3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.25),width: .5)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [

            ratting?
            Text(count.toStringAsFixed(1),
              style: robotoBold.copyWith(color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeMaxLarge)):
            Text(NumberFormat.compact().format(count).padLeft(2,'0'),
              style: robotoBold.copyWith(color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeMaxLarge),),


            Text(getTranslated(title, context)!,
              style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context),
                  fontSize: Dimensions.fontSizeDefault),)

          ],),
        ),
      Positioned(
        child: Align(alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: SizedBox(width: 15,
                child: Image.asset(icon)),
          ),
        ),
      ),
      ],
    );
  }
}
