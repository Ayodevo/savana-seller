import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_field_with_title_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';

class CouponDialogWidget extends StatelessWidget {
  const CouponDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog( surfaceTintColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: Consumer<CartController>(
          builder: (context, cartController, _) {
            return Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              height: 210, child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [

                CustomFieldWithTitleWidget(
                  customTextField: CustomTextFieldWidget(
                    hintText: getTranslated('coupon_code_hint', context),
                    controller:cartController.couponController,
                    border: true,
                  ),
                  title: getTranslated('coupon_code', context),

                  requiredField: true,
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(children: [
                    Expanded(child: CustomButtonWidget(btnTxt: getTranslated('cancel', context),
                        backgroundColor: Theme.of(context).hintColor,
                        onTap: ()=> Navigator.pop(context))),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(child: CustomButtonWidget(btnTxt: getTranslated('apply', context),
                      onTap: (){
                      if(cartController.couponController.text.trim().isNotEmpty){
                        if (kDebugMode) {
                          print('${cartController.couponController.text.trim()}/'
                            '${cartController.customerId}/'
                            '${cartController.amount}');
                        }
                        cartController.getCouponDiscount(context,
                            cartController.couponController.text.trim(),
                            cartController.customerId,
                            cartController.amount);
                      }
                      Navigator.pop(context);
                    },)),
                  ],),
                )
              ],),);
          }
      ),
    );
  }
}
