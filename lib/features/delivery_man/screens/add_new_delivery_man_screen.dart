
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/delivery_man_body.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/helper/email_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/delivery_man_setup_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/delivery_man_info_widget.dart';

class AddNewDeliveryManScreen extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  const AddNewDeliveryManScreen({Key? key, this.deliveryMan}) : super(key: key);

  @override
  State<AddNewDeliveryManScreen> createState() => _AddNewDeliveryManScreenState();
}

class _AddNewDeliveryManScreenState extends State<AddNewDeliveryManScreen> with TickerProviderStateMixin{
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<DeliveryManController>(context, listen: false).setIndexForTabBar(1, isNotify: false);
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    if (Provider.of<AuthController>(context, listen: false).showPassView) {
      Provider.of<AuthController>(context, listen: false).showHidePass(isUpdate: false);
    }


    _tabController?.addListener((){
      switch (_tabController!.index){
        case 0:
          Provider.of<DeliveryManController>(context, listen: false).setIndexForTabBar(1, isNotify: true);
          break;
        case 1:
          Provider.of<DeliveryManController>(context, listen: false).setIndexForTabBar(0, isNotify: true);
          break;
      }
    });

    if(widget.deliveryMan != null){
      Provider.of<DeliveryManController>(context, listen: false).firstNameController.text = widget.deliveryMan!.fName!;
      Provider.of<DeliveryManController>(context, listen: false).lastNameController.text = widget.deliveryMan!.lName!;
      Provider.of<DeliveryManController>(context, listen: false).emailController.text = widget.deliveryMan!.email!;
      Provider.of<DeliveryManController>(context, listen: false).phoneController.text = widget.deliveryMan!.phone!;
      Provider.of<DeliveryManController>(context, listen: false).addressController.text = widget.deliveryMan!.address ?? '';
      Provider.of<DeliveryManController>(context, listen: false).identityNumber.text = widget.deliveryMan!.identityNumber!;
      Provider.of<DeliveryManController>(context, listen: false).passwordController.text = '';
      Provider.of<DeliveryManController>(context, listen: false).confirmPasswordController.text = '';
    }
    else{
      Provider.of<DeliveryManController>(context, listen: false).firstNameController.clear();
      Provider.of<DeliveryManController>(context, listen: false).lastNameController.clear();
      Provider.of<DeliveryManController>(context, listen: false).emailController.clear();
      Provider.of<DeliveryManController>(context, listen: false).phoneController.clear();
      Provider.of<DeliveryManController>(context, listen: false).addressController.clear();
      Provider.of<DeliveryManController>(context, listen: false).identityNumber.clear();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: getTranslated('add_delivery_man', context), isBackButtonExist: true),

      body: Consumer<DeliveryManController>(
          builder: (authContext,deliveryManProvider, _) {
            return Column( children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).cardColor,
                  child: TabBar(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).hintColor,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 1,
                    unselectedLabelStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w400,
                    ),
                    labelStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: [
                      Tab(text: getTranslated("delivery_man_info", context)),
                      Tab(text: getTranslated("account_info", context)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall,),
              Expanded(child: TabBarView(
                controller: _tabController,
                children: [
                  DeliveryManInfoWidget(deliveryMan: widget.deliveryMan),
                  DeliveryManInfoWidget(isPassword : true,deliveryMan: widget.deliveryMan),
                ],
              )),
            ]);
          }
      ),

      bottomNavigationBar: Consumer<DeliveryManController>(
          builder: (context, deliveryManProvider, _) {
            return Consumer<AuthController>(
              builder: (context, authController, _) {
                return Column(mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                        child: LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width,
                            lineHeight: 4.0,
                            percent: deliveryManProvider.selectionTabIndex ==1?0.5:0.9,
                            backgroundColor: Theme.of(context).hintColor,
                            progressColor: Theme.of(context).primaryColor)),
                    Container(height: 70,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor
                      ),
                      child:(deliveryManProvider.selectionTabIndex ==1)?

                      CustomButtonWidget(btnTxt: getTranslated('next', context), onTap: (){
                        if(deliveryManProvider.firstNameController.text.trim().isEmpty){
                          showCustomSnackBarWidget(getTranslated('first_name_is_required', context), context);
                        }else if(deliveryManProvider.lastNameController.text.trim().isEmpty){
                          showCustomSnackBarWidget(getTranslated('last_name_is_required', context), context);
                        }else if(deliveryManProvider.emailController.text.trim().isEmpty){
                          showCustomSnackBarWidget(getTranslated('email_is_required', context), context);
                        }
                        else if (EmailChecker.isNotValid(deliveryManProvider.emailController.text.trim())) {
                          showCustomSnackBarWidget(getTranslated('email_is_ot_valid', context), context);
                        }else if(deliveryManProvider.phoneController.text.trim().isEmpty){
                          showCustomSnackBarWidget(getTranslated('phone_is_required', context), context);
                        }
                        else if(deliveryManProvider.phoneController.text.trim().length < 8){
                          showCustomSnackBarWidget(getTranslated('phone_number_is_not_valid', context), context);
                        }

                        else if(deliveryManProvider.profileImage == null && widget.deliveryMan == null){
                          showCustomSnackBarWidget(getTranslated('profile_image_is_required', context), context);
                        }
                        else if(deliveryManProvider.identityNumber.text.trim().isEmpty){
                          showCustomSnackBarWidget(getTranslated('identity_number_is_required', context), context);
                        }else if(deliveryManProvider.identityImages.isEmpty && widget.deliveryMan == null){
                          showCustomSnackBarWidget(getTranslated('identity_image_is_required', context), context);
                        }
                        else{
                          _tabController!.animateTo((_tabController!.index + 1) % 2);
                          selectedIndex = _tabController!.index + 1;
                          deliveryManProvider.setIndexForTabBar(selectedIndex);
                        }
                      },):

                      Row(children: [
                          SizedBox(width: 120,
                            child: CustomButtonWidget(btnTxt: getTranslated('back', context),
                              backgroundColor: Theme.of(context).hintColor,
                              isColor: true,
                              onTap: (){
                                _tabController!.animateTo((_tabController!.index + 1) % 2);
                                selectedIndex = _tabController!.index + 1;
                                deliveryManProvider.setIndexForTabBar(selectedIndex);
                              },),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(child: deliveryManProvider.isLoading? const Center(child: CircularProgressIndicator()):
                            CustomButtonWidget(btnTxt: getTranslated('submit', context), onTap:(){
                              if(deliveryManProvider.firstNameController.text.trim().isEmpty && widget.deliveryMan == null){
                                showCustomSnackBarWidget(getTranslated('first_name_is_required', context), context, sanckBarType: SnackBarType.warning);
                              }else if(deliveryManProvider.lastNameController.text.trim().isEmpty && widget.deliveryMan == null){
                                showCustomSnackBarWidget(getTranslated('last_name_is_required', context), context,sanckBarType: SnackBarType.warning);
                              }else if(deliveryManProvider.emailController.text.trim().isEmpty && widget.deliveryMan == null){
                                showCustomSnackBarWidget(getTranslated('email_is_required', context), context, sanckBarType: SnackBarType.warning);
                              }
                              else if (EmailChecker.isNotValid(deliveryManProvider.emailController.text.trim()) && widget.deliveryMan == null) {
                                showCustomSnackBarWidget(getTranslated('email_is_ot_valid', context), context, sanckBarType: SnackBarType.warning);
                              }else if(deliveryManProvider.phoneController.text.trim().isEmpty && widget.deliveryMan == null){
                                showCustomSnackBarWidget(getTranslated('phone_is_required', context), context, sanckBarType: SnackBarType.warning);
                              }
                              else if(deliveryManProvider.phoneController.text.trim().length<8){
                                showCustomSnackBarWidget(getTranslated('phone_number_is_not_valid', context), context, sanckBarType: SnackBarType.warning);
                              }else if(deliveryManProvider.passwordController.text.trim().isEmpty && widget.deliveryMan == null){
                                showCustomSnackBarWidget(getTranslated('password_is_required', context), context, sanckBarType: SnackBarType.warning);
                              }
                              else if(deliveryManProvider.passwordController.text.trim().length<8 && widget.deliveryMan == null){
                                showCustomSnackBarWidget(getTranslated('password_minimum_length_is_6', context), context, sanckBarType: SnackBarType.warning);
                              }
                              else if(deliveryManProvider.confirmPasswordController.text.trim().isEmpty && widget.deliveryMan == null){
                                showCustomSnackBarWidget(getTranslated('confirm_password_is_required', context), context, sanckBarType: SnackBarType.warning);
                              }else if(deliveryManProvider.passwordController.text.trim() != deliveryManProvider.confirmPasswordController.text.trim()){
                                showCustomSnackBarWidget(getTranslated('password_is_mismatch', context), context , sanckBarType: SnackBarType.warning);
                              } else if (deliveryManProvider.passwordController.text.trim().isNotEmpty && !authController.isPasswordValid()) {
                                showCustomSnackBarWidget(getTranslated('enter_valid_password', context), context, sanckBarType: SnackBarType.warning);
                              } else if(deliveryManProvider.identityNumber.text.trim().isEmpty){
                                showCustomSnackBarWidget(getTranslated('identity_number_is_required', context), context, sanckBarType: SnackBarType.warning);
                              }else if(deliveryManProvider.identityImages.isEmpty && widget.deliveryMan == null){
                                showCustomSnackBarWidget(getTranslated('identity_image_is_required', context), context, sanckBarType: SnackBarType.warning);
                              }else{
                                DeliveryManBody deliveryManBody =  DeliveryManBody(
                                  id: widget.deliveryMan != null ?widget.deliveryMan!.id : 0,
                                    fName: deliveryManProvider.firstNameController.text.trim(),
                                    lName: deliveryManProvider.lastNameController.text.trim(),
                                    address: deliveryManProvider.addressController.text.trim(),
                                    phone: deliveryManProvider.phoneController.text.trim(),
                                    email: deliveryManProvider.emailController.text.trim(),
                                    countryCode: deliveryManProvider.countryDialCode?.substring(1),
                                    identityNumber: deliveryManProvider.identityNumber.text.trim(),
                                    identityType: deliveryManProvider.identityType,
                                    password: deliveryManProvider.passwordController.text.trim(),
                                    confirmPassword: deliveryManProvider.confirmPasswordController.text.trim());
                                deliveryManProvider.addNewDeliveryMan(context, deliveryManBody, isUpdate: widget.deliveryMan != null).then((value){
                                  if(value.isSuccess){
                                    _tabController!.animateTo((_tabController!.index + 1) % 2);
                                    selectedIndex = _tabController!.index + 1;
                                    deliveryManProvider.setIndexForTabBar(selectedIndex);
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (BuildContext context) => const DeliveryManSetupScreen()));
                                  }
                                });
                              }
                            },),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            );
          }
      ),
    );
  }
}
