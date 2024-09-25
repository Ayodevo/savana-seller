import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/rating_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/product_controller.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/features/addProduct/screens/add_product_screen.dart';
import 'package:sixvalley_vendor_app/features/product_details/screens/product_details_screen.dart';



class ProductWidget extends StatefulWidget {
  final Product productModel;
  const ProductWidget({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.down;
  var buttonSize = const Size(35.0, 35.0);
  var childrenButtonSize = const Size(45.0, 45.0);

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width/2.5;
    double totalRatting = 0;
    double averageProductRatting = 0;
    if(widget.productModel.reviews!.isNotEmpty){
      for(int i =0; i< widget.productModel.reviews!.length; i++ ){
        totalRatting += widget.productModel.reviews![i].rating!;
      }
      averageProductRatting = totalRatting/widget.productModel.reviews!.length;
    }
    return GestureDetector(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> ProductDetailsScreen(productModel: widget.productModel))),
      child: SizedBox(width: imageSize+20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0,vertical: 4.0),
          child: Stack(children: [
              Container(decoration: BoxDecoration(color: Theme.of(context).cardColor),

                child: Column(children: [
                  Container(decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.10),
                    borderRadius: const BorderRadius.only(topLeft:Radius.circular(Dimensions.paddingSizeSmall),
                        topRight: Radius.circular(Dimensions.paddingSizeSmall)),),
                    width: imageSize, height:  imageSize,

                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft:Radius.circular(Dimensions.paddingSizeSmall),
                          topRight: Radius.circular(Dimensions.paddingSizeSmall)),
                      child: CustomImageWidget(height: imageSize,width: imageSize,
                          image: '${widget.productModel.thumbnailFullUrl?.path}'),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall,),

                  Flexible(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.productModel.name ?? '', style: robotoRegular.copyWith(
                          color: ColorResources.titleColor(context),fontSize: Dimensions.fontSizeDefault),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBar(rating: averageProductRatting),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text('(${widget.productModel.reviewsCount.toString()})')
                        ],
                      )

                    ],),
                  ),
                  ),
                ],),
              ),

              Positioned(top: 0,right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpeedDial(
                    animationDuration: const Duration(milliseconds: 300),
                    overlayOpacity: 0,
                    icon: Icons.more_horiz,
                    activeIcon: Icons.close,
                    spacing: 3,
                    mini: mini,
                    openCloseDial: isDialOpen,
                    childPadding: const EdgeInsets.all(5),
                    spaceBetweenChildren: 4,
                    buttonSize: buttonSize,
                    childrenButtonSize: childrenButtonSize,
                    visible: visible,
                    direction: speedDialDirection,
                    switchLabelPosition: switchLabelPosition,
                    closeManually: true,
                    renderOverlay: renderOverlay,
                    useRotationAnimation: useRAnimation,
                    backgroundColor: Theme.of(context).cardColor,
                    foregroundColor: Theme.of(context).disabledColor,
                    elevation: extend? 0: 8.0,
                    animationCurve: Curves.elasticInOut,
                    isOpenOnStart: false,
                    shape: customDialRoot ? const RoundedRectangleBorder() : const StadiumBorder(),
                    onOpen: () {
                      setState(() {
                        extend = true;
                      });
                    },
                    onClose: () {
                      setState(() {
                        extend = false;
                      });
                    },
                    children: [
                      SpeedDialChild(elevation: 0,
                        child: Padding(padding: const EdgeInsets.all(8.0),
                            child: Image.asset(Images.editIcon)),

                        onTap:() async {
                        setState(() {
                        isDialOpen.value = false;
                        extend = false;
                        });

                        await Future.delayed(const Duration(milliseconds : 350));
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddProductScreen(product: widget.productModel)));
                        },
                      ),
                      SpeedDialChild( elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(Images.delete),
                        ),
                        onTap: () async {
                          setState(() {
                            isDialOpen.value = false;
                            extend = false;
                          });

                          await Future.delayed(const Duration(milliseconds : 350));
                          showDialog(context: context, builder: (BuildContext context){
                            return ConfirmationDialogWidget(icon: Images.deleteProduct,
                                refund: false,
                                description: getTranslated('are_you_sure_want_to_delete_this_product', context),
                                onYesPressed: () {
                                  Provider.of<ProductController>(context, listen:false).deleteProduct(context ,widget.productModel.id).then((value) {
                                    Provider.of<ProductController>(context,listen: false).getStockOutProductList(1, 'en');
                                    Provider.of<ProductController>(context, listen: false).initSellerProductList(Provider.of<ProfileController>(context, listen: false).
                                    userInfoModel!.id.toString(), 1, context, 'en','', reload: true);
                                  });}
                              );});
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}