import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/attribute_view_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';


class QuantityUpdateDialogWidget extends StatefulWidget {
  final String? title;
  final Function onYesPressed;
  final TextEditingController? note;
  final TextEditingController? stockQuantityController;
  final Product? product;
  const QuantityUpdateDialogWidget({Key? key, this.title, required this.onYesPressed, this.note, this.product, this.stockQuantityController}) : super(key: key);

  @override
  State<QuantityUpdateDialogWidget> createState() => _QuantityUpdateDialogWidgetState();
}

class _QuantityUpdateDialogWidgetState extends State<QuantityUpdateDialogWidget> {


  int addColor = 0;

  void _load(){
    String languageCode = Provider.of<LocalizationController>(context, listen: false).locale.countryCode == 'US'?
    'en':Provider.of<LocalizationController>(context, listen: false).locale.countryCode!.toLowerCase();
    Provider.of<SplashController>(context,listen: false).getColorList();
    Provider.of<AddProductController>(context,listen: false).getAttributeList(context, widget.product, languageCode);
  }

  @override
  void initState() {
    _load();
    Provider.of<AddProductController>(context,listen: false).setCurrentStock(widget.product!.currentStock.toString());
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Consumer<AddProductController>(
          builder: (context, resProvider, child) {
            List<int> colors = [];
            colors.add(0);


            if (Provider.of<AddProductController>(context, listen: false).attributeList != null &&
                Provider.of<AddProductController>(context, listen: false).attributeList!.isNotEmpty) {
              if(addColor==0) {
                addColor++;
                if ( widget.product!.colors != null && widget.product!.colors!.isNotEmpty) {
                  Future.delayed(Duration.zero, () async {
                    Provider.of<AddProductController>(context, listen: false).setAttribute();
                  });
                }
                for (int index = 0; index < widget.product!.colors!.length; index++) {
                  colors.add(index);
                  Future.delayed(Duration.zero, () async {
                    resProvider.addVariant(context,0, widget.product!.colors![index].name, widget.product, false);
                    resProvider.addColorCode(widget.product!.colors![index].code, index: index);
                  });
                }
              }
            }

            widget.stockQuantityController!.text = resProvider.totalQuantityController.text;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Column(mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [


                             Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Text(
                                widget.title!, textAlign: TextAlign.center,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                              ),
                            ),


                            resProvider.attributeList != null?
                            AttributeViewWidget(product: widget.product, colorOn: resProvider.attributeList![0].active, onlyQuantity: true):const CircularProgressIndicator(),


                            Container(margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                                bottom: Dimensions.paddingSizeSmall),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(getTranslated('total_quantity', context)!,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                  CustomTextFieldWidget(
                                    border: true,
                                    textInputType: TextInputType.number,
                                    controller: widget.stockQuantityController,
                                    textInputAction: TextInputAction.next,
                                    isAmount: true,
                                    hintText: 'Ex: 500',
                                  ),
                                ],)),


                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Consumer<AddProductController>(builder: (context, shippingProvider, child) {
                              return !shippingProvider.isLoading ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: SizedBox(height: 40,
                                  child: CustomButtonWidget(
                                    borderRadius: 10,
                                    btnTxt: getTranslated('update_quantity',context),
                                    onTap: () =>  widget.onYesPressed(),
                                  ),
                                ),
                              ) : const Center(child: CircularProgressIndicator());
                            }),
                          ]),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: SizedBox(width: 18,child: Image.asset(Images.cross)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ));
  }
}