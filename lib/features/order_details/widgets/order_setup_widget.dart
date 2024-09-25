import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_drop_down_item_widget.dart';
import 'package:sixvalley_vendor_app/features/order/widgets/delivery_man_assign_widget.dart';



class OrderSetupWidget extends StatefulWidget {

  final Order? orderModel;
  final bool onlyDigital;
  const OrderSetupWidget({Key? key, this.orderModel, this.onlyDigital = false}) : super(key: key);

  @override
  State<OrderSetupWidget> createState() => _OrderSetupWidgetState();
}

class _OrderSetupWidgetState extends State<OrderSetupWidget> {

  @override
  void initState() {
    Provider.of<DeliveryManController>(Get.context!, listen: false).getDeliveryManList(widget.orderModel);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    bool inHouseShipping = false;
    String? shipping = Provider.of<SplashController>(context, listen: false).configModel!.shippingMethod;
    if(shipping == 'inhouse_shipping' && (widget.orderModel!.orderStatus == 'out_for_delivery' || widget.orderModel!.orderStatus == 'delivered' || widget.orderModel!.orderStatus == 'returned' || widget.orderModel!.orderStatus == 'failed' || widget.orderModel!.orderStatus == 'canceled')){      inHouseShipping = true;
    }else{
      inHouseShipping = false;
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBarWidget(title: getTranslated('order_setup', context),isBackButtonExist: true),
      body: SingleChildScrollView(
        child: Column(children: [
          Consumer<OrderDetailsController>(
            builder: (context, orderDetailsController, _) {
              bool paymentActive = orderDetailsController.orderDetails != null ? widget.orderModel!.paymentMethod == 'cash_on_delivery' ? (widget.orderModel!.paymentMethod == 'cash_on_delivery' && orderDetailsController.orderDetails![0].deliveryStatus == 'delivered' &&  orderDetailsController.orderDetails![0].paymentStatus != 'paid') : true : false;
              return Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: Dimensions.paddingSizeMedium),
                  inHouseShipping?
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
                    child: Container(width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: .5,color: Theme.of(context).hintColor.withOpacity(.125)),
                            color: Theme.of(context).hintColor.withOpacity(.12),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSize),
                          child: Text(getTranslated(widget.orderModel!.orderStatus, context)!),
                        )),
                  ):
                  CustomDropDownItemWidget(
                    title: 'order_status',
                    widget: DropdownButtonFormField<String>(
                      value: widget.orderModel!.orderStatus,
                      isExpanded: true,
                      decoration: const InputDecoration(border: InputBorder.none),
                      iconSize: 24, elevation: 16, style: robotoRegular,
                      onChanged: (value){
                        orderDetailsController.updateOrderStatus(widget.orderModel!.id, value);
                      },
                      items: orderDetailsController.orderStatusList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getTranslated(value, context)!,
                              style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                        );
                      }).toList(),
                    ),
                  ),

                  CustomDropDownItemWidget(
                    title: 'payment_status',
                    widget: DropdownButtonFormField<String>(
                      value: widget.orderModel!.paymentStatus,
                      isExpanded: true,
                      decoration: const InputDecoration(border: InputBorder.none),
                      iconSize: 24, elevation: 16, style: robotoRegular,
                      onChanged: !paymentActive ? null : (value) {
                        orderDetailsController.setPaymentMethodIndex(value == 'paid' ? 0 : 1);
                        orderDetailsController.updatePaymentStatus(orderId: widget.orderModel!.id, status: value);
                      },
                      items: <String>['paid', 'unpaid'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getTranslated(value, context)!,
                              style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                        );
                      }).toList(),
                    ),
                  ),

                   !widget.onlyDigital?
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                     child: DeliveryManAssignWidget(orderType: widget.orderModel?.orderType, orderModel: widget.orderModel,
                         orderId: widget.orderModel!.id),
                   ) :const SizedBox(),

                ],
              );
            }
          ),
        ]),
      ),
    );
  }
}



