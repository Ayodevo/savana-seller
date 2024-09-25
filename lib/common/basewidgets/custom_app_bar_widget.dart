import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:sixvalley_vendor_app/features/product_details/controllers/productDetailsController.dart';
import 'package:sixvalley_vendor_app/features/review/controllers/product_review_controller.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final Function? filter;
  final Function? switchAction;
  final bool isAction;
  final bool isSwitch;
  final bool isCart;
  final bool activeProduct;
  final bool activeDelivery;
  final bool productSwitch;
  final bool reviewSwitch;
  final bool productReviewSwitch;
  final bool fromProduct;
  final int? index;
  final bool isTooltip;
  final Widget? widget;
  const CustomAppBarWidget({Key? key, required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    this.isAction = false,
    this.filter,
    this.isSwitch = false,
    this.switchAction,
    this.isCart = false,
    this.activeProduct = false,
    this.productSwitch = false,
    this.activeDelivery = false,
    this.reviewSwitch = false,
    this.index,
    this.isTooltip = false, this.widget, this.productReviewSwitch = false, this.fromProduct = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).primaryColor.withOpacity(0):
          Theme.of(context).primaryColor.withOpacity(.10),
            offset: const Offset(0, 2.0), blurRadius: 4.0,
          )
        ]),
        child: AppBar(
          shadowColor: Theme.of(context).primaryColor.withOpacity(.5),
          titleSpacing: 0,
          title: Text(title!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge!.color)),
          centerTitle: true,
          leading: isBackButtonExist ? IconButton(icon: const Icon(Icons.arrow_back_ios, size: Dimensions.iconSizeDefault),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context)) :
          IconButton(icon: Image.asset(Images.logo,scale: 5,), onPressed: () {  },),
          backgroundColor: Theme.of(context).highlightColor,
          elevation: 0,
          actions: isAction? [
            isSwitch ?
            Consumer<ProductDetailsController>(
              builder: (context, details,_) {
                return Consumer<DeliveryManController>(
                  builder: (context, delivery,_) {
                    return Consumer<ProductReviewController>(
                      builder: (context, productReview,_) {
                        return Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: FlutterSwitch(width: 40,height: 22,toggleSize: 18,
                              padding: 2,
                              value: productSwitch? details.productDetails?.status == 1 :
                              reviewSwitch? productReview.reviewList[index!].status==1 :
                              productReviewSwitch? productReview.productReviewList[index!].status ==1:
                              delivery.deliveryManDetails?.deliveryMan?.isActive == 1,
                              onToggle: switchAction as void Function(bool)),
                        );
                      }
                    );
                  }
                );
              }
            ): isCart?
                Consumer<CartController>(
                    builder: (context, cartController, _) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: IconButton(
                          onPressed: () {
                            Provider.of<BottomMenuController>(context, listen: false).selectHomePage();
                          },
                          icon: Stack(clipBehavior: Clip.none, children: [
                            Image.asset( Images.cart,
                              height: Dimensions.iconSizeDefault,
                              width: Dimensions.iconSizeDefault,
                              color: Theme.of(context).primaryColor,
                            ),

                            Positioned(top: -4, right: -4,
                              child: CircleAvatar(radius: 7, backgroundColor: Colors.green,
                                child: Text('${cartController.customerCartList.isNotEmpty?cartController.customerCartList[cartController.customerIndex].cart!.length : 0}',
                                    style: robotoRegular.copyWith(color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeSmall)), ),
                            ),
                          ],),
                        ),
                      );
                    }
                ) : isTooltip?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: widget,
                ):
            const SizedBox()
          ] : [],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
