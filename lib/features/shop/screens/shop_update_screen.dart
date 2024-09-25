import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/shop_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';




class ShopUpdateScreen extends StatefulWidget {
  const ShopUpdateScreen({Key? key}) : super(key: key);

  @override
  ShopUpdateScreenState createState() => ShopUpdateScreenState();
}

class ShopUpdateScreenState extends State<ShopUpdateScreen> {

  final FocusNode _sNameFocus = FocusNode();
  final FocusNode _cNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();



  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    });
  }


  _updateShop() async {
    String shopName = _shopNameController.text.trim();
    String contactNumber = _contactNumberController.text.trim();
    String address = _addressController.text.trim();

    if(Provider.of<ShopController>(context, listen: false).shopModel!.name == _shopNameController.text
        && Provider.of<ShopController>(context, listen: false).shopModel!.contact == _contactNumberController.text
        && Provider.of<ShopController>(context, listen: false).shopModel!.address == _addressController.text && file == null &&
    Provider.of<AuthController>(context, listen: false).shopBanner == null &&
        Provider.of<AuthController>(context, listen: false).secondaryBanner == null &&
        Provider.of<AuthController>(context, listen: false).offerBanner == null) {
      showCustomSnackBarWidget(getTranslated('change_something_to_update', context), context, sanckBarType: SnackBarType.warning);
    }else if (shopName.isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_first_name', context), context, sanckBarType: SnackBarType.warning );
    }else if (contactNumber.isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_contact_number', context), context, sanckBarType: SnackBarType.warning);
    }else if (address.isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_address', context), context, sanckBarType: SnackBarType.warning);
    }else {
      ShopModel updateShopModel = Provider.of<ShopController>(context, listen: false).shopModel!;
      updateShopModel.name = _shopNameController.text;
      updateShopModel.contact = _contactNumberController.text;
      updateShopModel.address = _addressController.text;
      await Provider.of<ShopController>(context, listen: false).updateShopInfo(updateShopModel : updateShopModel, file : file);
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('shop_settings',context)),
      key: _scaffoldKey,
      body: Consumer<ShopController>(
        builder: (context, shop, child) {
          _shopNameController.text = shop.shopModel!.name!;
          _contactNumberController.text = shop.shopModel!.contact!;
          _addressController.text = shop.shopModel!.address!;

          return Consumer<AuthController>(
            builder: (context, authProvider, _) {
              return Column(children: [
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Expanded(child: Container(
                    decoration: BoxDecoration(color: ColorResources.getIconBg(context),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.paddingSizeDefault),
                          topRight: Radius.circular(Dimensions.paddingSizeDefault))),

                    child: ListView(
                      physics: const BouncingScrollPhysics(), children: [

                      Container(
                        margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault,
                            left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(getTranslated('shop_name', context)!, style: titilliumRegular),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextFieldWidget(
                              border: true,
                              isDescription: true,
                              textInputType: TextInputType.name,
                              focusNode: _sNameFocus,
                              nextNode: _cNumberFocus,
                              hintText: shop.shopModel!.name ?? '',
                              controller: _shopNameController),

                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Text(getTranslated('contact_number', context)!, style: titilliumRegular),

                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextFieldWidget(
                            border: true,
                            textInputType: TextInputType.number,
                            focusNode: _cNumberFocus,
                            nextNode: _addressFocus,
                            hintText: shop.shopModel!.contact,
                            controller: _contactNumberController,
                            isPhoneNumber: true,
                          ),
                        ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Text(getTranslated('address', context)!, style: titilliumRegular),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: CustomTextFieldWidget(
                            border: true,
                            maxLine: 4,
                            textInputType: TextInputType.text,
                            focusNode: _addressFocus,
                            hintText: shop.shopModel!.address ?? "",
                            controller: _addressController),
                      ),


                      const SizedBox(height: Dimensions.paddingSizeDefault),
                        Column(children: [
                          Text(getTranslated('update_logo', context)!),
                          Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
                            child: DottedBorder(dashPattern: const [10,5],
                              color: Theme.of(context).hintColor,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.paddingSizeSmall),
                              child: Container(width : 150, height: 150, alignment: Alignment.center,
                                decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                                child: Stack(clipBehavior: Clip.none, children: [
                                  ClipRRect(borderRadius: BorderRadius.circular(10),
                                    child: file == null ? CustomImageWidget(height: 140,width: 140,
                                        image: '${shop.shopModel!.imageFullUrl?.path}')
                                        : Image.file(file!, width: 100, height: 100, fit: BoxFit.cover)),
                                  Positioned(bottom: 0, right: 0, top: 0, left: 0,
                                    child: SizedBox(width: 50, height: 50,
                                      child: IconButton(onPressed: _choose, padding: const EdgeInsets.all(0),
                                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 40))))],
                                ),
                              ),
                            ),
                          ),
                        ],
                        ),


                          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            child: Row(children: [
                              Text('${getTranslated('business_or_shop_banner', context)}',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault))])),

                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Align(alignment: Alignment.center, child: DottedBorder(
                            dashPattern: const [10,5],
                            color: Theme.of(context).hintColor,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.paddingSizeSmall),
                            child: Stack(children: [
                              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                child: authProvider.shopBanner != null ?  Image.file(File(authProvider.shopBanner!.path),
                                  width: MediaQuery.of(context).size.width - 40, height: 120, fit: BoxFit.cover) :SizedBox(height: 120,
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: CustomImageWidget(image: '${shop.shopModel!.bannerFullUrl?.path}'))),

                              Positioned(bottom: 0, right: 0, top: 0, left: 0,
                                child: InkWell(onTap: () => authProvider.pickImage(false,false, false),
                                  child: Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                    child: Icon(Icons.camera_alt_outlined, size: 70,color: Theme.of(context).hintColor,),),),
                              ),
                            ]),
                          )),
                          Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(getTranslated('image_size', context)!, style: robotoRegular),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text('(3:1)', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),),
                              ])),


                      if(Provider.of<SplashController>(context, listen: false).configModel!.activeTheme == "theme_aster")
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge,top: Dimensions.paddingSizeDefault,
                                right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault),
                              child: Row(children: [
                                Text('${getTranslated('store_secondary_banner', context)}',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              ],
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            Align(alignment: Alignment.center, child: DottedBorder(
                              dashPattern: const [10,5],
                              color: Theme.of(context).hintColor,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.paddingSizeSmall),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  child: authProvider.secondaryBanner != null ?  Image.file(File(authProvider.secondaryBanner!.path),
                                    width: MediaQuery.of(context).size.width - 40, height: 120, fit: BoxFit.cover,
                                  ) :SizedBox(height: 120,
                                    width: MediaQuery.of(context).size.width - 40,
                                    child: CustomImageWidget(image: '${shop.shopModel!.bottomBannerFullUrl?.path}' ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0, right: 0, top: 0, left: 0,
                                  child: InkWell(
                                    onTap: () => authProvider.pickImage(false,false, false, secondary: true),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),

                                      ),
                                      child: Icon(Icons.camera_alt_outlined, size: 70,color: Theme.of(context).hintColor,),

                                    ),
                                  ),
                                ),
                              ]),
                            )),
                            Padding(
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(getTranslated('image_size', context)!, style: robotoRegular),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text('(3:1)', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),),
                                ],
                              ),
                            ),
                          ],),


                      if(Provider.of<SplashController>(context, listen: false).configModel!.activeTheme == "theme_fashion")
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge,top: Dimensions.paddingSizeDefault,
                              right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault),
                              child: Row(children: [
                                Text('${getTranslated('offer_banner', context)}',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault))])),


                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Align(alignment: Alignment.center, child: DottedBorder(
                            dashPattern: const [10,5],
                            color: Theme.of(context).hintColor,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.paddingSizeSmall),
                            child: Stack(children: [
                              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  child: authProvider.offerBanner != null ?  Image.file(File(authProvider.offerBanner!.path),
                                      width: MediaQuery.of(context).size.width - 40, height: 120, fit: BoxFit.cover) :SizedBox(height: 120,
                                      width: MediaQuery.of(context).size.width - 40,
                                      child: CustomImageWidget(image: '${shop.shopModel!.offerBannerFullUrl?.path}'))),

                              Positioned(bottom: 0, right: 0, top: 0, left: 0,
                                child: InkWell(onTap: () => authProvider.pickImage(false,false, false, offer: true),
                                  child: Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                    child: Icon(Icons.camera_alt_outlined, size: 70,color: Theme.of(context).hintColor,),),),),
                            ]),
                          )),


                          Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(getTranslated('image_size', context)!, style: robotoRegular),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text('(7:1)', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),),])),

                        ]),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 60,
                    child: Consumer<ShopController>(
                      builder: (context, shopProvider, _) {
                        return shopProvider.isLoading?
                        const Center(child: CircularProgressIndicator()):
                        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child:  CustomButtonWidget(btnTxt: getTranslated('update_shop', context),
                                onTap: () => _updateShop()));
                      }
                    )
                  )

                ],
              );
            }
          );
        },
      ),

      // bottomNavigationBar: SizedBox(height: 60,
      //     child: Consumer<ShopController>(
      //       builder: (context, shopProvider, _) {
      //         return shopProvider.isLoading?
      //             const Center(child: CircularProgressIndicator()):
      //         Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      //           child:  CustomButtonWidget(btnTxt: getTranslated('update_shop', context),
      //           onTap: () => _updateShop()));
      //       }
      //     )
      //   ),


    );

  }
}
