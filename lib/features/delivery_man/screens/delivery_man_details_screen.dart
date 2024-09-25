
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/collect_cash_from_delivery_man_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/delivery_man_earning_list_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/delivery_man_order_history_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/delivery_man_review_list_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/delivery_man_overview_screen.dart';


class DeliveryManDetailsScreen extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  const DeliveryManDetailsScreen({Key? key, this.deliveryMan}) : super(key: key);
  @override
  State<DeliveryManDetailsScreen> createState() => _DeliveryManDetailsScreenState();
}

class _DeliveryManDetailsScreenState extends State<DeliveryManDetailsScreen> with TickerProviderStateMixin{
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<DeliveryManController>(context, listen: false).getDeliveryManDetails( widget.deliveryMan!.id);
    Provider.of<DeliveryManController>(context, listen: false).getDeliveryManOrderList(context, 1, widget.deliveryMan!.id);
    Provider.of<DeliveryManController>(context, listen: false).getDeliveryManEarningList(context, 1, widget.deliveryMan!.id);
    Provider.of<DeliveryManController>(context, listen: false).getDeliveryManReviewList(context, 1, widget.deliveryMan!.id);
    Provider.of<DeliveryManController>(context, listen: false).getDeliveryCollectedCashList(context,  widget.deliveryMan!.id, 1);
    _tabController = TabController(length: 5, initialIndex: 0, vsync: this);
    _tabController?.addListener((){
      switch (_tabController!.index){
        case 0:
          Provider.of<AuthController>(context, listen: false).setIndexForTabBar(0, isNotify: true);
          break;
        case 1:
          Provider.of<AuthController>(context, listen: false).setIndexForTabBar(1, isNotify: true);
          break;
        case 2:
          Provider.of<AuthController>(context, listen: false).setIndexForTabBar(2, isNotify: true);
          break;
        case 3:
          Provider.of<AuthController>(context, listen: false).setIndexForTabBar(3, isNotify: true);
          break;
        case 4:
          Provider.of<AuthController>(context, listen: false).setIndexForTabBar(4, isNotify: true);
          break;
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: getTranslated('delivery_man_details', context), isBackButtonExist: true, isAction: true,isSwitch: true,
        switchAction: (value){
          if(value){
            Provider.of<DeliveryManController>(context, listen: false).deliveryManStatusOnOff(context, widget.deliveryMan!.id, 1);
          }else{
            Provider.of<DeliveryManController>(context, listen: false).deliveryManStatusOnOff(context, widget.deliveryMan!.id, 0);
          }
        },
      ),

      body: Consumer<AuthController>(
          builder: (authContext,authProvider, _) {
            return Column( children: [
              Center(
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).hintColor,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 1,
                    unselectedLabelStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w400,
                    ),
                    labelStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: [
                      Tab(text: getTranslated("overview", context)),
                      Tab(text: getTranslated("order_history", context)),
                      Tab(text: getTranslated("earnings", context)),
                      Tab(text: getTranslated("reviews", context)),
                      Tab(text: getTranslated("collected_cash", context)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall,),
              Expanded(child: TabBarView(
                controller: _tabController,
                children: [
                  DeliveryManOverViewScreen(deliveryMan: widget.deliveryMan),
                  DeliveryManOrderListScreen(deliveryMan: widget.deliveryMan),
                  DeliveryManEarningListWidget(deliveryMan: widget.deliveryMan),
                  DeliveryManReviewListWidget(deliveryMan: widget.deliveryMan),
                  CollectedCashFromDeliveryManScreen(deliveryMan: widget.deliveryMan),
                ],
              )),
            ]);
          }
      ),

    );
  }
}
