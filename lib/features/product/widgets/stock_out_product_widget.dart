
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/product_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/title_row_widget.dart';
import 'package:sixvalley_vendor_app/features/refund/screens/refund_screen.dart';
import 'package:sixvalley_vendor_app/features/product/screens/stock_out_product_screen.dart';
import 'package:sixvalley_vendor_app/features/product/widgets/stockout_product_card_widget.dart';


class StockOutProductView extends StatelessWidget {
  final bool isHome;
  final ScrollController? scrollController;
  const StockOutProductView({Key? key,  required this.isHome, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Provider.of<ProductController>(context, listen: false).stockOutProductList.isNotEmpty
          && !Provider.of<ProductController>(context, listen: false).isLoading) {
        int pageSize;
        pageSize = (Provider.of<ProductController>(context, listen: false).stockOutProductPageSize!/10).ceil();

        print("===PageSize===>>${pageSize}");

        if(Provider.of<ProductController>(context, listen: false).offset < pageSize) {
          Provider.of<ProductController>(context, listen: false).setOffset(Provider.of<ProductController>(context, listen: false).offset+1);
          if (kDebugMode) {
            print('end of the page');
          }
          Provider.of<ProductController>(context, listen: false).showBottomLoader();

          Provider.of<ProductController>(context, listen: false).getStockOutProductList(
              Provider.of<ProductController>(context, listen: false).
              offset, Provider.of<LocalizationController>(context, listen: false).locale.languageCode == 'US'?
          'en':Provider.of<LocalizationController>(context, listen: false).locale.countryCode!.toLowerCase());

        }
      }
    });


    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        productList = prodProvider.stockOutProductList;


        return Column(children: [

          isHome && productList.isNotEmpty ?
          Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            child: Row(children: [
                SizedBox(width: Dimensions.iconSizeDefault, child: Image.asset(Images.limitedStockIcon)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Expanded(child: TitleRowWidget(title: '${getTranslated('stock_out_product', context)}',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockOutProductScreen()))),
                ),
              ],
            ),
          ):const SizedBox(),

          !prodProvider.isLoading ? productList.isNotEmpty ?
          Expanded(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: isHome? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productList.length,
                  itemBuilder: (ctx,index){
                    return ProductWidget(productModel: productList[index]);

                  }) :
              ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                  itemCount: productList.length,
                  itemBuilder: (ctx,index){
                    return StockOutProductWidget(productModel: productList[index]);

        })),
          ): const Expanded(child: NoDataScreen()) :const Expanded(child: OrderShimmer()),

          prodProvider.isPaginationLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink(),

        ]);
      },
    );
  }
}


