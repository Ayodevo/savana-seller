import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/features/language/screens/change_language_screen.dart';
import 'package:sixvalley_vendor_app/features/settings/widgets/choose_shipping_dialog_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashController>(context, listen: false).setFromSetting(true);

    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('settings', context),),
      body: ListView(physics: const BouncingScrollPhysics(), children: [

          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          TitleButton(
            icon: Images.language,
            title: getTranslated('choose_language', context),
            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChooseLanguageScreen())),
          ),

          Provider.of<SplashController>(context, listen: false).configModel!.shippingMethod == 'sellerwise_shipping'?
          TitleButton(
            icon: Images.ship,
            title: '${getTranslated('shipping_setting', context)}',
            onTap: () => showAnimatedDialogWidget(context, const ChooseShippingDialogWidget()),
          ):const SizedBox(),

        ],
      ),
    );
  }

}
class TitleButton extends StatelessWidget {
  final String icon;
  final String? title;
  final Function onTap;
  const TitleButton({Key? key, required this.icon, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color:Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).primaryColor.withOpacity(0):
            Colors.grey[Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!,
                spreadRadius: 0.5, blurRadius: 0.3)],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
            child: Row(children: [
              SizedBox(width:Dimensions.iconSizeLarge, height:Dimensions.iconSizeLarge, child: Image.asset(icon)),
              const SizedBox(width: Dimensions.paddingSizeSmall,),
              Text(title!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor,size: Dimensions.iconSizeSmall,),
            ],

            ),
          ),
        ),
      ),
    );
  }
}

