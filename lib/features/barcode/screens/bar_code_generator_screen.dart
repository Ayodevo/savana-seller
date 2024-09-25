import 'dart:async';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/barcode/controllers/barcode_controller.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_field_with_title_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:url_launcher/url_launcher.dart';


class BarCodeGenerateScreen extends StatefulWidget {
  final Product? product;
  const BarCodeGenerateScreen({Key? key, this.product}) : super(key: key);

  @override
  State<BarCodeGenerateScreen> createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  TextEditingController quantityController = TextEditingController();
  int barCodeQuantity = 4;

  @override
  void initState() {
    super.initState();
    quantityController.text = '4';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('bar_code_generator', context)),
      body: Consumer<BarcodeController>(
        builder: (context, barCodeController,_) {
          return Column(children: [
            Column(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: Column(children: [

                  Row(children: [
                    Text('${getTranslated('code', context)} : '),
                    Text('${widget.product!.code}', style: robotoRegular.copyWith(color: Theme.of(context).hintColor))],),

                  Row(children: [
                   Text('${getTranslated('product_name', context)} : '),
                   Expanded(
                     child: Text('${widget.product!.name}', maxLines: 2,overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                  )],),
              ],),),

              CustomFieldWithTitleWidget(
                isSKU: true,
                limitSet: true,
                setLimitTitle: getTranslated('maximum_quantity_270', context),
                customTextField: CustomTextFieldWidget(
                    isPhoneNumber: true,
                    controller: quantityController),
                title: '${getTranslated('qty', context)} (1-270)',
                requiredField: true,
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                const SizedBox(width: Dimensions.fontSizeSmall),
                Expanded(child: CustomButtonWidget(btnTxt: getTranslated('generate', context),
                onTap: (){
                  if(int.parse(quantityController.text)>270 || int.parse(quantityController.text) ==0){
                    showCustomSnackBarWidget(getTranslated('please_enter_from_1_to_270', context), context);
                  }else{
                   barCodeController.setBarCodeQuantity(int.parse(quantityController.text));
                  }})),
                const SizedBox(width: Dimensions.fontSizeSmall),

                Expanded(child: CustomButtonWidget(btnTxt: getTranslated('download', context),
                    onTap : () async {
                        barCodeController.barCodeDownload(Get.context!, widget.product!.id,int.parse( quantityController.text)).then((value) async {
                          _launchUrl(Uri.parse(barCodeController.printBarCode!));
                        });
                      })),

                const SizedBox(width: Dimensions.fontSizeSmall),

                Expanded(child: CustomButtonWidget(btnTxt: getTranslated('reset', context),onTap: (){
                  quantityController.text = '4';
                 barCodeController.setBarCodeQuantity(4);
                },
                backgroundColor: ColorResources.getRed(context),
                )),
                const SizedBox(width: Dimensions.fontSizeSmall),

              ],)
            ],),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: GridView.builder(
                itemCount: barCodeController.barCodeQuantity,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1/1.2,
                  ), itemBuilder: (barcode, index){
                    return Column(
                      children: [
                        Text(AppConstants.companyName,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                        Text('${widget.product!.name}', maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                        Text(PriceConverter.convertPrice(context, widget.product!.unitPrice)),
                        BarcodeWidget(
                          data: 'code : ${widget.product!.code}',style: robotoRegular.copyWith(),
                          barcode: Barcode.code128(),
                        )],);
                }),
            ))
          ],);
        }
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
