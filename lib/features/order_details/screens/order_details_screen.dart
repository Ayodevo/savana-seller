import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/order/controllers/order_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_divider_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/image_diaglog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/customer_contact_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/delivery_man_information_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/order_product_list_item_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/order_setup_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/order_top_section_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/payment_status_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/shipping_and_biilling_widget.dart';
import 'package:sixvalley_vendor_app/features/order_details/widgets/third_party_delivery_info_widget.dart';


class OrderDetailsScreen extends StatefulWidget {
  final int? orderId;
  final bool fromNotification;
  const OrderDetailsScreen({Key? key,  required this.orderId, this.fromNotification = false}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _loadData(BuildContext context) async {
    if(widget.fromNotification) {
      await Provider.of<SplashController>(Get.context!, listen: false).initConfig();
    }
    Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderDetails(widget.orderId.toString());
    Provider.of<OrderDetailsController>(Get.context!, listen: false).initOrderStatusList(
        Provider.of<SplashController>(Get.context!, listen: false).configModel!.shippingMethod == 'inhouse_shipping' ?  'inhouse_shipping' : "seller_wise");

  }


  bool _onlyDigital = true;

  @override
  void initState() {
    _loadData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(elevation: 1,
        backgroundColor: Theme.of(context).cardColor, toolbarHeight: 120,
          leadingWidth: 0, automaticallyImplyLeading: false,
          title: Consumer<OrderDetailsController>(
            builder: (context, orderDetailsController,_) {
              return OrderTopSectionWidget(orderModel: orderDetailsController.orderDetails?[0].order);
            }
          )),

      body: RefreshIndicator(
        onRefresh: () async => _loadData(context),
        child: Consumer<OrderController>(
          builder:(context, orderController, child){
            return Consumer<OrderDetailsController>(
                builder: (context, orderDetailsController, child) {
                  double itemsPrice = 0;
                  double discount = 0;
                  double? eeDiscount = 0;
                  double tax = 0;
                  double coupon = 0;
                  double shipping = 0;
                  if (orderDetailsController.orderDetails != null && orderDetailsController.orderDetails!.isNotEmpty ) {
                    coupon = orderDetailsController.orderDetails![0].order!.discountAmount!;
                    shipping = orderDetailsController.orderDetails![0].order!.shippingCost!;
                    for (var orderDetails in orderDetailsController.orderDetails!) {
                      if(orderDetails.productDetails?.productType == "physical"){
                        _onlyDigital =  false;
                      }
                      itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.qty!);
                      discount = discount + orderDetails.discount!;
                      tax = tax + orderDetails.tax!;

                    }
                    if(orderDetailsController.orderDetails![0].order!.orderType == 'POS'){
                      if(orderDetailsController.orderDetails![0].order!.extraDiscountType == 'percent'){
                        eeDiscount = itemsPrice * (orderDetailsController.orderDetails![0].order!.extraDiscount!/100);
                      }else{
                        eeDiscount = orderDetailsController.orderDetails![0].order!.extraDiscount;
                      }
                    }
                  }
                  double subTotal = itemsPrice +tax - discount;

                  double totalPrice = subTotal + shipping - coupon - eeDiscount!;

                  return orderDetailsController.orderDetails != null ? orderDetailsController.orderDetails!.isNotEmpty ?
                  CustomScrollView(slivers: [
                    SliverToBoxAdapter(child: Column(children: [

                      Container(height: 10, color: Theme.of(context).primaryColor.withOpacity(.1)),

                      Container(decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: ThemeShadow.getShadow(context)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                          if(Provider.of<SplashController>(context, listen: false).configModel?.orderVerification == 1 &&  orderDetailsController.orderDetails![0].order!.orderType != 'POS')
                            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                              child: Center(child: Text.rich(TextSpan(children: [
                                TextSpan(text: '${getTranslated('order_verification_code', context)} : ', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                                TextSpan(text: orderDetailsController.orderDetails![0].order?.verificationCode??'', style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                              ])),),
                            ),

                          orderDetailsController.orderDetails![0].order!.orderType == 'POS'? const SizedBox():
                          ShippingAndBillingWidget(orderModel: orderDetailsController.orderDetails![0].order!, onlyDigital: _onlyDigital, orderType: orderDetailsController.orderDetails![0].order!.orderType!),

                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Container(padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeSmall,
                                Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0),

                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  SizedBox(width: 15, child: Image.asset(Images.orderSummery)),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text(getTranslated('order_summery', context)!,
                                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge) ),
                                ],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault,),

                                ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: orderDetailsController.orderDetails!.length,
                                  itemBuilder: (context, index) {
                                    return OrderedProductListItemWidget(orderDetailsModel: orderDetailsController.orderDetails![index],
                                      paymentStatus: orderController.paymentStatus,orderId: widget.orderId,
                                      index: index, length: orderDetailsController.orderDetails!.length,
                                    );
                                  },
                                ),

                              ],
                              ),),

                            orderDetailsController.orderDetails![0].order!.orderNote != null?
                            Container(decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25),spreadRadius: .11,blurRadius: .11, offset: const Offset(0,2))],
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeSmall),
                                    bottomRight: Radius.circular(Dimensions.paddingSizeSmall))),
                              child: Container(decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withOpacity(.07),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeSmall),
                                    bottomRight: Radius.circular(Dimensions.paddingSizeSmall)),),
                                padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                                    Dimensions.paddingSizeDefault),

                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                  Row(children: [
                                    Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                      child: Image.asset(Images.orderNote,color: ColorResources.getTextColor(context), width: Dimensions.iconSizeSmall ),),
                                    Text(getTranslated('order_note', context)!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                                      color: ColorResources.titleColor(context),)),
                                  ],
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  Text(orderDetailsController.orderDetails![0].order!.orderNote != null? orderDetailsController.orderDetails![0].order!.orderNote ?? '': "",
                                      style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),
                                ],),
                              ),
                            ):const SizedBox(),


                            Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeDefault),
                              child: Column(children: [

                                // Total
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(getTranslated('sub_total', context)!,
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),

                                  Text(PriceConverter.convertPrice(context, itemsPrice),
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),]),
                                const SizedBox(height: Dimensions.paddingSizeSmall,),


                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(getTranslated('tax', context)!,
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),

                                  Text('+ ${PriceConverter.convertPrice(context, tax)}',
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),]),
                                const SizedBox(height: Dimensions.paddingSizeSmall,),


                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(getTranslated('discount', context)!,
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),


                                  Text('- ${PriceConverter.convertPrice(context, discount)}',
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),]),
                                const SizedBox(height: Dimensions.paddingSizeSmall,),


                                orderDetailsController.orderDetails![0].order!.orderType == "POS"?
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(getTranslated('extra_discount', context)!,
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),
                                  Text('- ${PriceConverter.convertPrice(context, eeDiscount)}',
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),
                                ]):const SizedBox(),
                                SizedBox(height:  orderDetailsController.orderDetails![0].order!.orderType == "POS"? Dimensions.paddingSizeSmall: 0),


                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(getTranslated('coupon_discount', context)!,
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),
                                  Text('- ${PriceConverter.convertPrice(context, coupon)}',
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),]),
                                const SizedBox(height: Dimensions.paddingSizeSmall,),


                                if(!_onlyDigital)Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(getTranslated('shipping_fee', context)!,
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),
                                  Text('+ ${PriceConverter.convertPrice(context, shipping)}',
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.titleColor(context))),]),

                                const Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                    child: CustomDividerWidget()),


                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(getTranslated('total_amount', context)!,
                                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                  Text(PriceConverter.convertPrice(context, totalPrice),
                                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                                        color: Theme.of(context).primaryColor),),]),
                              ],),),
                          ]),


                          PaymentStatusWidget(order: orderController, orderModel: orderDetailsController.orderDetails![0].order!),


                          CustomerContactWidget(orderModel: orderDetailsController.orderDetails![0].order),

                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                          orderDetailsController.orderDetails![0].order!.deliveryMan != null?
                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: DeliveryManContactInformationWidget(orderModel: orderDetailsController.orderDetails![0].order, orderType: orderDetailsController.orderDetails![0].order!.orderType, onlyDigital: _onlyDigital),
                          ):const SizedBox(),

                          orderDetailsController.orderDetails![0].order!.thirdPartyServiceName != null?
                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: ThirdPartyDeliveryInfoWidget(orderModel: orderDetailsController.orderDetails![0].order),
                          ):const SizedBox.shrink(),

                          if(orderDetailsController.orderDetails != null && orderDetailsController.orderDetails![0].verificationImages != null && orderDetailsController.orderDetails![0].verificationImages!.isNotEmpty)
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,  Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall),
                                child: Text('${getTranslated('completed_service_picture', context)}',
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),),),

                              SizedBox(height: 120,
                                child: ListView.builder(
                                    itemCount: orderDetailsController.orderDetails![0].verificationImages?.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index){

                                      return InkWell(onTap: () => showDialog(context: context, builder: (_)=> ImageDialogWidget(imageUrl: '${AppConstants.baseUrl}/storage/app/public/delivery-man/verification-image/${orderDetailsController.orderDetails![0].verificationImages?[index].image}')),
                                        child: Padding(padding:  EdgeInsets.only(left: Dimensions.paddingSizeSmall,
                                            right: orderDetailsController.orderDetails![0].verificationImages!.length == index+1? Dimensions.paddingSizeSmall : 0),
                                          child: SizedBox(width: 200,
                                            child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                              child: Container(decoration: BoxDecoration(
                                                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.25), width: .25),
                                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                                  child: CustomImageWidget(image: '${orderDetailsController.orderDetails![0].verificationImages?[index].imageFullUrl?.path}')),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                            ),
                        ])),

                      const SizedBox(height: Dimensions.paddingSizeSmall),
                    ],
                    ),)
                  ],
                  ):
                  const NoDataScreen() :
                  const Center(child: CircularProgressIndicator());
                }
            );
          }
        ),
      ),

      bottomNavigationBar: Consumer<OrderDetailsController>(
        builder: (context, orderDetailsController, _) {
          return (orderDetailsController.orderDetails != null && orderDetailsController.orderDetails!.isNotEmpty && orderDetailsController.orderDetails![0].order!.orderType =='POS')? const SizedBox.shrink(): Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
              boxShadow: ThemeShadow.getShadow(context)),

              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
              child: CustomButtonWidget(borderRadius: Dimensions.paddingSizeExtraSmall,
                btnTxt: getTranslated('order_setup', context),
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    OrderSetupWidget(orderModel: orderDetailsController.orderDetails![0].order,onlyDigital: _onlyDigital)));
                },
            ));
        }
      ),
    );
  }
}
