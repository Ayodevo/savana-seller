import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class DeleteAccountWarningDialogWidget extends StatelessWidget {
const DeleteAccountWarningDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.getBottomSheetColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 30),
                SizedBox(width: 52,height: 52,
                  child: Image.asset(Images.accountDeleteWarning),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeLarge, 13, Dimensions.paddingSizeLarge, 0),
                  child: Text(getTranslated('warning', context)!,
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      textAlign: TextAlign.center),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeLarge, 13, Dimensions.paddingSizeLarge,0),
                  child: Text(getTranslated('please_check_before_delete_your', context)!,
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                      textAlign: TextAlign.center),
                ),

                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SizedBox(width: 18,child: Image.asset(Images.cross, color: ColorResources.getTextColor(context))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
