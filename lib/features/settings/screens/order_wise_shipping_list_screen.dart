import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/settings/controllers/business_controller.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/features/shipping/controllers/shipping_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/settings/screens/order_wise_shipping_add_screen.dart';
import 'package:sixvalley_vendor_app/features/settings/widgets/order_wise_shipping_card_widget.dart';
import 'package:sixvalley_vendor_app/features/shipping/widgets/drop_down_for_shipping_type_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/animated_floating_button_widget.dart';

class OrderWiseShippingScreen extends StatefulWidget {
  const OrderWiseShippingScreen({Key? key}) : super(key: key);

  @override
  State<OrderWiseShippingScreen> createState() => OrderWiseShippingScreenState();
}

class OrderWiseShippingScreenState extends State<OrderWiseShippingScreen> {

  @override
  void initState() {
    Provider.of<ShippingController>(context, listen: false).iniType('order_wise');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Provider.of<BusinessController>(context, listen: false).getBusinessList(context);
    Provider.of<ShippingController>(context, listen: false).getShippingList(Provider.of<AuthController>(context,listen: false).getUserToken());
    ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      appBar: CustomAppBarWidget(title: getTranslated('business_settings', context), isBackButtonExist: true),
      body: Stack(children: [ Column( children: [
              const DropDownForShippingTypeWidget(),
              Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault,Dimensions.paddingSizeExtraSmall),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                  decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(.125),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${getTranslated('sl', context)}    ${getTranslated('details', context)}', style: robotoMedium,),
                    Text(getTranslated('action', context)!, style: robotoMedium,)
                  ],),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Consumer<ShippingController>(
                      builder: (context, shipProv, child) {
                        return  shipProv.shippingList !=null ? shipProv.shippingList!.isNotEmpty ?
                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: 70),
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                              itemCount: shipProv.shippingList!.length,
                              itemBuilder: (context, index){
                                return OrderWiseShippingCardWidget(shipProv: shipProv,shippingModel: shipProv.shippingList![index], index: index,);
                              }
                          ),
                        ) : const NoDataScreen()
                            : Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
                      }
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            child: Align(
              alignment: Provider.of<LocalizationController>(context, listen: false).isLtr? Alignment.bottomRight: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                child: ScrollingFabAnimated(
                  width: 150,
                  color: Theme.of(context).cardColor,
                  icon: SizedBox(width: Dimensions.iconSizeExtraLarge,child: Image.asset(Images.addIcon)),
                  text: Text(getTranslated('add_new', context)!, style: robotoRegular.copyWith(),),
                  onPress: () => showAnimatedDialogWidget(context, const OrderWiseShippingAddScreen()),
                  animateIcon: true,
                  inverted: false,
                  scrollController: scrollController,
                  radius: 100.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
