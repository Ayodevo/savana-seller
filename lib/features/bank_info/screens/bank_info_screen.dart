import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/bank_info/screens/bank_editing_screen.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';

import 'package:sixvalley_vendor_app/features/bank_info/widgets/bank_info_widget.dart';

class BankInfoScreen extends StatelessWidget {
  const BankInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<BankInfoController>(context, listen: false).setWarningValue(true,isUpdate: false);
    return Scaffold(
      appBar: CustomAppBarWidget(title:getTranslated('bank_info', context), isBackButtonExist: true,),
        body: Consumer<BankInfoController>(
          builder: (context, bankProvider, child) {
            String name = bankProvider.bankInfo!.holderName?? '';
            String bank = bankProvider.bankInfo!.bankName?? '';
            String branch = bankProvider.bankInfo!.branch?? '';
            String accountNo = bankProvider.bankInfo!.accountNo?? '';
            return Column(children: [

              bankProvider.showWarning?
                Padding(
                  padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeMedium),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                      border: Border.all(width: 0.5, color: Theme.of(context).primaryColor.withOpacity(0.20))
                    ),
                    child: Row( crossAxisAlignment:CrossAxisAlignment.center, children: [
                      SizedBox(width: 20, height: 20, child: Image.asset(Images.bulb)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Expanded(
                        child: Text(getTranslated('you_should_fill_up', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                          color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                          Theme.of(context).hintColor: Theme.of(context).primaryColor),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      InkWell(
                        onTap: () {
                          bankProvider.setWarningValue(false, isUpdate: true);
                        },
                        child: SizedBox(width: 20, height: 20, child: Image.asset(Images.crossIcon))),
                      ],
                    ),
                  ),
                ) : const SizedBox(),


              !bankProvider.showWarning ?
                  const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),

                GestureDetector(
                  onTap: ()=>Navigator.push(context,
                      MaterialPageRoute(builder: (_) => BankEditingScreen(sellerModel: bankProvider.bankInfo))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        border: Border.all(width: 0.5, color: Theme.of(context).primaryColor.withOpacity(0.20)),
                      ),
                      padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('edit_info', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                            color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                            Theme.of(context).hintColor: Theme.of(context).primaryColor)),
                        
                        SizedBox(height: 16, width: 16, child: Image.asset(Images.editIcon))
                      ],),
                    ),
                  ),
                ),

                BankInfoWidget(name: name,bank: bank,branch: branch,accountNo: accountNo,),
              ],
            );
          }
        ));
  }
}


