import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/refund/controllers/refund_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/features/refund/widgets/approve_reject_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/widgets/customer_info_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/widgets/delivery_man_info_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/widgets/refund_pricing_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/widgets/refund_widget.dart';



class RefundDetailWidget extends StatefulWidget {
  final RefundModel? refundModel;
  final int? orderDetailsId;
  final String? variation;
  const RefundDetailWidget({Key? key, required this.refundModel, required this.orderDetailsId, this.variation}) : super(key: key);
  @override
  RefundDetailWidgetState createState() => RefundDetailWidgetState();
}

class RefundDetailWidgetState extends State<RefundDetailWidget> {
  @override
  void initState() {
    Provider.of<RefundController>(context, listen: false).getRefundReqInfo(context, widget.orderDetailsId);
    Provider.of<RefundController>(context, listen: false).setInitialResetButton();
    super.initState();
  }
  bool showButton = false;
  @override
  Widget build(BuildContext context) {

    return Stack(children: [
        SingleChildScrollView(
          child: Consumer<RefundController>(
              builder: (context,refundReq,_) {

                if(refundReq.refundDetailsModel != null){
                  List<RefundStatus>? status =[];
                  status = refundReq.refundDetailsModel?.refundRequest![0].refundStatus;

                  String _changeBy = '';
                  for(RefundStatus action in status!){
                    if (kDebugMode) {
                      print('=====>${action.changeBy}');
                    }
                    if(action.changeBy == 'admin'){
                      _changeBy = 'admin';
                      showButton = false;
                    }
                  }

                  if(_changeBy != 'admin'){
                    showButton = true;
                  }
                }
                
                return Column(mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        child: RefundWidget(refundModel: widget.refundModel,isDetails: true,),
                      ),
                      
                      const RefundPricingWidget(),

                      const SizedBox(height: Dimensions.paddingSizeSmall),


                      widget.refundModel!.customer != null ?
                      CustomerInfoWidget(refundModel: widget.refundModel) : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Text("Customer not found", style: robotoMedium.copyWith(color: Colors.red),),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeSmall,),

                      (refundReq.refundDetailsModel !=null && refundReq.refundDetailsModel!.deliverymanDetails != null)?
                      DeliveryManInfoWidget(refundReq: refundReq):const SizedBox(),

                      const SizedBox(height: Dimensions.paddingSizeBottomSpace),


                    ]);
              }
          ),
        ),

        Consumer<RefundController>(
            builder: (context,refundReq,_) {
            return refundReq.showRejectButton ? Positioned(bottom: 0,left: 0,right: 0,
                child: ApprovedAndRejectWidget(refundModel: widget.refundModel)) : const SizedBox();
          }
        )
      ],

    );
  }
}


class ProductCalculationItem extends StatelessWidget {
  final String? title;
  final double? price;
  final bool isQ;
  final int? qty;
  final bool isNegative;
  final bool isPositive;
  const ProductCalculationItem({Key? key, this.title, this.price, this.isQ = false, this.isNegative = false, this.isPositive = false, this.qty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      isQ?
      Text('${getTranslated(title, context)} (x$qty)',
          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.titleColor(context))):
      Text('${getTranslated(title, context)}',
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.titleColor(context))),
      const Spacer(),
      isNegative?
      Text('- ${PriceConverter.convertPrice(context, price)}',
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.titleColor(context))):
      isPositive?
      Text('+ ${PriceConverter.convertPrice(context, price)}',
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.titleColor(context))):
      Text(PriceConverter.convertPrice(context, price),
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
              color: ColorResources.titleColor(context))),
    ],);
  }
}
