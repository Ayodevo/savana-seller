import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/barcode/controllers/barcode_controller.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/screens/add_product_screen.dart';
import 'package:sixvalley_vendor_app/features/product_details/screens/product_details_screen.dart';
import 'package:sixvalley_vendor_app/features/barcode/screens/bar_code_generator_screen.dart';
import 'package:sixvalley_vendor_app/features/product/widgets/quantity_change_dialog_widget.dart';



class StockOutProductWidget extends StatefulWidget {
  final Product productModel;
   const StockOutProductWidget({Key? key, required this.productModel}) : super(key: key);

  @override
  State<StockOutProductWidget> createState() => _StockOutProductWidgetState();
}

class _StockOutProductWidgetState extends State<StockOutProductWidget> {
  final TextEditingController _stockQuantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    int variationLength = 0;
    variationLength = widget.productModel.variation!.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall,
          0, Dimensions.paddingSizeExtraSmall,Dimensions.paddingSizeSmall,),
      child: Slidable(
        key: const ValueKey(0),

        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dragDismissible: false,
          dismissible: DismissiblePane(onDismissed: () {
            ConfirmationDialogWidget(icon: Images.deleteProduct,
                refund: false,
                description: getTranslated('are_you_sure_want_to_delete_this_product', context),
                onYesPressed: () {
                  Provider.of<ProductController>(context, listen:false).deleteProduct(context ,widget.productModel.id).then((value) {
                    Provider.of<ProductController>(context,listen: false).getStockOutProductList(1, 'en');
                    Provider.of<ProductController>(context, listen: false).initSellerProductList(Provider.of<ProfileController>(context, listen: false).
                    userInfoModel!.id.toString(), 1, context, 'en','', reload: true);
                  });
                }
            );
          }),
          children:  [
            SlidableAction(
              onPressed: (value){
                showDialog(context: context, builder: (BuildContext context){
                  return ConfirmationDialogWidget(icon: Images.deleteProduct,
                      refund: false,
                      description: getTranslated('are_you_sure_want_to_delete_this_product', context),
                      onYesPressed: () {
                        Provider.of<ProductController>(context, listen:false).deleteProduct(context ,widget.productModel.id).then((value) {
                          Provider.of<ProductController>(context,listen: false).getStockOutProductList(1, 'en');
                          Provider.of<ProductController>(context, listen: false).initSellerProductList(Provider.of<ProfileController>(context, listen: false).
                          userInfoModel!.id.toString(), 1, context, 'en','', reload: true);
                        });
                      }
                  );});
              },
              backgroundColor: Theme.of(context).colorScheme.error.withOpacity(.05),
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete_forever_rounded,
              label: getTranslated('delete', context),
            ),
            SlidableAction(
              onPressed: (value){
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddProductScreen(product: widget.productModel)));
              },
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.05),
              foregroundColor: Theme.of(context).primaryColor,
              icon: Icons.edit,
              label: getTranslated('edit', context),
            ),
          ],
        ),

        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (value){
                showDialog(context: context, builder: (BuildContext context){
                  return ConfirmationDialogWidget(icon: Images.deleteProduct,
                      refund: false,
                      description: getTranslated('are_you_sure_want_to_delete_this_product', context),
                      onYesPressed: () {
                        Provider.of<ProductController>(context, listen:false).deleteProduct(context ,widget.productModel.id).then((value) {
                          Provider.of<ProductController>(context,listen: false).getStockOutProductList(1, 'en');
                          Provider.of<ProductController>(context, listen: false).initSellerProductList(Provider.of<ProfileController>(context, listen: false).
                          userInfoModel!.id.toString(), 1, context, 'en','', reload: true);
                        });
                      }
                  );});
              },
              backgroundColor: Theme.of(context).colorScheme.error.withOpacity(.05),
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete_forever_rounded,
              label: getTranslated('delete', context),
            ),
            SlidableAction(
              onPressed: (value){
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddProductScreen(product: widget.productModel)));
              },
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.05),
              foregroundColor: Theme.of(context).primaryColor,
              icon: Icons.edit,
              label: getTranslated('edit', context),
            ),
          ],
        ),

        child: Container(
          padding: const EdgeInsets.only(left : Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!, spreadRadius: 0.5, blurRadius: 0.3)],),
          child: Stack(children: [
              GestureDetector(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> ProductDetailsScreen(productModel: widget.productModel))),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(padding: EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall,
                            right: Provider.of<LocalizationController>(context, listen: false).isLtr? 0: Dimensions.fontSizeSmall),

                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(.10),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),),
                          width: Dimensions.stockOutImageSize,
                          height: Dimensions.stockOutImageSize,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              child: CustomImageWidget(image: '${widget.productModel.thumbnailFullUrl?.path}')
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall,),


                      Flexible(child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(widget.productModel.name ?? '', style: robotoRegular.copyWith(color: ColorResources.titleColor(context)),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(children: [

                              Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall,
                                    Dimensions.paddingSizeVeryTiny, Dimensions.paddingSizeExtraSmall,
                                    Dimensions.paddingSizeVeryTiny),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                  color :widget.productModel.currentStock == 0?
                                  Theme.of(context).colorScheme.error:
                                  Theme.of(context).colorScheme.onSecondary),


                                child:widget.productModel.currentStock == 0?
                                Text('${widget.productModel.currentStock.toString()} ${getTranslated('stock_out', context)}'
                                    , style: robotoRegular.copyWith(color: Colors.white),
                                    maxLines: 1, overflow: TextOverflow.ellipsis):
                                Text('${widget.productModel.currentStock.toString()} ${getTranslated('in_stock', context)}'
                                    , style: robotoRegular.copyWith(color: Colors.white),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          variationLength != 0?
                          Text('$variationLength ${getTranslated('variation', context)}'):const SizedBox(),
                        ],),
                      ),
                      ),
                    ],),
                ),
              ),


              Positioned(bottom: 15, right: Provider.of<LocalizationController>(context, listen: false).isLtr? 70 : null,
                left: Provider.of<LocalizationController>(context, listen: false).isLtr? null : 70,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Center(child:  InkWell(onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BarCodeGenerateScreen(product: widget.productModel)));
                    Provider.of<BarcodeController>(context, listen: false).setBarCodeQuantity(4);
                  },
                    child: Image.asset(Images.barcodeIcon, width: 30,),),
                  ),
                ),) ,

              Consumer<AddProductController>(
                  builder: (context, productProvider, _) {
                    return Positioned(bottom: 13, right: Provider.of<LocalizationController>(context, listen: false).isLtr? 15 : null,
                      left: Provider.of<LocalizationController>(context, listen: false).isLtr? null : 5,
                      child: Container(height: 35, width: 35,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(.75),
                        borderRadius: BorderRadius.circular(20),),
                      child: Center(child:  InkWell(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return QuantityUpdateDialogWidget(
                                    stockQuantityController: _stockQuantityController,
                                    product: widget.productModel,
                                    title: getTranslated('product_variations', context),
                                    onYesPressed: () {
                                      bool isEmpty = false;

                                      if(productProvider.variantTypeList.isNotEmpty){
                                        for (int i=0; i< productProvider.variantTypeList.length; i++) {
                                          if(productProvider.variantTypeList[i].qtyController.text == '' && !isEmpty) {
                                            isEmpty = true;
                                          }
                                        }
                                      }

                                      if(isEmpty) {
                                        showCustomSnackBarWidget('variation_quantity_is_required', sanckBarType: SnackBarType.error, context);
                                      } else if(_stockQuantityController.text.toString().isEmpty){
                                        showCustomSnackBarWidget('product_quantity_is_required', context);
                                        if (kDebugMode) {
                                          print(widget.productModel.id);
                                        }
                                      }else{
                                        productProvider.updateProductQuantity(context, widget.productModel.id, int.parse(_stockQuantityController.text.toString()), widget.productModel.variation!);
                                      }
                                    }
                                );
                              },
                            );
                          },
                          child: const Center(child: Icon(Icons.add, color: Colors.white))),
                      ),
                    ),);
                  }
              ),
            ],
          ),
        ),
      ),
    );

  }
}
