import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/customer_body.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/invoice_model.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/place_order_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/cart_model.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/customer_model.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/services/cart_service_interface.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/models/temporary_cart_for_customer_model.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/features/order/controllers/order_controller.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/pos/screens/invoice_screen.dart';
import 'package:sixvalley_vendor_app/features/pos/widgets/product_variation_selection_dialog_widget.dart';


class CartController extends ChangeNotifier{
  final CartServiceInterface cartServiceInterface;
  CartController({required this.cartServiceInterface});


  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;
  double _amount = 0.0;
  double get amount => _amount;
  double _productDiscount = 0.0;
  double get productDiscount => _productDiscount;

  final double _productTax = 0.0;
  double get productTax => _productTax;
  InvoiceModel? _invoice;
  InvoiceModel? get invoice => _invoice;

  List<TemporaryCartListModel> _customerCartList = [];
  List<TemporaryCartListModel> get customerCartList => _customerCartList;
  double _discountOnProduct = 0;
  double get discountOnProduct => _discountOnProduct;

  double _totalTaxAmount = 0;
  double get totalTaxAmount => _totalTaxAmount;


  final TextEditingController _collectedCashController = TextEditingController();
  TextEditingController get collectedCashController => _collectedCashController;

  final TextEditingController _customerWalletController = TextEditingController();
  TextEditingController get customerWalletController => _customerWalletController;

  final TextEditingController _couponController = TextEditingController();
  TextEditingController get couponController => _couponController;

  final TextEditingController _extraDiscountController = TextEditingController();
  TextEditingController get extraDiscountController => _extraDiscountController;

  double _returnToCustomerAmount = 0 ;
  double get returnToCustomerAmount => _returnToCustomerAmount;

  double? _couponCodeAmount = 0;
  double? get couponCodeAmount =>_couponCodeAmount;
  final String _couponCodeApplied = '';
  String get couponCodeApplied => _couponCodeApplied;

  double _extraDiscountAmount = 0;
  double get extraDiscountAmount =>_extraDiscountAmount;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;


  String? _selectedDiscountType = '';
  String? get selectedDiscountType =>_selectedDiscountType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Product? _scanProduct ;
  Product? get scanProduct=>_scanProduct;

  final List<bool> _isSelectedList = [];
  List<bool> get isSelectedList => _isSelectedList;

  int _customerIndex = 0;
  int get customerIndex => _customerIndex;

  List<int?> _customerIds = [];
  List<int?> get customerIds => _customerIds;

  List<CartModel>? _existInCartList;
  List<CartModel>? get existInCartList =>_existInCartList;


  List<Customers>? _searchedCustomerList;
  List<Customers>? get searchedCustomerList =>_searchedCustomerList;

  bool _isGetting = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isGetting => _isGetting;

  final int _customerListLength = 0;
  int get customerListLength => _customerListLength;



  String? _customerSelectedName = '';
  String? get customerSelectedName => _customerSelectedName;

  String? _customerSelectedMobile = '';
  String? get customerSelectedMobile => _customerSelectedMobile;

  int? _customerId = 0;
  int? get customerId => _customerId;

  final TextEditingController _searchCustomerController = TextEditingController();
  TextEditingController get searchCustomerController => _searchCustomerController;
  double _customerBalance = 0.0;
  double get customerBalance=> _customerBalance;
  int cartIndex = 0;


  void setSelectedDiscountType(String? type){
    _selectedDiscountType = type;
    _extraDiscountController.text = '';
    notifyListeners();
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  int _paymentTypeIndex = 0;
  int get paymentTypeIndex => _paymentTypeIndex;
  void setPaymentTypeIndex(int index, bool notify) {
    _paymentTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }



  void getReturnAmount( double totalCostAmount){
    setReturnAmountToZero();

    if(_customerId != 0){
      _customerWalletController.text = _customerBalance.toString();
      _returnToCustomerAmount = double.parse(_customerWalletController.text) - totalCostAmount;
    }
    else if(_collectedCashController.text.isNotEmpty){
      _returnToCustomerAmount = double.parse(_collectedCashController.text) - totalCostAmount;
    }
    notifyListeners();
  }

  void applyCouponCodeAndExtraDiscount(BuildContext context){
    _extraDiscountAmount = 0;
    String extraDiscount = _extraDiscountController.text.trim();
    _extraDiscountAmount = double.parse(extraDiscount);
    if(_extraDiscountAmount > _amount) {
      showCustomSnackBarWidget(getTranslated('discount_cant_greater_than_order_amount', context),context,isToaster: true);
    }else{
      _customerCartList[_customerIndex].extraDiscount = _extraDiscountAmount;
      showCustomSnackBarWidget(getTranslated('extra_discount_added_successfully', context),context,isToaster: true, isError: false);
    }

    notifyListeners();

  }
  void setReturnAmountToZero()
  {
    _returnToCustomerAmount = 0;
    notifyListeners();
  }



  void addToCart(BuildContext context, CartModel cartModel, {bool decreaseQuantity= false}) {
    _amount = 0;
    if(_customerCartList.isNotEmpty){
      _customerCartList[_customerIndex].couponAmount = 0;
      _customerCartList[_customerIndex].extraDiscount = 0;
      _extraDiscountController.text = '';
      _extraDiscountAmount = 0;
    }
    if(_customerCartList.isEmpty){
      TemporaryCartListModel customerCart = TemporaryCartListModel(
          cart: [],
          userIndex: 0,
          userId: 0,
          customerName: 'wc-0');
      addToCartListForUser(customerCart, clear: false);

    }

    // (e.varientKey == e.varientKey)

    if (_customerCartList[_customerIndex].cart!.any((e) => (cartModel.varientKey == null &&  e.product!.id == cartModel.product!.id && ((e.variant == cartModel.variant))))) {
      isExistInCart(context, cartModel, decreaseQuantity: decreaseQuantity);
    } else if (_customerCartList[_customerIndex].cart!.any((e) => (cartModel.varientKey != null &&  e.product!.id == cartModel.product!.id && ((e.varientKey == cartModel.varientKey))))) {
      isExistInCart(context, cartModel, decreaseQuantity: decreaseQuantity);
    } else{
      _customerCartList[_customerIndex].cart!.add(cartModel);

      for(int i = 0; i< _customerCartList[_customerIndex].cart!.length; i++){
        int? quantity = _customerCartList[_customerIndex].cart![i].quantity!;
        if(_customerCartList[_customerIndex].cart![i].variation != null) {
          double pAmount = (_customerCartList[_customerIndex].cart![i].variation!.price! * quantity);
          double includeTax = 0;
          if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
            includeTax = calculateIncludedTax(pAmount, _customerCartList[_customerIndex].cart![i].product!.tax!);
          }
          _amount = _amount + (pAmount - includeTax);
        } else if(_customerCartList[_customerIndex].cart![i].varientKey != null) {
          double pAmount = (_customerCartList[_customerIndex].cart![i].digitalVariationPrice! * quantity);
          double includeTax = 0;
          if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
            includeTax = calculateIncludedTax(pAmount, _customerCartList[_customerIndex].cart![i].product!.tax!);
          }
          _amount = _amount + (pAmount - includeTax);
        } else {
          double pAmount = (_customerCartList[_customerIndex].cart![i].price! * quantity);
          double includeTax = 0;
          if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
            includeTax = calculateIncludedTax(pAmount, _customerCartList[_customerIndex].cart![i].product!.tax!);
          }
          _amount = _amount + (pAmount - includeTax);
        }
      }
      print("====>>ELSE<<=====${_amount}");
      showCustomSnackBarWidget(getTranslated('added_cart_successfully', context),context ,isToaster: true, isError: false);
    }
    notifyListeners();
  }


  double calculateIncludedTax(double totalPrice, double taxRate) {
    // return ((totalPrice * (taxRate/100)) / (1 + taxRate/100));
    return (totalPrice * taxRate) / 100;
  }


  void addToCartListForUser(TemporaryCartListModel cartList,{bool clear = false}) {
    if(_customerCartList.isEmpty){
      _customerIds = [];
    }

    if (_customerCartList.any((e) => e.userId == cartList.userId && cartList.userId != 0)) {
      searchCustomerController.text = 'walking customer';
      setCustomerInfo( 0,  'walking customer', 'NULL', false);
      //_customerCartList.removeAt(_customerIds.indexOf(cartList.userIndex));
    }else{
      _customerIds.add(_customerIds.length);
      _customerCartList.add(cartList);
      showCustomSnackBarWidget(getTranslated('new_order_added_successfully', Get.context!), Get.context!, isError: false, sanckBarType: SnackBarType.success);
      if(clear){

        notifyListeners();
      }
    }
  }


  void setQuantity(BuildContext context, bool isIncrement, int? index, {bool showToaster = false}) {
    if(_customerCartList.isNotEmpty){
      _customerCartList[_customerIndex].couponAmount = 0;
      _customerCartList[_customerIndex].extraDiscount = 0;
      _extraDiscountController.text = '';
      _extraDiscountAmount = 0;
    }
    if (isIncrement) {
      if(_customerCartList[_customerIndex].cart![index!].product!.currentStock! > _customerCartList[_customerIndex].cart![index].quantity! && _customerCartList[_customerIndex].cart![index].product!.productType == 'physical')
      {
        _amount = 0;
        _customerCartList[_customerIndex].cart![index].quantity = _customerCartList[_customerIndex].cart![index].quantity! + 1;

        for(int i = 0; i< _customerCartList[_customerIndex].cart!.length; i++) {
          int? quantity = _customerCartList[_customerIndex].cart![i].quantity!;
          if(_customerCartList[_customerIndex].cart![i].variation != null){
            double amount = (_customerCartList[_customerIndex].cart![i].variation!.price! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          } else if(_customerCartList[_customerIndex].cart![i].varientKey != null) {
            double amount = (_customerCartList[_customerIndex].cart![i].digitalVariationPrice! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount =  _amount + (amount - includeTax);
          } else {
            double amount = (_customerCartList[_customerIndex].cart![i].price! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          }
        }
        if(showToaster){
          showCustomSnackBarWidget(getTranslated('quantity_updated', context), context, isToaster: true, isError: false);
        }

      }else if(_customerCartList[_customerIndex].cart![index].product!.productType == 'digital')
      {
        _amount = 0;
        _customerCartList[_customerIndex].cart![index].quantity = _customerCartList[_customerIndex].cart![index].quantity! + 1;

        if(showToaster){
          showCustomSnackBarWidget(getTranslated('quantity_updated', context), context, isToaster: true, isError: false);
        }
        for(int i = 0; i< _customerCartList[_customerIndex].cart!.length; i++) {
          int? quantity = _customerCartList[_customerIndex].cart![i].quantity!;
          if(_customerCartList[_customerIndex].cart![i].variation != null){
            double amount = (_customerCartList[_customerIndex].cart![i].variation!.price! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          } else if(_customerCartList[_customerIndex].cart![i].varientKey != null) {
            double amount = (_customerCartList[_customerIndex].cart![i].digitalVariationPrice! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          } else {
            double amount = (_customerCartList[_customerIndex].cart![i].price! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount =  _amount + (amount - includeTax);
          }
        }
      }else{
        showCustomSnackBarWidget(getTranslated('stock_out', context), context, isToaster: true);
      }
    } else {
      _amount = 0;
      if(_customerCartList[_customerIndex].cart![index!].quantity! > 1){

        showCustomSnackBarWidget(getTranslated('quantity_updated', context), context, isToaster: true, isError: false);
        _customerCartList[_customerIndex].cart![index].quantity = _customerCartList[_customerIndex].cart![index].quantity! - 1;
        for(int i = 0; i< _customerCartList[_customerIndex].cart!.length; i++) {
          int? quantity = _customerCartList[_customerIndex].cart![i].quantity!;
          if(_customerCartList[_customerIndex].cart![i].variation != null){
            double amount = (_customerCartList[_customerIndex].cart![i].variation!.price! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          } else if(_customerCartList[_customerIndex].cart![i].varientKey != null) {
            double amount = (_customerCartList[_customerIndex].cart![i].digitalVariationPrice! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          } else {
            double amount = (_customerCartList[_customerIndex].cart![i].price! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          }
        }
      }else{
        showCustomSnackBarWidget(getTranslated('minimum_quantity_1', context), context, isToaster: true);
        for(int i = 0; i< _customerCartList[_customerIndex].cart!.length; i++) {
          int? quantity = _customerCartList[_customerIndex].cart![i].quantity!;
          if(_customerCartList[_customerIndex].cart![i].variation != null) {
            double amount = (_customerCartList[_customerIndex].cart![i].variation!.price! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          } else if(_customerCartList[_customerIndex].cart![i].varientKey != null) {
            double amount = (_customerCartList[_customerIndex].cart![i].digitalVariationPrice! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          } else {
            double amount = (_customerCartList[_customerIndex].cart![i].price! * quantity);
            double includeTax = 0;
            if(_customerCartList[_customerIndex].cart![i].product!.taxModel == "include") {
              includeTax = calculateIncludedTax(amount, _customerCartList[_customerIndex].cart![i].product!.tax!);
            }
            _amount = _amount + (amount - includeTax);
          }
        }
      }
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    int? quantity = _customerCartList[_customerIndex].cart![index].quantity!;
    double? amount;

    if(_customerCartList[_customerIndex].cart![index].variation != null){
      // amount = (_customerCartList[_customerIndex].cart![index].variation!.price! * quantity);
      double _amount = (_customerCartList[_customerIndex].cart![index].variation!.price! * quantity);
      double includeTax = 0;
      if(_customerCartList[_customerIndex].cart![index].product!.taxModel == "include") {
        includeTax = calculateIncludedTax(_amount, _customerCartList[_customerIndex].cart![index].product!.tax!);
      }
      amount = _amount - includeTax;
    } else if(_customerCartList[_customerIndex].cart![index].varientKey != null) {
      // amount = (_customerCartList[_customerIndex].cart![index].digitalVariationPrice! * quantity);
      double _amount = (_customerCartList[_customerIndex].cart![index].digitalVariationPrice! * quantity);
      double includeTax = 0;
      if(_customerCartList[_customerIndex].cart![index].product!.taxModel == "include") {
        includeTax = calculateIncludedTax(_amount, _customerCartList[_customerIndex].cart![index].product!.tax!);
      }
      amount = _amount - includeTax;
    } else {
      // amount = (_customerCartList[_customerIndex].cart![index].price! * quantity);
      double _amount = (_customerCartList[_customerIndex].cart![index].price! * quantity);
      double includeTax = 0;
      if(_customerCartList[_customerIndex].cart![index].product!.taxModel == "include") {
        includeTax = calculateIncludedTax(_amount, _customerCartList[_customerIndex].cart![index].product!.tax!);
      }
      amount = _amount - includeTax;
    }
    _amount = _amount - amount;
    if(_customerCartList.isNotEmpty){
      _customerCartList[_customerIndex].couponAmount = 0;
      _customerCartList[_customerIndex].extraDiscount = 0;
      _extraDiscountController.text = '';
      _extraDiscountAmount = 0;
    }
    _customerCartList[_customerIndex].cart!.removeAt(index);
    _couponCodeAmount = 0;
    notifyListeners();
  }

  void removeAllCart() {
    _cartList = [];
    _collectedCashController.clear();
    _extraDiscountAmount = 0;
    _amount = 0;
    _collectedCashController.clear();
    _customerCartList = [];


    notifyListeners();
  }


  void removeAllCartList() {
    _cartList =[];
    _customerWalletController.clear();
    _extraDiscountAmount = 0;
    _amount = 0;
    _collectedCashController.clear();
    _customerCartList =[];
    _customerIds = [];
    _customerIndex = 0;
    searchCustomerController.text = 'walking customer';
    setCustomerInfo( 0,  'walking customer', 'NULL', true);
    notifyListeners();
  }




  bool isExistInCart(BuildContext context,CartModel cartModel, {bool decreaseQuantity= false}) {
    cartIndex = 0;
    for(int index = 0; index<_customerCartList[_customerIndex].cart!.length; index++) {
      if(_customerCartList[_customerIndex].cart![index].product!.id == cartModel.product!.id) {
        if(decreaseQuantity){
          setQuantity(context, false, index);
          showCustomSnackBarWidget('1 ${getTranslated('item', context)} ${getTranslated('remove_from_cart_successfully', context)}',context, isToaster: true, isError: false);
        }else{
          setQuantity(context, true, index);
          showCustomSnackBarWidget('${getTranslated('added_cart_successfully', context)} ${ _customerCartList[_customerIndex].cart![index].quantity} ${getTranslated('items', context)}',context, isToaster: true, isError: false);
        }
      }
    }
    return false;
  }


  Future<void> getCouponDiscount(BuildContext context,String couponCode, int? userId, double orderAmount) async {
    ApiResponse response = await cartServiceInterface.getCouponDiscount(couponCode, userId, orderAmount);
    if(response.response!.statusCode == 200) {
      _couponController.clear();
      Map map = response.response!.data;
      _couponCodeAmount = map['coupon_discount_amount'].toDouble();
      _customerCartList[_customerIndex].couponAmount = _couponCodeAmount;
      _customerCartList[_customerIndex].couponCode = couponCode;

      showCustomSnackBarWidget('You got ${_couponCodeAmount.toString()} discount',Get.context!, isToaster: true, isError: false);
    }else if(response.response!.statusCode == 202){
      _couponController.clear();
      Map  map = response.response!.data;
      String? message = map['message'];
      showCustomSnackBarWidget(message,Get.context!, isToaster: true);
    }
    else {
      _couponController.clear();
      ApiChecker.checkApi( response);
    }
    notifyListeners();
  }


  void clearCardForCancel(){
    _couponCodeAmount = 0;
    _extraDiscountAmount = 0;
    // notifyListeners();

  }

  Future<ApiResponse> placeOrder(BuildContext context, PlaceOrderBody placeOrderBody) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse response = await cartServiceInterface.placeOrder(placeOrderBody);
    if(response.response!.statusCode == 200 && response.response?.data['checkProductTypeForWalkingCustomer'] == true) {
      showCustomSnackBarWidget(response.response?.data['message'], Get.context!, isToaster: true, isError: false, sanckBarType: SnackBarType.error);
      _isLoading = false;
    } else if(response.response!.statusCode == 200){
      _isLoading = false;
      _couponCodeAmount = 0;
      _productDiscount = 0;
      _customerBalance = 0;
      _customerWalletController.clear();
      Provider.of<OrderController>(Get.context!, listen: false).getOrderList(Get.context!, 1,'all');
      showCustomSnackBarWidget(getTranslated('order_placed_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      _extraDiscountAmount = 0;
      _extraDiscountController.text = '';
      _extraDiscountAmount = 0;
      _amount = 0;
      _collectedCashController.clear();
      _customerCartList.removeAt(_customerIndex);
      _customerIds.removeAt(_customerIndex);
      setCustomerInfo( 0,  'walking customer', 'NULL', true);
      searchCustomerController.text = 'walking customer';
      if(_customerIds.isNotEmpty) {
        _amount = 0;
        setCustomerIndex(0, false);
        // Get.find<CartProvider>().searchCustomerController.text = 'walking customer';
        setCustomerInfo(_customerCartList[_customerIndex].userId, _customerCartList[_customerIndex].customerName, '', true);
      }
      Navigator.push(Get.context!, MaterialPageRoute(builder: (_)=> InVoiceScreen(orderId: response.response!.data['order_id'])));

    }else{
      ApiChecker.checkApi( response);
    }
    notifyListeners();
    return response;
  }




  Future<void> scanProductBarCode(BuildContext context) async{
    String? scannedProductBarCode;
    try{
      scannedProductBarCode = await FlutterBarcodeScanner.scanBarcode('#003E47', 'cancel', false, ScanMode.BARCODE);
    }
    on PlatformException{
      if (kDebugMode) {
        print('object');
      }
    }
    getProductFromScan(Get.context!, scannedProductBarCode);
  }




  Future<void> getProductFromScan(BuildContext context, String? productCode) async {
    _isLoading = true;
    ApiResponse response = await cartServiceInterface.getProductFromScan(productCode);
    if(response.response!.statusCode == 200) {

      _scanProduct = Product.fromJson(response.response!.data);
      Provider.of<ProductController>(Get.context!, listen: false).initData(_scanProduct!,1, Get.context!);
      if(scanProduct!.variation!.isNotEmpty || scanProduct!.digitalProductFileTypes!.isNotEmpty){
        showModalBottomSheet(context: Get.context!, isScrollControlled: true,
            backgroundColor: Theme.of(Get.context!).primaryColor.withOpacity(0),
            builder: (con) => CartBottomSheetWidget(product: _scanProduct, callback: (){
              showCustomSnackBarWidget(getTranslated('added_to_cart', context), context, isError: false);},));

      }else{
        CartModel cartModel = CartModel(_scanProduct!.unitPrice, _scanProduct!.discount, 1, _scanProduct!.tax, null,null,null,null, _scanProduct, _scanProduct!.taxModel);
        addToCart(Get.context!, cartModel);
      }

      _isLoading = false;
    }else {
      ApiChecker.checkApi( response);
    }
    _isLoading = false;
    notifyListeners();
  }


  Future<void> setCustomerIndex(int index, bool notify) async {
    _amount = 0;
    _customerIndex = index;
    if(_customerCartList.isNotEmpty) {
      for(int i =0; i< _customerCartList[_customerIndex].cart!.length; i++){
        _amount = _amount + (_customerCartList[_customerIndex].cart![i].price! * _customerCartList[_customerIndex].cart![i].quantity!);
      }
    }

    if(notify) {
      notifyListeners();
    }
  }


  int? _reviewCustomerIndex = 0;
  int? get reviewCustomerIndex => _reviewCustomerIndex;

  List<int?> _reviewCustomerIds = [];
  List<int?> get reviewCustomerIds => _reviewCustomerIds;



  Future<void> getCustomerList(String type) async {
    _reviewCustomerIndex = 0;
    _reviewCustomerIds = [];
    _searchedCustomerList = [];
    _isGetting = true;
    ApiResponse response = await cartServiceInterface.getCustomerList(type);
    if(response.response!.statusCode == 200) {
      _searchedCustomerList = [];
      _searchedCustomerList!.addAll(CustomerModel.fromJson(response.response!.data).customers!);
      _isGetting = false;
      _isFirst = false;
      if(_searchedCustomerList!.isNotEmpty){
        for(int index = 0; index < _searchedCustomerList!.length; index++) {
          _reviewCustomerIds.add(_searchedCustomerList![index].id);
        }
        _reviewCustomerIndex = _reviewCustomerIds[0];
      }
    }else {
      ApiChecker.checkApi( response);
    }
    _isGetting = false;
    notifyListeners();
  }

  bool _showDialog = false;
  bool get showHideDialog=> _showDialog;

  void shoHideDialog(bool showDialog){
     _showDialog = showDialog;

    notifyListeners();
  }


  Future<void> searchCustomer(BuildContext context,String searchName) async {
    shoHideDialog(true);
    _searchedCustomerList = [];
    _isGetting = true;
    ApiResponse response = await cartServiceInterface.customerSearch(searchName);
    if(response.response!.statusCode == 200) {
      _searchedCustomerList = [];
      _searchedCustomerList!.addAll(CustomerModel.fromJson(response.response!.data).customers!);
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi( response);
    }
    _isGetting = false;
    notifyListeners();

  }

  void setCustomerInfo(int? id, String? name, String? phone,  bool notify) {
    _customerId = id;
    _customerSelectedName = name;
    _customerSelectedMobile  = phone;
    if(notify) {
      notifyListeners();
    }
  }

  Future<void> addNewCustomer(BuildContext context,CustomerBody customerBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await cartServiceInterface.addNewCustomer(customerBody);
    print("=======>>${response.error}");
    if(response.error == 'The email has already been taken.' || response.error == 'The phone has already been taken.') {
      showCustomSnackBarWidget(response.error, Get.context!, isError: true, sanckBarType: SnackBarType.warning);
      _isLoading = false;
      notifyListeners();
    } else if(response.response!.statusCode == 200) {
      getCustomerList("all");
      _isLoading = false;
      Navigator.pop(Get.context!);
      Map map = response.response!.data;
      String? message = map['message'];
      showCustomSnackBarWidget(message, Get.context!, isError: false);
    }
    else {
      _isLoading = false;
      ApiChecker.checkApi( response);
    }
    notifyListeners();
  }


  Future<void> getInvoiceData(int? orderId) async {
    _isLoading = true;
    ApiResponse response = await cartServiceInterface.getInvoiceData(orderId);
    if(response.response != null && response.response!.statusCode == 200) {
      _discountOnProduct = 0;
      _totalTaxAmount = 0;
      _invoice = InvoiceModel.fromJson(response.response!.data);
      for(int i=0; i< _invoice!.details!.length; i++ ){
        _discountOnProduct += invoice!.details![i].discount!;
        if(invoice!.details![i].productDetails!.taxModel == "exclude"){
          _totalTaxAmount += invoice!.details![i].tax!;
        }

      }
      _isLoading = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

}