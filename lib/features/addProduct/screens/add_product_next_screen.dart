
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/attribute_view_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/attribute_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_title_bar.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/digital_product_widget.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/variant_type_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/screens/add_product_seo_screen.dart';

import '../../auth/controllers/auth_controller.dart';

class AddProductNextScreen extends StatefulWidget {
  final ValueChanged<bool>? isSelected;
  final Product? product;
  final String? categoryId;
  final String? subCategoryId;
  final String? subSubCategoryId;
  final String? brandId;
  final AddProductModel? addProduct;
  final String? unit;

  const AddProductNextScreen({Key? key, this.isSelected, required this.product,required this.addProduct, this.categoryId, this.subCategoryId, this.subSubCategoryId, this.brandId, this.unit}) : super(key: key);

  @override
  AddProductNextScreenState createState() => AddProductNextScreenState();
}

class AddProductNextScreenState extends State<AddProductNextScreen> {
  bool isSelected = false;
  final FocusNode _discountNode = FocusNode();
  final FocusNode _shippingCostNode = FocusNode();
  final FocusNode _unitPriceNode = FocusNode();
  final FocusNode _taxNode = FocusNode();
  final FocusNode _totalQuantityNode = FocusNode();
  final FocusNode _minimumOrderQuantityNode = FocusNode();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _shippingCostController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  //final TextEditingController _totalQuantityController = TextEditingController();
  final TextEditingController _minimumOrderQuantityController = TextEditingController();
  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  SimpleAutoCompleteTextField? textField;
  bool showWhichErrorText = false;
  late bool _update;
  Product? _product;
  String? thumbnailImage ='', metaImage ='';
  List<String?>? productImage =[];
  int counter = 0, total = 0;
  int addColor = 0;
  int cat=0, subCat=0, subSubCat=0, unit=0, brand=0;
  bool showUploadFile = false;


  void _load(){
    String languageCode = Provider.of<LocalizationController>(context, listen: false).locale.countryCode == 'US'?
    'en':Provider.of<LocalizationController>(context, listen: false).locale.countryCode!.toLowerCase();
    Provider.of<SplashController>(context,listen: false).getColorList();
    Provider.of<AddProductController>(context,listen: false).getAttributeList(context, widget.product, languageCode);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<AddProductController>(context,listen: false).colorImageObject = [];
    Provider.of<AddProductController>(context,listen: false).productReturnImage = [];
    _product = widget.product;
    _update = widget.product != null;
    _taxController.text = '0';
    _discountController.text = '0';
    _shippingCostController.text = '0';
    //_totalQuantityController.text = '1';
    _minimumOrderQuantityController.text = '1';
    _load();
    if(_update) {
      _asyncMethod();
      _unitPriceController.text = PriceConverter.convertPriceWithoutSymbol(context, _product!.unitPrice);
      _taxController.text = _product!.tax.toString();
      Provider.of<AddProductController>(context, listen: false).setCurrentStock(_product!.currentStock.toString());
      // _totalQuantityController.text = _product!.currentStock.toString();
      _shippingCostController.text = _product!.shippingCost.toString();
      _minimumOrderQuantityController.text = _product!.minimumOrderQty.toString();
      Provider.of<AddProductController>(context, listen: false).setDiscountTypeIndex(_product!.discountType == 'percent' ? 0 : 1, false);
      _discountController.text = _product!.discountType == 'percent' ?
      _product!.discount.toString() : PriceConverter.convertPriceWithoutSymbol(context, _product!.discount);
      thumbnailImage = _product!.thumbnail;
      metaImage = _product!.metaImage;
      productImage = _product!.images;
      Provider.of<AddProductController>(context, listen: false).setTaxTypeIndex(_product!.taxModel == 'include' ? 0 : 1, false);
    }else {
      _product = Product();
    }
    super.initState();
  }


  _asyncMethod() async {
    Future.delayed(const Duration(milliseconds: 800), () async {
      Provider.of<AddProductController>(context,listen: false).getProductImage(widget.product!.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: true,
      onPopInvoked: (bool value) {
        Provider.of<AddProductController>(context,listen: false).setSelectedPageIndex(0, isUpdate: true);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title:  widget.product != null ?
        getTranslated('update_product', context):
        getTranslated('add_product', context),
        onBackPressed: () {
          Navigator.pop(context);
          Provider.of<AddProductController>(context,listen: false).setSelectedPageIndex(0, isUpdate: true);
        },
        ),
        body: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Consumer<AddProductController>(
            builder: (context, resProvider, child){
              List<int> brandIds = [];
              List<String> digitalVariation = ['Audio', 'Video', 'Document', 'Software'];
              List<int> colors = [];
              brandIds.add(0);
              colors.add(0);
                if (_update && Provider.of<AddProductController>(context, listen: false).attributeList != null &&
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

              for (int index = 0; index < resProvider.selectedDigitalVariation.length; index++) {
                if(resProvider.digitalVariationExtantion[index].isNotEmpty) {
                  showUploadFile = true;
                  break;
                }else{
                  showUploadFile = false;
                }
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: AddProductTitleBar()),

                  Expanded(
                    child: SingleChildScrollView(
                      child: (resProvider.attributeList != null &&
                          resProvider.attributeList!.isNotEmpty &&
                          resProvider.categoryList != null &&
                          Provider.of<SplashController>(context,listen: false).colorList!= null) ?

                          // padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          AddProductSectionWidget(
                            title: getTranslated('product_price_and_stock', context)!,
                            childrens: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                    Text(getTranslated('unit_price', context)!,
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context)),),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                    CustomTextFieldWidget(
                                      border: true,
                                      controller: _unitPriceController,
                                      focusNode: _unitPriceNode,
                                      textInputAction: TextInputAction.done,
                                      textInputType: TextInputType.number,
                                      isAmount: true,
                                      hintText: 'Ex: \$129',
                                    ),


                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    Row(children: [
                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(getTranslated('tax_model', context)!,
                                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context)
                                          ),),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),

                                        Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                            border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                          ),
                                          child: DropdownButton<String>(
                                            value: resProvider.taxTypeIndex == 0 ? 'include' : 'exclude',
                                            items: <String>['include', 'exclude'].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(getTranslated(value, context)!),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              resProvider.setTaxTypeIndex(value == 'include' ? 0 : 1, true);
                                            },
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                          ),
                                        ),
                                      ])),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(getTranslated('tax_p',context)!,
                                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context)
                                              )),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),
                                          CustomTextFieldWidget(
                                            border: true,
                                            controller: _taxController,
                                            focusNode: _taxNode,
                                            nextNode: _discountNode,
                                            isAmount: true,
                                            textInputAction: TextInputAction.next,
                                            textInputType: TextInputType.number,
                                            hintText: 'Ex: \$10',
                                          ),
                                        ],
                                      )),
                                    ]),

                                    const SizedBox(height: Dimensions.paddingSizeLarge),

                                    Row(children: [
                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(getTranslated('discount_type', context)!,
                                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context)
                                        )),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),

                                        Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                            border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                          ),
                                          child: DropdownButton<String>(
                                            value: resProvider.discountTypeIndex == 0 ? 'percent' : 'amount',
                                            items: <String>['percent', 'amount'].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(getTranslated(value, context)!),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              resProvider.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);
                                            },
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                          ),
                                        ),
                                      ])),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(getTranslated('discount_amount', context)!,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context))),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),
                                          CustomTextFieldWidget(
                                            border: true,
                                            hintText: getTranslated('discount', context),
                                            controller: _discountController,
                                            focusNode: _discountNode,
                                            nextNode: _shippingCostNode,
                                            textInputAction: TextInputAction.next,
                                            textInputType: TextInputType.number,
                                            isAmount: true,
                                            // isAmount: true,
                                          ),
                                        ],
                                      )),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeLarge),

                                    Row(children: [
                                      resProvider.productTypeIndex == 0?
                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(getTranslated('total_quantity', context)!,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context)
                                            )),
                                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                        CustomTextFieldWidget(
                                          idDate: resProvider.variantTypeList.isNotEmpty,
                                          border: true,
                                          textInputType: TextInputType.number,
                                          focusNode: _totalQuantityNode,
                                          controller: resProvider.totalQuantityController,
                                          textInputAction: TextInputAction.next,
                                          isAmount: true,
                                          hintText: 'Ex: 500',
                                        ),
                                      ],)): const SizedBox(),

                                      SizedBox(width: resProvider.productTypeIndex == 0? Dimensions.paddingSizeDefault:0),

                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(getTranslated('minimum_order_quantity', context)!,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context))),
                                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                        CustomTextFieldWidget(
                                          border: true,
                                          textInputType: TextInputType.number,
                                          focusNode: _minimumOrderQuantityNode,
                                          controller: _minimumOrderQuantityController,
                                          textInputAction: TextInputAction.next,
                                          isAmount: true,
                                          hintText: 'Ex: 500',
                                        ),
                                      ])),
                                    ],),

                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          //__________Shipping__________
                          resProvider.productTypeIndex == 0 ?
                          AddProductSectionWidget(
                            title: getTranslated('shipping', context)!,
                            childrens: [
                              resProvider.productTypeIndex == 0 ?
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: Column(children: [
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(getTranslated('shipping_cost', context)!,
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context)),
                                      ),
                                      const SizedBox(height: Dimensions.paddingSizeSmall),
                                      CustomTextFieldWidget(
                                        border: true,
                                        controller: _shippingCostController,
                                        focusNode: _shippingCostNode,
                                        nextNode: _totalQuantityNode,
                                        textInputAction: TextInputAction.next,
                                        textInputType: TextInputType.number,
                                        isAmount: true,
                                        // isAmount: true,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeDefault,),

                                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Expanded(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(getTranslated('shipping_cost_multiply', context)!,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context)
                                            ),
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                          Text(getTranslated('shipping_cost_multiply_by_item', context)!,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                                color: ColorResources.titleColor(context)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    FlutterSwitch(width: 60.0, height: 30.0, toggleSize: 30.0,
                                      value: resProvider.isMultiply,
                                      borderRadius: 20.0,
                                      activeColor: Theme.of(context).primaryColor,
                                      padding: 1.0,
                                      onToggle:(bool isActive) =>resProvider.toggleMultiply(context),
                                    ),
                                  ]),
                                  const SizedBox(height: Dimensions.iconSizeLarge),
                                ],),
                              ):const SizedBox(),
                            ],
                          ) : const SizedBox(),


                          resProvider.productTypeIndex == 0 ?
                          Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(getTranslated('variations', context)!,
                                      style: robotoBold.copyWith(color: ColorResources.getHeadTextColor(context),
                                          fontSize: Dimensions.fontSizeExtraLarge)),
                                ],
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Row(children: [
                                Text(getTranslated('add_color_variation', context)!,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context))),
                                const Spacer(),

                                FlutterSwitch(width: 60.0, height: 30.0, toggleSize: 28.0,
                                  value: resProvider.attributeList![0].active,
                                  borderRadius: 20.0,
                                  activeColor: Theme.of(context).primaryColor,
                                  padding: 1.0,
                                  onToggle:(bool isActive) =>resProvider.toggleAttribute(context, 0, widget.product),
                                ),
                              ],),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            resProvider.attributeList![0].active ?
                            Consumer<SplashController>(builder: (ctx, colorProvider, child){
                              if (colorProvider.colorList != null) {
                                for (int index = 0; index < colorProvider.colorList!.length; index++) {
                                  colors.add(index);
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: Autocomplete<int>(
                                  optionsBuilder: (TextEditingValue value) {
                                    if (value.text.isEmpty) {
                                      return const Iterable<int>.empty();
                                    } else {
                                      return colors.where((color) => colorProvider.colorList![color].
                                      name!.toLowerCase().contains(value.text.toLowerCase()));
                                    }
                                  },
                                  fieldViewBuilder: (context, controller, node, onComplete) {
                                    return Container(
                                      height: 50,
                                      decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                        border: Border.all(width: 1, color: Theme.of(context).hintColor.withOpacity(.50)),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                      ),
                                      child: TextField(
                                        controller: controller,
                                        focusNode: node, onEditingComplete: onComplete,
                                        decoration: InputDecoration(
                                          hintText: getTranslated('type_color_name', context),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                  Dimensions.paddingSizeSmall),
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    );
                                  },
                                  displayStringForOption: (value) => colorProvider.colorList![value].name!,
                                  onSelected: (int value) {
                                    resProvider.addVariant(context, 0,colorProvider.colorList![value].name, widget.product, true);
                                    resProvider.addColorCode(colorProvider.colorList![value].code);
                                  },
                                ),
                              );
                            }):const SizedBox(),


                            SizedBox(height: resProvider.selectedColor.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: SizedBox(height: (resProvider.attributeList![0].variants.isNotEmpty) ? 40 : 0,
                                child: (resProvider.attributeList![0].variants.isNotEmpty) ?

                                ListView.builder(
                                  itemCount: resProvider.attributeList![0].variants.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeVeryTiny),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeMedium),
                                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.20),
                                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                        ),
                                        child: Row(children: [
                                          Consumer<SplashController>(builder: (ctx, colorP,child){
                                            return Text(resProvider.attributeList![0].variants[index]!,
                                              style: robotoRegular.copyWith(color: ColorResources.titleColor(context)),);
                                          }),
                                          const SizedBox(width: Dimensions.paddingSizeSmall),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: (){resProvider.removeVariant(context, 0, index, widget.product);
                                            resProvider.removeColorCode(index);},
                                            child: Icon(Icons.close, size: 15, color: ColorResources.titleColor(context)),
                                          ),
                                        ]),
                                      ),
                                    );
                                  },
                                ):const SizedBox(),
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: AttributeViewWidget(product: widget.product, colorOn: resProvider.attributeList![0].active)),
                          ],):const SizedBox(),
                          SizedBox(height: resProvider.productTypeIndex == 0? 0 : Dimensions.paddingSizeDefault),

                          resProvider.productTypeIndex == 1 ?
                          Column(
                            children: [
                              AddProductSectionWidget(
                                title: getTranslated('variation', context)!,
                                childrens: [

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.7)),
                                          ),
                                          child: DropdownButton<String>(
                                            hint: Text(getTranslated('file_type', context)!,
                                                style: robotoBold.copyWith(color: ColorResources.getHeadTextColor(context),
                                                    fontSize: Dimensions.fontSizeExtraLarge)),
                                            items: digitalVariation.map((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value!),
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              if(resProvider.selectedDigitalVariation.contains(value)){
                                                showCustomSnackBarWidget(getTranslated('filetype_already_exists', context), context, sanckBarType: SnackBarType.warning);
                                              } else{
                                                resProvider.addDigitalProductVariation(value!);
                                              }
                                            },
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                          ),
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),

                                        resProvider.selectedDigitalVariation.isNotEmpty ?
                                        SizedBox(
                                          height: resProvider.selectedDigitalVariation.isNotEmpty ? 40 : 0,
                                          child: ListView.builder(
                                            itemCount: resProvider.selectedDigitalVariation.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(Dimensions.paddingSizeVeryTiny),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeMedium),
                                                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                                  decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.20),
                                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                                  ),
                                                  child: Row(children: [
                                                    Consumer<SplashController>(builder: (ctx, colorP,child){
                                                      return Text(resProvider.selectedDigitalVariation[index],
                                                        style: robotoRegular.copyWith(color: ColorResources.titleColor(context)),);
                                                    }),
                                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                                    InkWell(
                                                      splashColor: Colors.transparent,
                                                      onTap: (){
                                                        resProvider.removeDigitalVariant(context, index);
                                                      },
                                                      child: Icon(Icons.close, size: 15, color: ColorResources.titleColor(context)),
                                                    ),
                                                  ]),
                                                ),
                                              );
                                            },
                                          ),
                                        ):const SizedBox(),

                                        resProvider.selectedDigitalVariation.isNotEmpty ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

                                      ],
                                    ),
                                  ),


                                ],
                              ),

                              ListView.builder(
                                itemCount: resProvider.selectedDigitalVariation.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AddProductSectionWidget(
                                    title: '${resProvider.selectedDigitalVariation[index]} ${getTranslated('extension', context)!}',
                                    childrens: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: Dimensions.paddingSizeSmall),
                                            CustomTextFieldWidget(
                                              formProduct: true,
                                              required: true,
                                              border: true,
                                              controller: resProvider.extentionControllerList[index],
                                              textInputAction: TextInputAction.done,
                                              textInputType: TextInputType.text,
                                              isAmount: false,
                                              hintText: '${resProvider.selectedDigitalVariation[index]} ${getTranslated('extension', context)!}',
                                              onFieldSubmit: (String value) {
                                                if(resProvider.digitalVariationExtantion[index].contains(value)){
                                                  showCustomSnackBarWidget(getTranslated('extension_already_exists', context), context, sanckBarType: SnackBarType.warning);
                                                } else if(value.trim() != ''){
                                                  resProvider.addExtension(index, value);
                                                }
                                              },
                                            ),


                                            resProvider.digitalVariationExtantion[index].isNotEmpty ?
                                            const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

                                            resProvider.digitalVariationExtantion[index].isNotEmpty ?
                                            SizedBox(
                                              height: resProvider.digitalVariationExtantion[index].isNotEmpty ? 40 : 0,
                                              child: ListView.builder(
                                                itemCount: resProvider.digitalVariationExtantion[index].length,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(Dimensions.paddingSizeVeryTiny),
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeMedium),
                                                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                                      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.20),
                                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                                      ),
                                                      child: Row(children: [
                                                        Consumer<SplashController>(builder: (ctx, colorP,child){
                                                          return Text(resProvider.digitalVariationExtantion[index][i],
                                                            style: robotoRegular.copyWith(color: ColorResources.titleColor(context)),);
                                                        }),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                                        InkWell(
                                                          splashColor: Colors.transparent,
                                                          onTap: (){
                                                            resProvider.removeExtension(index, i);
                                                          },
                                                          child: Icon(Icons.close, size: 15, color: ColorResources.titleColor(context)),
                                                        ),
                                                      ]),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ):const SizedBox(),

                                            const SizedBox(height: Dimensions.paddingSizeSmall)
                                          ],
                                        ),
                                      ),





                                      ]
                                  );
                                },
                              ),

                              Provider.of<SplashController>(context, listen: false).configModel!.digitalProductSetting == "1" && resProvider.selectedDigitalVariation.isEmpty?
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: DigitalProductWidget(resProvider: resProvider, product: widget.product, fromNextScreen: true)):const SizedBox(),

                              showUploadFile ?
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: AddProductSectionWidget(
                                  title: getTranslated('file_upload', context)!,
                                  childrens: [

                                    ListView.builder(
                                      itemCount: resProvider.selectedDigitalVariation.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ListView.builder(
                                          itemCount: resProvider.variationFileList[index].length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                                  color: Theme.of(context).primaryColor.withOpacity(0.10),
                                                ),
                                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                                child: Column(
                                                  children: [
                                                    Text('${resProvider.selectedDigitalVariation[index]}-${resProvider.digitalVariationExtantion[index][i]} ${getTranslated('file', context)!}',
                                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)
                                                    ),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                                    Row(children: [
                                                      Expanded(
                                                        child: CustomTextFieldWidget(
                                                          border: true,
                                                          controller: resProvider.variationFileList[index][i].priceController,
                                                          textInputAction: TextInputAction.done,
                                                          textInputType: TextInputType.number,
                                                          isAmount: false,
                                                          hintText: getTranslated('price', context)!,
                                                          onFieldSubmit: (String value) {
                                                            if(value.trim() != ''){
                                                              resProvider.addExtension(index, value);
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                                      Expanded(
                                                        child: CustomTextFieldWidget(
                                                          border: true,
                                                          controller: resProvider.variationFileList[index][i].skuController,
                                                          textInputAction: TextInputAction.done,
                                                          textInputType: TextInputType.text,
                                                          isAmount: false,
                                                          hintText: getTranslated('sku', context)!,
                                                          onFieldSubmit: (String value) {
                                                            if(value.trim() != ''){
                                                              resProvider.addExtension(index, value);
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ]
                                                    ),

                                                    resProvider.digitalProductTypeIndex == 1 ?
                                                    const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),


                                                    resProvider.digitalProductTypeIndex == 1 ? InkWell(
                                                      onTap: () {
                                                        resProvider.pickFileForDigitalProduct(index, i);
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                        decoration: BoxDecoration(
                                                          border:Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(.15)),
                                                          color: Theme.of(context).highlightColor,
                                                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                                        ),
                                                        child: Row(mainAxisAlignment: resProvider.variationFileList[index][i].fileName == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                                                          children: resProvider.variationFileList[index][i].fileName == null ? [

                                                            Image.asset(Images.uploadFileIcon, height: 20, width: 20),
                                                            const SizedBox(width: Dimensions.paddingSizeSmall),
                                                            Text(getTranslated('file_upload', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                                                          ] : [
                                                            Expanded(child: Text(resProvider.variationFileList[index][i].fileName ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor), overflow: TextOverflow.ellipsis)),
                                                            //deleteIcon

                                                            resProvider.isDigitalVariationLoading[index][i] ?
                                                            const SizedBox(height: 30, width: 30, child: CircularProgressIndicator()) :
                                                            InkWell(
                                                              onTap: (){
                                                                if(_update){
                                                                  resProvider.deleteDigitalVariationFile(_product!.id!, index, i);
                                                                } else {
                                                                  resProvider.removeFileForDigitalProduct(index, i);
                                                                }
                                                              },
                                                              child: Image.asset(Images.deleteIcon, height: 20, width: 20)
                                                            ),
                                                          ],
                                                        ),

                                                      ),
                                                    ) : const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ) : const SizedBox(),
                            ],
                          ) : const SizedBox(),
                        ]): const Padding(padding: EdgeInsets.only(top: 300.0),
                         child: Center(child: CircularProgressIndicator())),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!,
                          spreadRadius: 0.5, blurRadius: 0.3)],
                    ),
                    height: 80,child: Row(children: [
                    Expanded(child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: (){
                        Navigator.pop(context);
                        resProvider.setSelectedPageIndex(0, isUpdate: true);
                      },
                      child: CustomButtonWidget(
                        isColor: true,
                        btnTxt: '${getTranslated('back', context)}',
                        backgroundColor: Theme.of(context).hintColor,),
                    )),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Consumer<AddProductController>(
                        builder: (context,resProvider, _) {
                          return resProvider.isLoading ? const Center(child: SizedBox(height: 35, width: 35, child: CircularProgressIndicator())) : CustomButtonWidget(
                            btnTxt:  getTranslated('next', context),
                            onTap: () {
                              bool digitalProductVariationEmpty = false;
                              bool isFileEmpty = false;
                              bool isPriceEmpty = false;
                              bool isSKUEmpty = false;
                              bool isTitleEmpty = false;

                              for (int index = 0; index < resProvider.selectedDigitalVariation.length; index++) {
                                if(resProvider.digitalVariationExtantion[index].isEmpty) {
                                  digitalProductVariationEmpty = true;
                                  break;
                                }
                              }

                              for (int index = 0; index < resProvider.selectedDigitalVariation.length; index++) {
                                  for(int i =0; i< resProvider.variationFileList[index].length; i++) {
                                    if(resProvider.variationFileList[index][i].file == null){
                                      isFileEmpty = true;
                                      break;
                                    }
                                  }
                              }

                              for (int index = 0; index < resProvider.selectedDigitalVariation.length; index++) {
                                for(int i =0; i< resProvider.variationFileList[index].length; i++) {
                                  if(resProvider.variationFileList[index][i].priceController?.text.trim() == ''){
                                    isPriceEmpty = true;
                                    break;
                                  }
                                }
                              }

                              for (int index = 0; index < resProvider.selectedDigitalVariation.length; index++) {
                                for(int i =0; i< resProvider.variationFileList[index].length; i++) {
                                  if(resProvider.variationFileList[index][i].skuController?.text.trim() == ''){
                                    isSKUEmpty = true;
                                    break;
                                  }
                                }
                              }

                              for (int index = 0; index < resProvider.selectedDigitalVariation.length; index++) {
                                for(int i =0; i< resProvider.variationFileList[index].length; i++) {
                                  if(resProvider.variationFileList[index][i].fileName == null){
                                    isTitleEmpty = true;
                                    break;
                                  }
                                }
                              }

                              // isTitleEmpty

                              String unitPrice =_unitPriceController.text.trim();
                              String currentStock = resProvider.totalQuantityController.text.trim();
                              String orderQuantity = _minimumOrderQuantityController.text.trim();
                              String tax = _taxController.text.trim();
                              String discount = _discountController.text.trim();
                              String shipping = _shippingCostController.text.trim();
                              bool haveBlankVariant = false;
                              bool blankVariantPrice = false;
                              bool blankVariantQuantity = false;
                              for (AttributeModel attr in resProvider.attributeList!) {
                                if (attr.active && attr.variants.isEmpty) {
                                  haveBlankVariant = true;
                                  break;
                                }
                              }

                              for (VariantTypeModel variantType in resProvider.variantTypeList) {
                                if (variantType.controller.text.isEmpty) {
                                  blankVariantPrice = true;
                                  break;
                                }
                              }
                              for (VariantTypeModel variantType in resProvider.variantTypeList) {
                                if (variantType.qtyController.text.isEmpty) {
                                  blankVariantQuantity = true;
                                  break;
                                }
                              }
                              if (unitPrice.isEmpty) {
                                showCustomSnackBarWidget(getTranslated('enter_unit_price', context),context,  sanckBarType: SnackBarType.warning);
                              }

                              else if (currentStock.isEmpty &&  resProvider.productTypeIndex == 0) {
                                showCustomSnackBarWidget(getTranslated('enter_total_quantity', context),context,  sanckBarType: SnackBarType.warning);
                              }
                              else if (orderQuantity.isEmpty) {
                                showCustomSnackBarWidget(getTranslated('enter_minimum_order_quantity', context),context,  sanckBarType: SnackBarType.warning);
                              }
                              else if (haveBlankVariant) {
                                showCustomSnackBarWidget(getTranslated('add_at_least_one_variant_for_every_attribute',context),context,  sanckBarType: SnackBarType.warning);
                              } else if (blankVariantPrice) {
                                showCustomSnackBarWidget(getTranslated('enter_price_for_every_variant', context),context,  sanckBarType: SnackBarType.warning);
                              }else if (blankVariantQuantity) {
                                showCustomSnackBarWidget(getTranslated('enter_quantity_for_every_variant', context),context,  sanckBarType: SnackBarType.warning);
                              } else if (resProvider.productTypeIndex == 0 && _shippingCostController.text.isEmpty) {
                                showCustomSnackBarWidget(getTranslated('enter_shipping_cost', context),context,  sanckBarType: SnackBarType.warning);
                              } else if(_update && resProvider.productTypeIndex == 1 && resProvider.digitalProductTypeIndex == 1 && isTitleEmpty) {
                                showCustomSnackBarWidget(getTranslated('digital_product_file_empty', context),context,  sanckBarType: SnackBarType.warning);
                              } else if(!_update && resProvider.productTypeIndex == 1 && resProvider.digitalProductTypeIndex == 1 && isFileEmpty) {
                                showCustomSnackBarWidget(getTranslated('digital_product_file_empty', context),context,  sanckBarType: SnackBarType.warning);
                              } else if(resProvider.productTypeIndex == 1 && isPriceEmpty) {
                                showCustomSnackBarWidget(getTranslated('digital_product_price_empty', context),context,  sanckBarType: SnackBarType.warning);
                              } else if(resProvider.productTypeIndex == 1 && isSKUEmpty) {
                                showCustomSnackBarWidget(getTranslated('digital_product_sku_empty', context),context,  sanckBarType: SnackBarType.warning);
                              } else if(resProvider.productTypeIndex == 1 && digitalProductVariationEmpty) {
                                showCustomSnackBarWidget(getTranslated('digital_product_variation_empty', context),context,  sanckBarType: SnackBarType.warning);
                              } else if ((resProvider.productTypeIndex == 1 &&resProvider.digitalProductTypeIndex == 1 &&
                                  resProvider.selectedFileForImport == null) && widget.product == null && resProvider.selectedDigitalVariation.isEmpty) {
                                showCustomSnackBarWidget(getTranslated('please_choose_digital_product',context),context,  sanckBarType: SnackBarType.warning);
                              }
                              // else if (resProvider.productTypeIndex == 0 &&  int.parse(_shippingCostController.text) <=0) {
                              //   showCustomSnackBarWidget(getTranslated('shipping_cost_must_be_gater_then', context),context,  sanckBarType: SnackBarType.warning);
                              // }
                              else {
                                if(resProvider.productTypeIndex == 1 &&resProvider.digitalProductTypeIndex == 1 &&
                                    resProvider.selectedFileForImport != null && resProvider.selectedDigitalVariation.isEmpty) {
                                  resProvider.uploadDigitalProduct(Provider.of<AuthController>(context,listen: false).getUserToken());
                                }
                                resProvider.setSelectedPageIndex(2, isUpdate: true);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => AddProductSeoScreen(
                                  unitPrice: unitPrice,
                                  tax: tax,
                                  unit: widget.unit,
                                  categoryId: widget.categoryId,
                                  subCategoryId: widget.subCategoryId,
                                  subSubCategoryId: widget.subSubCategoryId,
                                  brandyId: widget.brandId,
                                  discount: discount,
                                  currentStock: currentStock,
                                  minimumOrderQuantity: orderQuantity,
                                  shippingCost: shipping,
                                  product: widget.product, addProduct: widget.addProduct)));
                              }
                            },
                          );
                        }
                    )),
                  ],),)

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
