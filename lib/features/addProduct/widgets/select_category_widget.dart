import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Product? product;
  const SelectCategoryWidget({Key? key, required this.product}) : super(key: key);

  @override
  SelectCategoryWidgetState createState() => SelectCategoryWidgetState();
}

class SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    log("category section===>");
    return Consumer<AddProductController>(
      builder: (context, resProvider, child){
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(children: [
                Text(getTranslated('select_category', context)!,style: robotoRegular.copyWith(
                    color: ColorResources.titleColor(context),
                    fontSize: Dimensions.fontSizeDefault)),
                Text('*',style: robotoBold.copyWith(color: ColorResources.mainCardFourColor(context),
                    fontSize: Dimensions.fontSizeDefault),),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            resProvider.categoryList != null ?
            Container(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.7)),
              ),
              child: DropdownButton<int>(
                value: resProvider.categoryIndex,
                items: resProvider.categoryIds.map((int? value) {
                  return DropdownMenuItem<int>(
                    value: resProvider.categoryIds.indexOf(value),
                    child: Text( value != 0?
                    resProvider.categoryList![(resProvider.categoryIds.indexOf(value) -1)].name!:
                    getTranslated('select_category', context)!),);}).toList(),
                onChanged: (int? value) {
                  resProvider.setCategoryIndex(value, true);
                  resProvider.getSubCategoryList(context, value != 0 ?
                  resProvider.categorySelectedIndex : 0, true, widget.product);},
                isExpanded: true, underline: const SizedBox())) :  const Center(child: CircularProgressIndicator()),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(children: [
              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('sub_category', context)!,style: robotoRegular.copyWith(
                      color: ColorResources.titleColor(context),
                      fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.7))),
                  child: DropdownButton<int>(
                    value: resProvider.subCategoryIndex,
                    items: resProvider.subCategoryIds.map((int? value) {
                      return DropdownMenuItem<int>(
                        value: resProvider.subCategoryIds.indexOf(value),
                        child: Text(value != 0 ?
                        resProvider.subCategoryList![(resProvider.subCategoryIds.indexOf(value) - 1)].name! :
                        getTranslated('select', context)!),
                      );}).toList(),
                    onChanged: (int? value) {
                      resProvider.setSubCategoryIndex(value, true);
                      resProvider.getSubSubCategoryList( value != 0 ? resProvider.subCategorySelectedIndex : 0, true);
                      },
                    isExpanded: true,
                    underline: const SizedBox(),
                  ),
                ),
              ],),),
              const SizedBox(width: Dimensions.paddingSizeDefault),



              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('sub_sub_category', context)!, style: robotoRegular.copyWith(
                      color: ColorResources.titleColor(context),
                      fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: Dimensions.paddingSizeSmall),


                Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.7)),),
                  child: DropdownButton<int>(
                    value: resProvider.subSubCategoryIndex,
                    items: resProvider.subSubCategoryIds.map((int? value) {
                      return DropdownMenuItem<int>(
                        value: resProvider.subSubCategoryIds.indexOf(value),
                        child: Text(value != 0 ?
                        resProvider.subSubCategoryList![(resProvider.subSubCategoryIds.indexOf(value)-1)].name! :
                        getTranslated('select', context)!),
                      );}).toList(),
                    onChanged: (int? value) {
                      resProvider.setSubSubCategoryIndex(value, true);
                      },
                    isExpanded: true,
                    underline: const SizedBox(),
                  ),
                ),
              ],
              ),
              ),

            ],),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],);
      },

    );
  }
}
