import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/order/controllers/order_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/features/addProduct/screens/add_product_screen.dart';

class PaymentStatusWidget extends StatefulWidget {
  final Order? orderModel;
  final OrderController? order;
  const PaymentStatusWidget({Key? key, this.orderModel, this.order}) : super(key: key);

  @override
  State<PaymentStatusWidget> createState() => _PaymentStatusWidgetState();
}

class _PaymentStatusWidgetState extends State<PaymentStatusWidget> {
  bool showWholeInfo = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(children: [



        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          Text('${getTranslated('payment_status', context)}'),

          Text(getTranslated(widget.order!.paymentStatus, context)!,
            style: robotoRegular.copyWith(color: widget.order!.paymentStatus =='paid' ? Colors.green: Theme.of(context).colorScheme.error))],),

        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [


          InkWell(onTap: (){
            setState(() {
              showWholeInfo = !showWholeInfo;
            });
          },
            child: Row(children: [
                Text('${getTranslated('payment_method', context)}'),
                if(widget.orderModel?.offlinePayments != null)
                   Icon(showWholeInfo?  Icons.keyboard_arrow_up: Icons.keyboard_arrow_down),
              ],
            ),
          ),
          if(widget.orderModel!.paymentMethod != null)
          Text(widget.orderModel!.paymentMethod!.replaceAll('_', ' ').capitalize(),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
        ],
        ),
      ),

        if(widget.orderModel?.offlinePayments != null && showWholeInfo)
          Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Divider(color: Theme.of(context).primaryColor.withOpacity(.5),),
            ),
            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Text('${getTranslated('my_payment_info', context)}',style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),),
                Text('${getTranslated('bank_info', context)}', style: robotoBold.copyWith(color: Theme.of(context).primaryColor),),
              ],),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.orderModel?.offlinePayments?.infoKey?.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  String key = widget.orderModel?.offlinePayments?.infoKey?[index];
                  String fittedKey = key.replaceAll('_', ' ');
                  return PaymentItemCard(leftValue: fittedKey.capitalize(),rightValue: '${widget.orderModel?.offlinePayments?.infoValue?[index]}');
                }),


            PaymentItemCard(leftValue: '${getTranslated('note', context)}',rightValue: ''),

            Text(widget.orderModel?.paymentNote ??'', style: robotoRegular.copyWith(color: Theme.of(context).hintColor),)


          ]),



    ],),);
  }
}

class PaymentItemCard extends StatelessWidget {
  final String leftValue;
  final String rightValue;
  const PaymentItemCard({Key? key, required this.leftValue, required this.rightValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$leftValue  : ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
        Expanded(child: Text(rightValue,style: robotoMedium.copyWith(color: ColorResources.titleColor(context), fontSize: Dimensions.fontSizeDefault),)),
      ],
      ),
    );
  }
}

