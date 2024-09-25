import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';



class DigitalProductWidget extends StatefulWidget {
  final AddProductController? resProvider;
  final Product? product;
  final bool fromNextScreen;
  const DigitalProductWidget({Key? key, this.resProvider, this.product, this.fromNextScreen = false}) : super(key: key);

  @override
  State<DigitalProductWidget> createState() => _DigitalProductWidgetState();
}

class _DigitalProductWidgetState extends State<DigitalProductWidget> {
  PlatformFile? fileNamed;
  File? file;
  int?  fileSize;


  @override
  Widget build(BuildContext context) {

    return Column(children: [
      !widget.fromNextScreen ?
      Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(getTranslated('product_type', context)!,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context))),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

            ),
            child: DropdownButton<String>(
              value: widget.resProvider!.productTypeIndex == 0 ? 'physical' : 'digital',
              items: <String>['physical', 'digital'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(getTranslated(value, context)!),
                );
              }).toList(),
              onChanged: (value) {
                widget.resProvider!.setProductTypeIndex(value == 'physical' ? 0 : 1, true);
              },
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
        ]),
      ) : const SizedBox(),

      !widget.fromNextScreen ?
      SizedBox(height: widget.resProvider!.productTypeIndex == 1? Dimensions.paddingSizeSmall : 0) : const SizedBox(),


      !widget.fromNextScreen  && widget.resProvider!.productTypeIndex == 1 ?
      Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(getTranslated('digital_product_type', context)!,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.titleColor(context)),),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

            ),
            child: DropdownButton<String>(
              value: widget.resProvider!.digitalProductTypeIndex == 0 ? 'ready_after_sell' : 'ready_product',
              items: <String>['ready_after_sell', 'ready_product'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(getTranslated(value, context)!)
                );
              }).toList(),
              onChanged: (value) {
                widget.resProvider!.setDigitalProductTypeIndex(value == 'ready_after_sell' ? 0 : 1, true);
              },
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
        ]),
      ):const SizedBox(),
      //!widget.fromNextScreen ?
      // SizedBox(height: widget.resProvider!.productTypeIndex == 1?Dimensions.paddingSizeSmall : 0) : const SizedBox(),

      widget.fromNextScreen && widget.resProvider!.productTypeIndex == 1 && widget.resProvider!.digitalProductTypeIndex == 1?
      Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0),
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: ()async{
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'zip', 'jpg', 'png', "jpeg", "gif"],
              );
              if (result != null) {
                file = File(result.files.single.path!);
                fileSize = await file!.length();
                fileNamed = result.files.first;
                widget.resProvider!.setSelectedFileName(file);

              } else {

              }
            },
            child: Builder(
                builder: (context) {
                  return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 50,child: Image.asset(Images.upload)),
                      widget.resProvider!.selectedFileForImport !=null ?
                      Text(fileNamed != null? fileNamed?.name??'':'${widget.product!.digitalFileReady}',maxLines: 2,overflow: TextOverflow.ellipsis):
                      Text(getTranslated('upload_file', context)!, style: robotoRegular.copyWith()),

                      widget.product !=null && fileNamed == null ?
                      Text(widget.product!.digitalFileReady??'', style: robotoRegular.copyWith()):const SizedBox(),

                    ],);
                }
            ),
          ),
        ),
      ):const SizedBox(),

      widget.fromNextScreen ?
      const SizedBox(height: Dimensions.paddingSizeDefault) : const SizedBox(),

    ]);
  }
}
