import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/coupon/domain/models/coupon_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/coupon/controllers/coupon_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_date_picker_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_drop_down_item_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_field_with_title_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/pos/screens/customer_search_screen.dart';

class AddNewCouponScreen extends StatefulWidget {
  final Coupons? coupons;
  const AddNewCouponScreen({Key? key, this.coupons}) : super(key: key);

  @override
  State<AddNewCouponScreen> createState() => _AddNewCouponScreenState();
}

class _AddNewCouponScreenState extends State<AddNewCouponScreen> {

  TextEditingController couponTitleController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  TextEditingController discountAmountController = TextEditingController();
  TextEditingController minimumPurchaseController = TextEditingController();
  TextEditingController maximumDiscountController = TextEditingController();

  bool update = false;

  @override
  void initState() {
    update = widget.coupons != null ? true: false;
    if(update){
      couponTitleController.text = widget.coupons!.title!;
      couponCodeController.text = widget.coupons!.code!;
      discountAmountController.text = widget.coupons!.discount.toString();
      minimumPurchaseController.text = widget.coupons!.minPurchase.toString();
      limitController.text = widget.coupons!.limit.toString();
      maximumDiscountController.text = widget.coupons!.maxDiscount.toString();
      Provider.of<CouponController>(context, listen: false).startDate = DateTime.parse(widget.coupons!.startDate!);
      Provider.of<CouponController>(context, listen: false).endDate = DateTime.parse(widget.coupons!.expireDate!);
    } else {
      Provider.of<CouponController>(context, listen: false).clearCouponData();
    }
    Provider.of<CouponController>(context, listen: false).getCouponCustomerList(context,'');
    if(Provider.of<CouponController>(context, listen: false).customerSelectedName == ''){
      Provider.of<CouponController>(context, listen: false).searchCustomerController.text = 'All Customer';
      Provider.of<CouponController>(context, listen: false).setCustomerInfo( 0,  'All Customer', false);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('coupon_setup', context)),
      body: Consumer<CouponController>(
        builder: (context, coupon,_) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    CustomDropDownItemWidget(
                      title: 'coupon_type',
                      widget: DropdownButtonFormField<String>(
                        value: coupon.selectedCouponType,
                        isExpanded: true,
                        decoration: const InputDecoration(border: InputBorder.none),
                        iconSize: 24, elevation: 16, style: robotoRegular,
                        onChanged: (value) {
                          coupon.setSelectedCouponType(value);
                        },
                        items: coupon.couponTypeList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(getTranslated(value, context)!,
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                          );
                        }).toList(),
                      ),
                    ),
                          
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
                          child: Text(getTranslated('select_customer', context)!)),
                    ),
                    GestureDetector(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const CustomerSearchScreen(isCoupon: true,))),
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Container(width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(border: Border.all(width: .25, color: Theme.of(context).hintColor.withOpacity(.75)),
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Row(children: [
                                  Expanded(child: Text(coupon.searchCustomerController.text)),
                                  Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor)
                                ],
                                ),
                              )),
                        )),
                          
                    const SizedBox(height: Dimensions.paddingSizeMedium,),
                    CustomFieldWithTitleWidget(
                      isCoupon: true,
                      title: getTranslated('coupon_title', context),
                      customTextField: CustomTextFieldWidget(
                        border: true,
                        controller: couponTitleController,
                        hintText: getTranslated('coupon_title_hint', context),
                      ),
                    ),
                          
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        Row(children: [
                          Text(getTranslated('coupon_code', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          
                          const Spacer(),
                          InkWell(
                              splashColor: Colors.transparent,
                              onTap: (){
                                const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                Random rnd = Random();
                          
                                String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
                                    length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
                                var code = getRandomString(10);
                                couponCodeController.text = code.toString();
                              },
                              child: Text(getTranslated('generate_code', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor))),
                        ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                          
                        CustomTextFieldWidget(
                          border: true,
                          controller: couponCodeController,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.number,
                          isAmount: true,
                          hintText: 'Ex: ze5uzkyu0s',
                        ),
                      ],),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          
                    CustomFieldWithTitleWidget(
                      isCoupon: true,
                      title: getTranslated('limit_for_same_user', context),
                      customTextField: CustomTextFieldWidget(
                        border: true,
                        isAmount: true,
                        controller: limitController,
                        hintText: getTranslated('limit_user_hint', context),
                      ),
                          
                    ),
                          
                    coupon.selectedCouponType == 'discount_on_purchase'?
                    const SizedBox(height: Dimensions.paddingSizeMedium):const SizedBox.shrink(),
                    coupon.selectedCouponType == 'discount_on_purchase'?
                    CustomDropDownItemWidget(
                      title: 'discount_type',
                      widget: DropdownButtonFormField<String>(
                        value: coupon.discountTypeName,
                        isExpanded: true,
                        decoration: const InputDecoration(border: InputBorder.none),
                        iconSize: 24, elevation: 16, style: robotoRegular,
                        onChanged: (value) {
                          coupon.setSelectedDiscountNameType(value);
                        },
                        items: coupon.discountTypeList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(getTranslated(value, context)!,
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                          );
                        }).toList(),
                      ),
                    ):const SizedBox.shrink(),
                          
                          
                    coupon.selectedCouponType == 'discount_on_purchase'?
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall): const SizedBox.shrink(),
                    coupon.selectedCouponType == 'discount_on_purchase'?
                    CustomFieldWithTitleWidget(
                      isCoupon: true,
                      title: getTranslated('discount_amount', context),
                      customTextField: CustomTextFieldWidget(
                        border: true,
                        isAmount: true,
                        controller: discountAmountController,
                        hintText: getTranslated('discount_amount_hint', context),
                      ),
                          
                    ):const SizedBox.shrink(),
                    const SizedBox(height: Dimensions.paddingSizeMedium),
                          
                    CustomFieldWithTitleWidget(
                      isCoupon: true,
                      title: getTranslated('minimum_purchase', context),
                      customTextField: CustomTextFieldWidget(
                        border: true,
                        isAmount: true,
                        textInputAction: TextInputAction.done,
                        controller: minimumPurchaseController,
                        hintText: getTranslated('minimum_purchase_hint', context),
                      ),
                    ),
                          
                    if(coupon.discountTypeName == 'percentage')
                      const SizedBox(height: Dimensions.paddingSizeMedium),
                    if(coupon.discountTypeName == 'percentage')
                      CustomFieldWithTitleWidget(
                          isCoupon: true,
                          title: getTranslated('maximum_discount', context),
                          customTextField: CustomTextFieldWidget(
                              border: true,
                              isAmount: true,
                              textInputAction: TextInputAction.done,
                              controller: maximumDiscountController,
                              hintText: getTranslated('minimum_purchase_hint', context))),
                          
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Row(children: [
                      Expanded(child: CustomDatePickerWidget(
                        title: getTranslated('start_date', context),
                        image: Images.calenderIcon,
                        text: coupon.startDate != null ?
                        coupon.dateFormat.format(coupon.startDate!).toString() : getTranslated('select_date', context),
                        selectDate: () => coupon.selectDate("start", context),
                      )),
                          
                      Expanded(child: CustomDatePickerWidget(
                        title: getTranslated('expire_date', context),
                        image: Images.calenderIcon,
                        text: coupon.endDate != null ?
                        coupon.dateFormat.format(coupon.endDate!).toString() : getTranslated('select_date', context),
                        selectDate: () => coupon.selectDate("end", context),
                      )),
                    ],),
                    const SizedBox(height: Dimensions.paddingSizeMedium),
                  ],
                ),
              ),
            ),
          
            Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: ThemeShadow.getShadow(context)
                ),
                child: Consumer<CouponController>(
                    builder: (context, coupon,_) {
                      return Consumer<CartController>(
                          builder: (context, customer,_) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
                              child: coupon.isAdd?
                              const Center(
                                child: SizedBox(width: 40,height: 40,
                                    child: CircularProgressIndicator()),
                              ):
                              CustomButtonWidget(btnTxt:update? getTranslated('update', context) : getTranslated('submit', context),
                                  onTap: (){
                                    String? couponType = coupon.selectedCouponType;
                                    int? customerId = coupon.selectedCustomerIdForCoupon;
                                    String couponTitle = couponTitleController.text.trim();
                                    String couponCode = couponCodeController.text.trim();
                                    String limit = limitController.text.trim();
                                    String? discountType = coupon.discountTypeName;
                                    String discountAmount = discountAmountController.text.trim();
                                    String minimumPurchase = minimumPurchaseController.text.trim();
                                    String maxDiscount = maximumDiscountController.text.trim();
                                    String? startDate =  coupon.dateFormat.format(coupon.startDate?? DateTime.now()).toString();
                                    String? endDate =  coupon.dateFormat.format(coupon.endDate?? DateTime.now()).toString();
          
                                    if(couponTitle.isEmpty){
                                      showCustomSnackBarWidget(getTranslated('coupon_title_is_required', context), context, sanckBarType: SnackBarType.warning);
                                    }else if(couponCode.isEmpty){
                                      showCustomSnackBarWidget(getTranslated('coupon_code_is_required', context), context, sanckBarType: SnackBarType.warning);
                                    }else if(limit.isEmpty){
                                      showCustomSnackBarWidget(getTranslated('limit_is_required', context), context, sanckBarType: SnackBarType.warning);
                                    }else if(discountAmount.isEmpty && coupon.selectedCouponType == 'discount_on_purchase'){
                                      showCustomSnackBarWidget(getTranslated('amount_is_required', context), context, sanckBarType: SnackBarType.warning);
                                    }else if(minimumPurchase.isEmpty){
                                      showCustomSnackBarWidget(getTranslated('minimum_purchase_is_required', context), context, sanckBarType: SnackBarType.warning);
                                    }else if(maxDiscount.isEmpty && coupon.discountTypeName == 'percentage'){
                                      showCustomSnackBarWidget(getTranslated('max_discount_is_required', context), context, sanckBarType: SnackBarType.warning);
                                    }else if(coupon.startDate == null && !update){
                                      showCustomSnackBarWidget(getTranslated('start_date_is_required', context), context, sanckBarType: SnackBarType.warning);
                                    }else if(coupon.endDate == null && !update){
                                      showCustomSnackBarWidget(getTranslated('end_date_is_required', context), context, sanckBarType: SnackBarType.warning);
                                    }else if(coupon.discountTypeName == 'percentage' && double.parse(discountAmount) > 100){
                                      showCustomSnackBarWidget(getTranslated('discount_amount_should_be_less_then', context), context, sanckBarType: SnackBarType.warning);
                                    }else{
                                      Coupons coupons = Coupons(
                                          id: update? widget.coupons!.id: null,
                                          title: couponTitle,
                                          couponType: couponType,
                                          customerId: customerId,
                                          code: couponCode,
                                          limit: int.parse(limit),
                                          discountType: discountType,
                                          discount: coupon.selectedCouponType == 'discount_on_purchase'?double.parse(discountAmount):0,
                                          minPurchase: double.parse(minimumPurchase),
                                          maxDiscount: maxDiscount.isNotEmpty? double.parse(maxDiscount) : 0,
                                          startDate: startDate,
                                          expireDate: endDate
                                      );
                                      coupon.addNewCoupon(context, coupons, update);
                                    }
                                  }),
                            );
                          }
                      );
                    }
                ))
          ]);
        }
      ),
    );
  }
}
