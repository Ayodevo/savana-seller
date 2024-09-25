import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/title_row_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/delivery_man_earning_view_all_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/delivery_man_earning_list_view_widget.dart';


class DeliveryManEarningListWidget extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  const DeliveryManEarningListWidget({Key? key, this.deliveryMan}) : super(key: key);

  @override
  State<DeliveryManEarningListWidget> createState() => _DeliveryManEarningListWidgetState();
}

class _DeliveryManEarningListWidgetState extends State<DeliveryManEarningListWidget> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Consumer<DeliveryManController>(
        builder: (context, earningProvider,_) {
          String totalWithDrawn = earningProvider.deliveryManEarning?.deliveryMan?.wallet?.totalWithdraw??'0';
          return Column( children: [
              EarningItemCard(amount: earningProvider.deliveryManEarning?.totalEarn ?? 0, title: 'total_earning',icon: Images.totalEarning),

              EarningItemCard(amount: earningProvider.deliveryManEarning?.withdrawableBalance ?? 0, title: 'withdrawable_balance',icon: Images.withdrawableBalanceIcon),

              EarningItemCard(amount: double.parse(totalWithDrawn), title: 'already_withdrawn',icon: Images.alreadyWithdrawnIcon),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeExtraSmall),
                child: TitleRowWidget(title: getTranslated('earning_statement', context), onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> DeliveryManEarningViewAllScreen(deliveryMan: widget.deliveryMan)));
                },),
              ),

              DeliverymanEarningListViewWidget(deliveryMan: widget.deliveryMan, scrollController: _scrollController,),
            ],
          );
        }
      ),
    );
  }
}


class EarningItemCard extends StatelessWidget {
  final double? amount;
  final String? title;
  final String? icon;
  const EarningItemCard({Key? key, this.amount, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeMedium,0, Dimensions.paddingSizeMedium, Dimensions.paddingSizeSmall ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(.125), blurRadius: 1, spreadRadius: 1, offset: const Offset(0,1))]
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(PriceConverter.convertPrice(context, amount), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeMaxLarge),),
              const SizedBox(height: Dimensions.paddingSizeMedium,),
              Text(getTranslated(title, context)!,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor))
            ],),
            SizedBox(width: Dimensions.iconSizeExtraLarge,child: Image.asset(icon!),),
          ],),),
    );
  }
}
