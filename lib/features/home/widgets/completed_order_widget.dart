import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/order/controllers/order_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/features/home/widgets/order_type_button_widget.dart';

class CompletedOrderWidget extends StatelessWidget {
  final Function? callback;
  const CompletedOrderWidget({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, order, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(color: ColorResources.getPrimary(context).withOpacity(.05),
                  spreadRadius: -3, blurRadius: 12, offset: Offset.fromDirection(0,6))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Padding(
              padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall,Dimensions.paddingSizeDefault,0 ),
              child: Text(getTranslated('completed_orders', context)!,
                style: robotoBold.copyWith(color: Theme.of(context).primaryColor),),
            ),
            order.orderModel != null ?
            Consumer<BankInfoController>(
              builder: (context, bankInfoController, child) => SizedBox(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    OrderTypeButtonWidget(
                      color: ColorResources.mainCardThreeColor(context),
                      icon: Images.delivered,
                      text: getTranslated('delivered', context), index: 3,
                      numberOfOrder: bankInfoController.businessAnalyticsFilterData?.delivered, callback: callback,
                    ),

                    OrderTypeButtonWidget(
                      color: ColorResources.mainCardFourColor(context),
                      icon: Images.cancelled,
                      text: getTranslated('cancelled', context), index: 6,
                      numberOfOrder: bankInfoController.businessAnalyticsFilterData?.canceled, callback: callback,
                    ),

                    OrderTypeButtonWidget(
                      color: ColorResources.getTextColor(context),
                      icon: Images.returned,
                      text: getTranslated('return', context), index: 4,
                      numberOfOrder: bankInfoController.businessAnalyticsFilterData?.returned, callback: callback,
                    ),

                    OrderTypeButtonWidget(
                      showBorder: false,
                      color: ColorResources.mainCardFourColor(context),
                      icon: Images.failed,
                      text: getTranslated('failed', context), index: 5,
                      numberOfOrder: bankInfoController.businessAnalyticsFilterData?.failed, callback: callback,
                    ),
                  ],
                ),
              ),
            ) : SizedBox(height: 150,
                child: Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)))),

            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],),);
      }
    );
  }
}
