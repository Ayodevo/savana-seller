import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/screens/add_product_screen.dart';
import 'package:sixvalley_vendor_app/features/order/screens/order_screen.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/animated_floating_button_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/shop_product_card_widget.dart';
import 'package:sixvalley_vendor_app/features/product/screens/stock_out_product_screen.dart';

class ProductViewWidget extends StatefulWidget {
  final int? sellerId;
  const ProductViewWidget({Key? key, required this.sellerId}) : super(key: key);

  @override
  State<ProductViewWidget> createState() => _ProductViewWidgetState();
}

class _ProductViewWidgetState extends State<ProductViewWidget> {

  ScrollController scrollController = ScrollController();
  String message = "";
  bool activated = false;
  bool endScroll = false;
  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      setState(() {
        endScroll = true;
        message = "bottom";
        if (kDebugMode) {
          print('============$message=========');
        }
      });
    }else{
      if(endScroll) {
        setState(() {
          endScroll = false;
        });
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    Provider.of<ProductController>(context, listen: false).initSellerProductList(
        Provider.of<ProfileController>(context, listen: false).userId.toString(), 1,context,
        Provider.of<LocalizationController>(context, listen: false).locale.languageCode == 'US'?'en':
        Provider.of<LocalizationController>(context, listen: false).locale.countryCode!.toLowerCase(),'');
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<ProfileController>(context, listen: false).userId.toString();


    return RefreshIndicator(
      onRefresh: () async{
        Provider.of<ProductController>(context, listen: false).initSellerProductList(
            Provider.of<ProfileController>(context, listen: false).userId.toString(), 1,context,
            Provider.of<LocalizationController>(context, listen: false).locale.languageCode == 'US'?'en':
            Provider.of<LocalizationController>(context, listen: false).locale.countryCode!.toLowerCase(),'');
      },
      child: Consumer<ProductController>(
        builder: (context, prodProvider, child) {
          return SizedBox(height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                prodProvider.sellerProductModel != null ? (prodProvider.sellerProductModel!.products != null && prodProvider.sellerProductModel!.products!.isNotEmpty)?
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {

                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: PaginatedListViewWidget(
                      reverse: false,
                      scrollController: scrollController,
                      totalSize: prodProvider.sellerProductModel?.totalSize,
                      offset: prodProvider.sellerProductModel != null ? int.parse(prodProvider.sellerProductModel!.offset.toString()) : null,
                      onPaginate: (int? offset) async {
                        if (kDebugMode) {
                          print('==========offset========>$offset');
                        }
                        await prodProvider.initSellerProductList(userId,offset!, context,'en','', reload: false);
                      },

                      itemView: ListView.builder(
                        itemCount: prodProvider.sellerProductModel!.products!.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ShopProductWidget(productModel: prodProvider.sellerProductModel!.products![index],);
                        },
                      ),
                    ),
                  ),
                ):const NoDataScreen():const OrderShimmer(),


               if(!endScroll)
                Positioned(
                  bottom: 20,
                  right: Provider.of<LocalizationController>(context, listen: false).isLtr ? 20: null,
                  left: Provider.of<LocalizationController>(context, listen: false).isLtr ? null: 20,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ScrollingFabAnimated(
                      width: 150,
                      color: Theme.of(context).cardColor,
                      icon: SizedBox(width: Dimensions.iconSizeExtraLarge,child: Image.asset(Images.addIcon)),
                      text: Text(getTranslated('add_new', context)!, style: robotoRegular.copyWith(),),
                      onPress: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AddProductScreen()));
                      },
                      animateIcon: true,
                      inverted: false,
                      scrollController: scrollController,
                      radius: 10.0,
                    ),
                  ),
                ),
                if(!endScroll)
                Positioned(bottom: 100,
                  right: Provider.of<LocalizationController>(context, listen: false).isLtr ? 22: null,
                  left: Provider.of<LocalizationController>(context, listen: false).isLtr ? null: 22,
                  child: ScrollingFabAnimated(width: 200, color: Theme.of(context).cardColor,
                    icon: SizedBox(width: Dimensions.iconSizeExtraLarge,child: Image.asset(Images.limitedStockIcon)),
                    text: Text(getTranslated('limited_stocks', context)!, style: robotoRegular.copyWith(),),
                    onPress: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const StockOutProductScreen( )));
                    },
                    animateIcon: true,
                    inverted: false,
                    scrollController: scrollController,
                    radius: 10.0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

