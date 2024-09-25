import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/category_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class CategoryFilterBottomSheetWidget extends StatelessWidget {
  const CategoryFilterBottomSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
      builder: (context, categoryProvider, _) {
        List<CategoryModel>? categoryList =[];
        categoryList = categoryProvider.categoryList;
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                topRight: Radius.circular(Dimensions.paddingSizeSmall),
              )
          ),
          child:

          Column( mainAxisSize: MainAxisSize.min,
            children: [
              Text(getTranslated('category_wise_filter', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoryList!.length,
                        itemBuilder: (context, index){
                          return Row(children: [
                            Checkbox(value: categoryProvider.selectedCategory[index],
                                onChanged: (onChanged){
                                  categoryProvider.setSelectedCategoryForFilter(index, onChanged);
                                }),
                            Text(categoryList![index].name!),
                          ],);
                        }),
                    ],
                  ),
                ),
              ),



              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Consumer<ProductController>(
                  builder: (context, productProvider, _) {
                    List<String> ids = [];
                    return Positioned(bottom: 10,left: 10,right: 10,
                        child: CustomButtonWidget(btnTxt: getTranslated('search', context),
                          onTap: (){

                            if(categoryProvider.selectedCategory.isNotEmpty){
                              for(int i=0; i< categoryProvider.selectedCategory.length; i++){
                                if(categoryProvider.selectedCategory[i]!){
                                  ids.add(categoryList![i].id.toString());
                                }
                              }
                              Navigator.pop(context);
                              Provider.of<ProductController>(context, listen: false).getPosProductList(1, context,ids);
                            }else{
                              showCustomSnackBarWidget(getTranslated('please_select_a_category_to_filter', context), context, isToaster: true);
                            }},));
                  }
                ),
              )



            ],
          ),
        );
      }
    );
  }
}
