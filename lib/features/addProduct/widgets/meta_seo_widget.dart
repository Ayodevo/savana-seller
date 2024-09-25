import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class MetaSeoWidget extends StatelessWidget {
  const MetaSeoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
        builder: (context, resProvider, child){
        return Column(
          children: [


            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.50))
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MetaSeoItem(
                        title: 'index',
                        value: resProvider.metaSeoInfo?.metaIndex == '1' ? true : false,
                        callback: (bool? value){
                          resProvider.metaSeoInfo!.metaIndex = value == true ? '1' : '0';
                          resProvider.updateState();
                        },
                      ),

                      MetaSeoItem(
                        title: 'no_follow',
                        value: resProvider.metaSeoInfo?.metaNoFollow == '1' ? true : false,
                        callback: (bool? value){
                          resProvider.metaSeoInfo!.metaNoFollow = value == true ? '1' : '0';
                          resProvider.updateState();
                        },
                      ),

                      MetaSeoItem(
                        title: 'no_image_index',
                        value: resProvider.metaSeoInfo?.metaNoImageIndex == '1' ? true : false,
                        callback: (bool? value){
                          resProvider.metaSeoInfo!.metaNoImageIndex = value == true ? '1' : '0';
                          resProvider.updateState();
                        },
                      ),

                    ],
                  )),

                  Expanded(child: Column(
                    children: [

                      MetaSeoItem(
                        title: 'no_archive',
                        value: resProvider.metaSeoInfo?.metaNoArchive == '1' ? true : false,
                        callback: (bool? value){
                          resProvider.metaSeoInfo!.metaNoArchive = value == true ? '1' : '0';
                          resProvider.updateState();
                        },
                      ),

                      MetaSeoItem(
                        title: 'no_snippet',
                        value: resProvider.metaSeoInfo?.metaNoSnippet == '1' ? true : false,
                        callback: (bool? value){
                          resProvider.metaSeoInfo!.metaNoSnippet = value == true ? '1' : '0';
                          resProvider.updateState();
                        },
                      ),

                    ],
                  )),

                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),


            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.50))
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 3,child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MetaSeoItem(
                      title: 'max_snippet',
                      value: resProvider.metaSeoInfo?.metaMaxSnippet == '1' ? true : false,
                      callback: (bool? value){
                        resProvider.metaSeoInfo!.metaMaxSnippet = value == true ? '1' : '0';
                        resProvider.updateState();
                      },
                    ),

                    MetaSeoItem(
                      title: 'max_video_preview',
                      value: resProvider.metaSeoInfo?.metaMaxVideoPreview == '1' ? true : false,
                      callback: (bool? value){
                        resProvider.metaSeoInfo!.metaMaxVideoPreview = value == true ? '1' : '0';
                        resProvider.updateState();
                      },
                    ),

                    MetaSeoItem(
                      title: 'max_image_preview',
                      value: resProvider.metaSeoInfo?.metaMaxImagePreview == '1' ? true : false,
                      callback: (bool? value){
                        resProvider.metaSeoInfo!.metaMaxImagePreview = value == true ? '1' : '0';
                        resProvider.updateState();
                      },
                    ),
                  ],
                )),

                Expanded( flex: 2, child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: SizedBox( height: 30,
                        child: CustomTextFieldWidget(
                          textInputType: TextInputType.number,
                          controller: resProvider.maxSnippetController,
                          onChanged: (value){
                            resProvider.metaSeoInfo?.metaMaxVideoPreviewValue = value;
                            resProvider.updateState();
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: SizedBox( height: 30,
                        child: CustomTextFieldWidget(
                          textInputType: TextInputType.number,
                          controller: resProvider.maxImagePreviewController,
                          onChanged: (value){
                            resProvider.metaSeoInfo?.metaMaxVideoPreviewValue = value;
                            resProvider.updateState();
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        ),
                        child: DropdownButton<String>(
                          value: resProvider.imagePreviewSelectedType,
                          items: resProvider.imagePreviewType.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(getTranslated(value, context)!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            resProvider.setImagePreviewType(value!, true);
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
              ),
            )
          ]
        );
      }
    );
  }
}




class MetaSeoItem extends StatelessWidget {
  String title;
  bool value;
  final Function(bool?) callback;

  MetaSeoItem({super.key, required this.title, required this.value, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: Dimensions.paddingSizeDefault, width: Dimensions.paddingSizeDefault,
          child: Checkbox(
            checkColor: Theme.of(context).cardColor,
            value: value,
            onChanged: callback,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Text(getTranslated(title, context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
      ]),
    );
  }
}

