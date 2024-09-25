import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/features/dashboard/widgets/gradient_border_widget.dart';
import 'package:sixvalley_vendor_app/features/menu/widgets/menu_widget.dart';



class NavBarScreen extends StatefulWidget {
  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  void _loadData(){

  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomMenuController>(builder: (context,menuController,_) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        body: PageStorage(bucket: bucket, child: menuController.currentScreen),
        floatingActionButton: UnicornOutlineButtonWidget(strokeWidth: 0, radius: 50,
          gradient: LinearGradient(colors: [ColorResources.gradientColor,
            ColorResources.gradientColor.withOpacity(0.5),
            ColorResources.secondaryColor.withOpacity(0.3),
            ColorResources.gradientColor.withOpacity(0.05),
            ColorResources.gradientColor.withOpacity(0),],
              begin: Alignment.topCenter, end: Alignment.bottomCenter),

          child: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, elevation: 1,
            onPressed: (){
            Provider.of<CartController>(context,listen: false).scanProductBarCode(context);
            },


              child: Padding(padding: const EdgeInsets.all(15.0),
                  child: Image.asset(Images.scanner)))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(height: 60,
          decoration: BoxDecoration(color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.14),
              blurRadius: 80, offset: const Offset(0, 20)),
            BoxShadow(color: Theme.of(context).cardColor,
                blurRadius: 0.5, offset: const Offset(0, 0)),]),

          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customBottomItem(tap: () => menuController.selectHomePage(),
                icon: menuController.currentTab == 0 ? Images.pos : Images.pos,
                name: getTranslated('pos', context)!, selectIndex: 0,),
              customBottomItem(tap: () => menuController.selectPosScreen(),
                icon: menuController.currentTab == 1 ? Images.order : Images.order, name: getTranslated('my_order', context)!, selectIndex: 1),
              const SizedBox(height: 20, width: 20),
              customBottomItem(tap: () => menuController.selectItemsScreen(),
                icon: menuController.currentTab == 2 ? Images.productIcon : Images.productIcon, name: getTranslated('products', context)!, selectIndex: 2,
              ),
              customBottomItem(tap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => const MenuBottomSheetWidget()
                );
              },
                icon: menuController.currentTab == 3 ? Images.menu : Images.menu, name: getTranslated('menu', context)!, selectIndex: 3,
              ),
            ],
          ),
        ),
      );
    });


  }


  Widget customBottomItem({required String icon, required String name, VoidCallback? tap, int? selectIndex}) {
    return InkWell(onTap: tap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: Dimensions.navbarIconSize, width: Dimensions.navbarIconSize,
            child: Image.asset(icon, fit: BoxFit.contain, color: Provider.of<BottomMenuController>(context, listen: false).currentTab == selectIndex
                  ? Theme.of(context).primaryColor : ColorResources.nevDefaultColor,
            ),
          ),
          const SizedBox(height: 6.0),

          Text(name, style: TextStyle(color: Provider.of<BottomMenuController>(context, listen: false).currentTab == selectIndex
              ? Theme.of(context).primaryColor : ColorResources.nevDefaultColor, fontSize: Dimensions.navbarFontSize, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}


