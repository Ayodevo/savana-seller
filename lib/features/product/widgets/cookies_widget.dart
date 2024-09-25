import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/product/screens/stock_out_product_screen.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CookiesWidget extends StatelessWidget {
  const CookiesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<ProductController>(
        builder: (context, productController, _) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
            child: Material(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Dimensions.paddingSize)
                      ),
                        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(.125), blurRadius: 1,spreadRadius: 1,offset: const Offset(1,2))]
                    ),
              
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault,
                      horizontal: Dimensions.paddingSizeSmall,
                    ),
              
                    child: SizedBox(width: MediaQuery.of(context).size.width, child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: int.parse(productController.stockLimitStatus?.productCount.toString() ?? '0') == 1 ?
                          CustomImageWidget(
                            height: 35, width: 35,
                            image: '${productController.stockLimitStatus?.product?.thumbnailFullUrl?.path}')
                          : Image.asset(
                            height: 32, width: 32,
                            Images.cookiesWarning,
                          ),
                        ),
              
              
              
              
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Text(
                              int.parse(productController.stockLimitStatus?.productCount.toString() ?? '0') == 1 ?
                              productController.stockLimitStatus?.product?.name ?? '':
                              getTranslated('warning', context)!,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                            Text(
                              int.parse(productController.stockLimitStatus?.productCount.toString() ?? '0') == 1 ?
                              getTranslated('this_product_is_low', context)! :
                              int.parse(productController.stockLimitStatus?.productCount.toString() ?? '0') < 101 ?
                              (productController.stockLimitStatus!.productCount != null ? (productController.stockLimitStatus!.productCount! - 1).toString() : '0') + getTranslated('more_products_have_low_stock', context)! :
                              getTranslated('there_isnt_enough_quantity', context)!,

                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),




                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                InkWell(
                                  onTap: (){
                                    productController.setShowCookies();
                                  },
                                  child: Text(
                                    getTranslated('dont_show_again', context)!,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    Navigator.push(Get.context!, MaterialPageRoute(builder: (_) => const StockOutProductScreen()));
                                  },
                                  child: Text(
                                    getTranslated('click_to_view', context)!,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          
                          ]),
                        ),


                        InkWell(
                          onTap: () {
                           productController.setShowCookie(false, notify: true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: Dimensions.fontSizeLarge,
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall
                            ),
                            child: Image.asset(
                              height: 20, width: 20,
                              Images.crossIcon,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}