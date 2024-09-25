import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/cart_model.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/pos/widgets/product_variation_selection_dialog_widget.dart';



class SearchedProductItemWidget extends StatelessWidget {
  final Product? product;
  const SearchedProductItemWidget({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<CartController>(
        builder: (context, cartController, _) {
          return InkWell(
            onTap: (){
              if(product!.currentStock! < 1 && product?.productType == "physical"){
                showCustomSnackBarWidget(getTranslated('stock_out', context), context, isToaster: true);
              }else{
                if(product!.variation!.isNotEmpty || product!.digitalProductFileTypes!.isNotEmpty){
                  showModalBottomSheet(context: context, isScrollControlled: true,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
                    builder: (con) => CartBottomSheetWidget(product: product, callback: () {
                      showCustomSnackBarWidget(getTranslated('added_to_cart', context), context, isError: false);}));
                }else{
                  CartModel cartModel = CartModel(product!.unitPrice, product!.discount, 1, product!.tax,null,null,null,null, product, product!.taxModel);
                  cartController.addToCart(context, cartModel);
                }
              }
            },
            child: Row(children: [
              Container(width: Dimensions.productImageSize,height: Dimensions.productImageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeBorder),
                  child: CustomImageWidget(
                    fit: BoxFit.cover,
                    image: '${product!.thumbnailFullUrl?.path}',
                  ),
                ),
              ),),
              const SizedBox(width: Dimensions.paddingSizeDefault,),
              Expanded(child: Text(product!.name!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                maxLines: 1,overflow: TextOverflow.ellipsis,))
            ]),
          );
        }
      ),
    );
  }
}
