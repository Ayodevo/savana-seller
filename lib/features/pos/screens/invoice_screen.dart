import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/edt_product_model.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/pos/widgets/invoice_element_widget.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_divider_widget.dart';
import 'package:sixvalley_vendor_app/features/pos/screens/invoice_print_screen.dart';


class InVoiceScreen extends StatefulWidget {
  final int? orderId;
  const InVoiceScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<InVoiceScreen> createState() => _InVoiceScreenState();
}

class _InVoiceScreenState extends State<InVoiceScreen> {
  Future<void> _loadData() async {
    await Provider.of<CartController>(Get.context!, listen: false).getInvoiceData(widget.orderId);
    Provider.of<ShopController>(Get.context!, listen: false).getShopInfo();
  }
  double totalPayableAmount = 0;
  double couponDiscount = 0;
  double extraDiscountAmount = 0;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('invoice', context),),

      body: Consumer<ShopController>(
        builder: (context, shopController, _) {

          return SingleChildScrollView(
            child: Consumer<CartController>(
              builder: (context, cartController, _) {

                // if(widget.orderDetailsModel!.productDetails != null && widget.orderDetailsModel!.variant != null && widget.orderDetailsModel!.variant!.isNotEmpty && widget.orderDetailsModel!.productDetails?.productType == 'digital') {
                //   for(DigitalVariation dv in widget.orderDetailsModel!.productDetails!.digitalVariation!) {
                //     if(dv.variantKey == widget.orderDetailsModel!.variant){
                //       digitalVariation = dv;
                //     }
                //   }
                // }

                DigitalVariation? digitalVariation;

                double? includeTax = 0;

                if(cartController.invoice != null &&  cartController.invoice!.orderAmount != null) {
                  double orderAmount = 0;
                  for (int i= 0; i < cartController.invoice!.details!.length; i++) {
                    digitalVariation = null;
                    if(cartController.invoice!.details![i].taxModel == 'include') {
                      print("======Include========>>");
                      if(cartController.invoice!.details![i].productDetails?.productType == 'digital') {
                        // Include  Digital
                        if(cartController.invoice!.details![i].variant != null && cartController.invoice!.details![i].variant!.isNotEmpty && cartController.invoice!.details![i].productDetails?.productType == 'digital') {
                          for(DigitalVariation dv in cartController.invoice!.details![i].productDetails!.digitalVariation ?? []) {
                            if(dv.variantKey == cartController.invoice!.details![i].variant){
                              digitalVariation = dv;
                              orderAmount = orderAmount + ((digitalVariation.price! * cartController.invoice!.details![i].qty!) - cartController.invoice!.details![i].tax!);
                              includeTax = includeTax! + cartController.invoice!.details![i].tax!;
                            }
                          }
                        } else {
                          orderAmount = orderAmount + ((cartController.invoice!.details![i].productDetails!.unitPrice! * cartController.invoice!.details![i].qty!)) - cartController.invoice!.details![i].tax!;
                          includeTax = includeTax! + cartController.invoice!.details![i].tax!;
                        }

                      }else {
                        // Include Physical
                        orderAmount = orderAmount + ((cartController.invoice!.details![i].price! * cartController.invoice!.details![i].qty!));
                        includeTax = includeTax! + cartController.invoice!.details![i].tax!;
                      }
                    } else {
                      //======Exclude========//
                      print("======Exclude========>>");

                      if(cartController.invoice!.details![i].productDetails?.productType == 'physical') {
                        orderAmount = orderAmount + ((cartController.invoice!.details![i].price! * cartController.invoice!.details![i].qty!));
                      } else {
                        orderAmount = orderAmount + ((cartController.invoice!.details![i].price! * cartController.invoice!.details![i].qty!));
                      }

                    }
                  }


                  extraDiscountAmount = double.parse(PriceConverter.discountCalculationWithOutSymbol(context, orderAmount, cartController.invoice!.extraDiscount!, cartController.invoice!.extraDiscountType));

                  print("===111===abc===>>${orderAmount - cartController.discountOnProduct }");

                  print("===000==TT=>>${cartController.totalTaxAmount}");


                  totalPayableAmount = orderAmount +
                       cartController.totalTaxAmount -
                      cartController.discountOnProduct
                      - extraDiscountAmount - cartController.invoice!.discountAmount! + includeTax!;
                }
                return Column(children: [

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      const Expanded(flex: 3,child: SizedBox.shrink()),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Container(width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            color: Theme.of(context).primaryColor,

                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => InVoicePrintScreen(shopModel: shopController.shopModel,
                                    invoice : cartController.invoice,
                                    orderId: widget.orderId,
                                    discountProduct: cartController.discountOnProduct,
                                    total: totalPayableAmount,
                                  )));

                            },
                            child: Center(child: Row(
                              children: [
                                Icon(Icons.event_note_outlined, color: Theme.of(context).cardColor, size: 15,),
                                const SizedBox(width: Dimensions.paddingSizeSmall),
                                Text(getTranslated('print', context)!, style: robotoRegular.copyWith(color: Theme.of(context).cardColor),),
                              ],
                            )),
                          ),),
                      ),

                    ],),
                  ),

                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                    Text(shopController.shopModel?.name??'',
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLargeTwenty),),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    Text('${getTranslated('phone', context)} : ${shopController.shopModel?.contact??''}',
                      style: robotoRegular.copyWith(),),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  ],),


                  Consumer<CartController>(
                    builder: (context, cartController, _) {
                      return cartController.invoice != null && cartController.invoice!.details != null &&  cartController.invoice!.details!.isNotEmpty ?
                        Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          CustomDividerWidget(color: Theme.of(context).hintColor),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${getTranslated('invoice', context)!.toUpperCase()} # ${widget.orderId}',
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                            Text(getTranslated('payment_method', context)!,
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          ],),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(DateConverter.dateTimeStringToMonthAndTime(cartController.invoice!.createdAt!),
                                style: robotoRegular),

                              Text('${getTranslated('paid_by', context)} ${getTranslated(cartController.invoice!.paymentMethod??'cash', context)}',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                            )),
                          ],),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          CustomDividerWidget(color: Theme.of(context).hintColor),
                          const SizedBox(height: Dimensions.paddingSizeLarge),


                          InvoiceElementViewWidget(serial: getTranslated('sl', context),
                              title: getTranslated('product_info', context),
                              quantity: getTranslated('qty', context),
                              price: getTranslated('price', context), isBold: true),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          ListView.builder(
                            itemBuilder: (con, index){

                              return SizedBox(height: 55,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    Expanded(flex: 5,
                                      child:  Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                                        Text((index+1).toString()),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                        cartController.invoice!.details![index].variant != null?
                                        Expanded(
                                            child: Text('${cartController.invoice!.details![index].productDetails!.name} (${cartController.invoice!.details![index].variant??''})',
                                              maxLines: 2,overflow: TextOverflow.ellipsis,)):
                                        Expanded(
                                            child: Text('${cartController.invoice!.details![index].productDetails!.name}',
                                              maxLines: 2,overflow: TextOverflow.ellipsis,))

                                      ],)
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                    Expanded(flex: 3,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(cartController.invoice!.details![index].qty.toString()),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                        Text(PriceConverter.convertPrice(context, cartController.invoice!.details![index].price)),
                                      ],),
                                    ),
                                  ],)
                                ),
                              );
                            },
                            itemCount: cartController.invoice!.details!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            child: CustomDividerWidget(color: Theme.of(context).hintColor),
                          ),


                          Column(children: [

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text(getTranslated('subtotal', context)!,style: robotoRegular.copyWith(),),
                              Text(PriceConverter.convertPrice(context, cartController.invoice!.orderAmount)),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text(getTranslated('product_discount', context)!,style: robotoRegular.copyWith(),),
                              Text('- ${PriceConverter.convertPrice(context, cartController.discountOnProduct)}'),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text(getTranslated('coupon_discount', context)!,style: robotoRegular.copyWith(),),
                              Text('- ${PriceConverter.convertPrice(context, cartController.invoice!.discountAmount)}'),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text(getTranslated('extra_discount', context)!,style: robotoRegular.copyWith(),),
                              Text(' - '
                                  '${extraDiscountAmount}'
                                  // '${PriceConverter.discountCalculationWithOutSymbol(context, cartController.invoice!.orderAmount!, cartController.invoice!.extraDiscount!, cartController.invoice!.extraDiscountType)}'
                              ),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text(getTranslated('tax', context)!,style: robotoRegular.copyWith(),),
                              Text(' + ${PriceConverter.convertPrice(context, cartController.totalTaxAmount)}'),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                          ],),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                            child: CustomDividerWidget(color: Theme.of(context).hintColor),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Text(getTranslated('total', context)!,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
                            Text(PriceConverter.convertPrice(context, totalPayableAmount),
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          ],),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Text('"""${getTranslated('thank_you', context)}"""', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                            child: CustomDividerWidget(color: Theme.of(context).hintColor),
                          ),

                        ],),
                      ):const SizedBox();
                    }
                  ),
                ],);
              }
            ),
          );
        }
      ),
    );
  }
}
