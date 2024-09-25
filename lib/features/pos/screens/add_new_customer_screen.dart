import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/customer_body.dart';
import 'package:sixvalley_vendor_app/helper/email_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/auth/widgets/code_picker_widget.dart';

class AddNewCustomerScreen extends StatefulWidget {
  const AddNewCustomerScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCustomerScreen> createState() => _AddNewCustomerScreenState();
}

class _AddNewCustomerScreenState extends State<AddNewCustomerScreen> {

  final TextEditingController _fName = TextEditingController();
  final TextEditingController _lName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _zipCode = TextEditingController();
  final TextEditingController _address = TextEditingController();


  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _countryNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _zipCodeNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  String? _countryDialCode = "+880";
  @override
  void initState() {
    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashController>(context, listen: false).configModel!.countryCode!).dialCode;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('add_new_customer', context), isBackButtonExist: true),
      body: Consumer<CartController>(
        builder: (context,customerProvider,_) {
          return Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Container(
                        margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall),
                        child: CustomTextFieldWidget(
                          border: true,
                          hintText: getTranslated('first_name', context),
                          focusNode: _fNameNode,
                          nextNode: _lNameNode,
                          textInputType: TextInputType.name,
                          controller: _fName,
                          textInputAction: TextInputAction.next,
                        )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                        margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall),
                        child: CustomTextFieldWidget(
                          border: true,
                          hintText: getTranslated('last_name', context),
                          focusNode: _lNameNode,
                          nextNode: _emailNode,
                          textInputType: TextInputType.name,
                          controller: _lName,
                          textInputAction: TextInputAction.next,
                        )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    Container(
                        margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall),
                        child: CustomTextFieldWidget(
                          border: true,
                          hintText: getTranslated('email_address', context),
                          focusNode: _emailNode,
                          nextNode: _phoneNode,
                          textInputType: TextInputType.name,
                          controller: _email,
                          textInputAction: TextInputAction.next,
                        )),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        CodePickerWidget(
                          onChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode;
                          },
                          initialSelection: _countryDialCode,
                          favorite: [_countryDialCode!],
                          showDropDownButton: true,
                          padding: EdgeInsets.zero,
                          showFlagMain: true,
                          textStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),
                        ),


                        Expanded(child: CustomTextFieldWidget(
                          hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
                          controller: _phone,
                          focusNode: _phoneNode,
                          nextNode: _countryNode,
                          isPhoneNumber: true,
                          border: true,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.phone,

                        )),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                        margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall),
                        child: CustomTextFieldWidget(
                          border: true,
                          hintText: getTranslated('country', context),
                          focusNode: _countryNode,
                          nextNode: _cityNode,
                          textInputType: TextInputType.name,
                          controller: _country,
                          textInputAction: TextInputAction.next,
                        )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                        margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall),
                        child: CustomTextFieldWidget(
                          border: true,
                          hintText: getTranslated('city', context),
                          focusNode: _cityNode,
                          nextNode: _zipCodeNode,
                          textInputType: TextInputType.name,
                          controller: _city,
                          textInputAction: TextInputAction.next,
                        )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                        margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall),
                        child: CustomTextFieldWidget(
                          border: true,
                          hintText: getTranslated('zip_code', context),
                          focusNode: _zipCodeNode,
                          nextNode: _addressNode,
                          textInputType: TextInputType.name,
                          controller: _zipCode,
                          textInputAction: TextInputAction.next,
                        )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                        margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                            bottom: Dimensions.paddingSizeSmall),
                        child: CustomTextFieldWidget(
                          border: true,
                          hintText: getTranslated('address', context),
                          focusNode: _addressNode,
                          textInputType: TextInputType.name,
                          controller: _address,
                          textInputAction: TextInputAction.done,
                        )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ],
                ),
              )
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child:customerProvider.isLoading?const CircularProgressIndicator():
              CustomButtonWidget(btnTxt: getTranslated('add', context),
                onTap: (){
                String firstName = _fName.text.trim();
                String lastName = _lName.text.trim();
                String email = _email.text.trim();
                String phone =  _phone.text.trim();
                String country = _country.text.trim();
                String city = _city.text.trim();
                String zip = _zipCode.text.trim();
                String address = _address.text.trim() ;

                if(firstName.isEmpty){
                  showCustomSnackBarWidget(getTranslated('first_name_is_required', context), context,  sanckBarType: SnackBarType.warning);
                }else if(lastName.isEmpty){
                  showCustomSnackBarWidget(getTranslated('last_name_is_required', context), context, sanckBarType: SnackBarType.warning);
                }else if(email.isEmpty){
                  showCustomSnackBarWidget(getTranslated('email_is_required', context), context, sanckBarType: SnackBarType.warning);
                }else if(email.isEmpty){
                  showCustomSnackBarWidget(getTranslated('email_name_is_required', context), context, sanckBarType: SnackBarType.warning);
                }else if (EmailChecker.isNotValid(email)) {
                  showCustomSnackBarWidget(getTranslated('email_is_ot_valid', context), context, sanckBarType: SnackBarType.warning);
                }else if(phone.isEmpty){
                  showCustomSnackBarWidget(getTranslated('phone_is_required', context), context, sanckBarType: SnackBarType.warning );
                }else if(country.isEmpty){
                  showCustomSnackBarWidget(getTranslated('country_is_required', context), context, sanckBarType: SnackBarType.warning);
                }else if(city.isEmpty){
                  showCustomSnackBarWidget(getTranslated('city_is_required', context), context, sanckBarType: SnackBarType.warning);
                }else if(zip.isEmpty){
                  showCustomSnackBarWidget(getTranslated('zip_is_required', context), context, sanckBarType: SnackBarType.warning);
                }else if(address.isEmpty){
                  showCustomSnackBarWidget(getTranslated('address_is_required', context), context, sanckBarType: SnackBarType.warning);
                }else{
                  phone = _countryDialCode! + phone;
                  CustomerBody customerBody = CustomerBody(
                    fName :  firstName,
                    lName: lastName,
                    email: email,
                    phone: phone,
                    country: country,
                    city: city,
                    zipCode: zip,
                    address: address

                  );
                  customerProvider.addNewCustomer(context, customerBody);
                }},),
            )
          ]);
        }
      ),
    );
  }
}
