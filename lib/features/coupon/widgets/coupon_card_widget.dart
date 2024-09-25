

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/coupon/controllers/coupon_controller.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/coupon/screens/add_new_coupon_screen.dart';
import 'package:sixvalley_vendor_app/features/coupon/widgets/coupon_details_dialog_widget.dart';

class CouponCardWidget extends StatelessWidget {
  final Coupons? coupons;
  final int? index;
  const CouponCardWidget({Key? key, this.coupons, this.index,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     bool adminCoupon = false;
    if((coupons!.addedBy =='seller' || (coupons!.addedBy =='admin' && coupons!.couponBearer =='seller' && coupons!.sellerId == Provider.of<ProfileController>(context, listen: false).userId))){
    adminCoupon = false;
    }else{
    adminCoupon = true;
    }
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Slidable(
        key: const ValueKey(0),
        enabled: adminCoupon? false : true,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dragDismissible: false,
          children:  [

            SlidableAction(
              onPressed: (value) async{
               showDialog(context: context, builder: (ctx)  => const CustomLoaderWidget());
               await Provider.of<CouponController>(context, listen: false).deleteCoupon(context, coupons!.id);
               Navigator.of(context).pop();
              },
              backgroundColor: Theme.of(context).colorScheme.error.withOpacity(.05),
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete_forever_rounded,
              label: getTranslated('delete', context),
            ),

            SlidableAction(
              onPressed: (value){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> AddNewCouponScreen(coupons: coupons)));
              },
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.05),
              foregroundColor: Theme.of(context).primaryColor,
              icon: Icons.edit,
              label: getTranslated('edit', context),
            ),
          ],
        ),

        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [

            SlidableAction(
              onPressed: (value){
                Provider.of<CouponController>(context, listen: false).deleteCoupon(context, coupons!.id);
              },
              backgroundColor: Theme.of(context).colorScheme.error.withOpacity(.05),
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete_forever_rounded,
              label: getTranslated('delete', context),
            ),

            SlidableAction(
              onPressed: (value){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> AddNewCouponScreen(coupons: coupons)));
              },
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.05),
              foregroundColor: Theme.of(context).primaryColor,
              icon: Icons.edit,
              label: getTranslated('edit', context),
            ),
          ],
        ),

        child: Consumer<CouponController>(
            builder: (context, couponProvider,_) {
              return Stack(children: [
                  GestureDetector(
                    onTap: (){
                      showDialog(context: context, builder: (_){
                        return CouponDetailsDialogWidget(coupons: coupons);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: ThemeShadow.getShadow(context),),

                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Image.asset(Images.couponIcon,width: Dimensions.iconSizeExtraLarge),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                              Expanded(flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.width/1.7,
                                        child: Text(coupons!.title!, style: robotoBold.copyWith(color: Theme.of(context).primaryColor,),
                                            overflow: TextOverflow.ellipsis, maxLines: 2),
                                      ),

                                      Text(getTranslated(coupons!.couponType, context)!, style: robotoRegular.copyWith(),),
                                      const Divider(thickness: .1,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(coupons!.code!, style: robotoBold.copyWith(),),
                                              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                                              Text(DateConverter.isoStringToDateTimeString(coupons!.createdAt!),
                                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault))
                                            ],),
                                        ],
                                      )
                                    ],
                                  ),
                                ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(right: Provider.of<LocalizationController>(context, listen: false).isLtr ? 0 : null,
                    left: Provider.of<LocalizationController>(context, listen: false).isLtr ? null : 0,
                    child: Align(
                      alignment: Provider.of<LocalizationController>(context, listen: false).isLtr? Alignment.topLeft: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                        child: FlutterSwitch(
                          activeColor: adminCoupon ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).primaryColor,
                            width: 40,height: 20,toggleSize: 18,padding: 1,
                            value: coupons!.status == 1,
                            onToggle: (value){
                              if(adminCoupon){
                                showCustomSnackBarWidget(getTranslated('coupon_tooltip', context), context);
                              }else{
                                couponProvider.updateCouponStatus(context, coupons!.id, value ? 1 : 0, index);
                              }
                            }),
                      ),
                    ),
                  )
                ],
              );
            }
        ),
      ),
    );
  }
}
