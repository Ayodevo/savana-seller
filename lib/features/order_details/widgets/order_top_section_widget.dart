import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';


class OrderTopSectionWidget extends StatelessWidget {
  final Order? orderModel;

  const OrderTopSectionWidget({Key? key, this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return orderModel != null?
    Stack(children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeMedium),
        child: Column(children: [

          Text('${getTranslated('order_no', context)}#${orderModel!.id}',
            style: titilliumSemiBold.copyWith(color: ColorResources.titleColor(context),
                fontSize: Dimensions.fontSizeLarge),),

          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${getTranslated('your_order_is', context)}',
                  style: titilliumSemiBold.copyWith(color: ColorResources.titleColor(context),
                      fontSize: Dimensions.fontSizeLarge)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Text(getTranslated('${orderModel!.orderStatus}', context)!,
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.mainCardThreeColor(context))),
                ),
              ],
            ),
          ),

          Padding(padding: const EdgeInsets.only(left: 2,top: Dimensions.paddingSizeExtraSmall),
            child: Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(orderModel!.createdAt!)),
                style: robotoRegular.copyWith(color: ColorResources.getHint(context),
                    fontSize: Dimensions.fontSizeSmall)),
          ),
        ]),
      ),
      InkWell(onTap: ()=> Navigator.of(context).pop(),
        child: const Padding(padding: EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
          child: Icon(CupertinoIcons.back),
        ),
      )
    ],
    ): const SizedBox();
  }
}
