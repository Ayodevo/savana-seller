import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_field_with_title_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';

class ExtraDiscountAndCouponDialogWidget extends StatelessWidget {
  const ExtraDiscountAndCouponDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog( surfaceTintColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: Consumer<CartController>(
        builder: (context, cartController, _) {
          return Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:CrossAxisAlignment.start,children: [

              Consumer<CartController>(
              builder: (context,cartController,_) {
                return Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('discount_type', context)!,
                      style: robotoRegular.copyWith(),),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                      ),
                      child: DropdownButton<String>(
                        value: cartController.discountTypeIndex == 0 ?'amount'  :  'percent',
                        items: <String>['amount','percent'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(getTranslated(value, context)!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          cartController.setSelectedDiscountType(value);
                          cartController.setDiscountTypeIndex(value == 'amount' ? 0 : 1, true);

                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                  ]),
                );
              }
            ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              CustomFieldWithTitleWidget(
              customTextField: CustomTextFieldWidget(hintText: getTranslated('discount_hint', context),
                controller: cartController.extraDiscountController,
                textInputType: TextInputType.number,
                border: true,
                maxSize: cartController.discountTypeIndex == 1? 2 : null,

              ),
              title: cartController.discountTypeIndex == 1?
              getTranslated('discount_percentage', context):
                getTranslated('discount_amount', context),
              requiredField: true,
            ),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(children: [
                  Expanded(child: CustomButtonWidget(btnTxt: getTranslated('cancel', context),
                      backgroundColor: Theme.of(context).hintColor,
                      onTap: ()=>Navigator.pop(context))),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(child: CustomButtonWidget(btnTxt: getTranslated('apply', context),
                  onTap: (){
                    cartController.applyCouponCodeAndExtraDiscount(context);
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
