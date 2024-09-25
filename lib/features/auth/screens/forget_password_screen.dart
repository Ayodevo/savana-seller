import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/auth/widgets/my_dialog_widget.dart';
import 'package:sixvalley_vendor_app/features/auth/screens/otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppBarWidget(isBackButtonExist: true,title: getTranslated('forget_password', context),),

      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: SingleChildScrollView(
          child: Column( crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(height: 95),

              Image.asset(Images.forgotPasswordIcon, height: 100, width: 100),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Text('${getTranslated('forget_password', context)}?', style: robotoMedium),
              ),

              Provider.of<SplashController>(context,listen: false).configModel!.forgotPasswordVerification == "phone"?
              Text(getTranslated('enter_phone_number_for_password_reset', context)!,
                  style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeExtraSmall)):
              Text(getTranslated('enter_email_for_password_reset', context)!,
                  style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeDefault)),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Provider.of<SplashController>(context,listen: false).configModel!.forgotPasswordVerification == "phone"?
              CustomTextFieldWidget(
                border: true,
                hintText: getTranslated('number_hint', context),
                controller: _numberController,
                focusNode: _numberFocus,
                isPhoneNumber: true,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.phone,
              ) :

              CustomTextFieldWidget(
                border: true,
                prefixIconImage: Images.emailIcon,
                controller: _controller,
                hintText: getTranslated('ENTER_YOUR_EMAIL', context),
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.emailAddress,),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Consumer<AuthController>(
                builder: (context, authProvider,_) {
                  return !authProvider.isLoading ?
                  CustomButtonWidget( borderRadius: 10,
                    btnTxt: Provider.of<SplashController>(context,listen: false).configModel!.forgotPasswordVerification == "phone"?
                    getTranslated('send_otp', context):getTranslated('send_email', context),
                    onTap: () {
                      if(Provider.of<SplashController>(context,listen: false).configModel!.forgotPasswordVerification == "phone"){
                        if(_numberController.text.isEmpty) {
                          showCustomSnackBarWidget(getTranslated('PHONE_MUST_BE_REQUIRED', context), context, sanckBarType: SnackBarType.warning);
                        }else{

                          authProvider.forgotPassword(_numberController.text.trim()).then((value) {
                            if(value.isSuccess) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                  builder: (_) => VerificationScreen(_numberController.text.trim())), (route) => false);
                            }else {
                              showCustomSnackBarWidget(getTranslated('input_valid_phone_number', context), context,  sanckBarType: SnackBarType.warning);
                            }
                          });
                        }
                      }else{
                        if(_controller.text.isEmpty) {
                          showCustomSnackBarWidget(getTranslated('EMAIL_MUST_BE_REQUIRED', context), context,  sanckBarType: SnackBarType.warning);
                        }
                        else {
                          Provider.of<AuthController>(context, listen: false).forgotPassword(_controller.text).then((value) {
                            if(value.isSuccess) {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              _controller.clear();
                              showAnimatedDialogWidget(context, MyDialogWidget(
                                icon: Icons.send,
                                title: getTranslated('sent', context),
                                description: getTranslated('recovery_link_sent', context),
                                rotateAngle: 5.5,
                              ), dismissible: false);
                            }else {
                              showCustomSnackBarWidget(value.message, context,  sanckBarType: SnackBarType.success);
                            }
                          });
                        }
                      }
                    },
                  ) :
                  Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

