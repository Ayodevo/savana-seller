import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/features/pos/widgets/searched_product_item_widget.dart';

class ProductSearchDialogWidget extends StatelessWidget {
  const ProductSearchDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, searchedProductController,_){
        int length =  searchedProductController.posProductList.length;
      return searchedProductController.posProductList.isNotEmpty?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
        child: Container(height: length == 1 ? 70 : length == 2 ? 135 : 400,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(.125),
                  spreadRadius: .5, blurRadius: 12, offset: const Offset(3,5))]
          ),
          child: ListView.builder(
              itemCount: searchedProductController.posProductList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return SearchedProductItemWidget(product: searchedProductController.posProductList[index]);
              }),
        ),
      ):const SizedBox.shrink();
    });
  }
}
