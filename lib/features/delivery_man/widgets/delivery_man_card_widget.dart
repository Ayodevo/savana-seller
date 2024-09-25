
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/delivery_man_details_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/add_new_delivery_man_screen.dart';


class DeliveryManCardWidget extends StatelessWidget {
  final DeliveryMan? deliveryMan;
  final bool isDetails;
  const DeliveryManCardWidget({Key? key, this.deliveryMan, this.isDetails = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isDetails? const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall):
      const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall,5,Dimensions.paddingSizeExtraSmall,Dimensions.paddingSizeSmall),
      child: Slidable(
        key: const ValueKey(0),

        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dragDismissible: false,
          children:  [
            SlidableAction(
              onPressed: (value){
                Provider.of<DeliveryManController>(context, listen: false).deleteDeliveryMan(context, deliveryMan!.id);
              },
              backgroundColor: Theme.of(context).colorScheme.error.withOpacity(.05),
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete_forever_rounded,
              label: getTranslated('delete', context),
            ),

            SlidableAction(
              onPressed: (value){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> AddNewDeliveryManScreen(deliveryMan: deliveryMan)));
              },
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.05),
              foregroundColor: Theme.of(context).primaryColor,
              icon: Icons.edit,
              label: getTranslated('edit', context),
            ),
          ],
        ),

        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (value){
                Provider.of<DeliveryManController>(context, listen: false).deleteDeliveryMan(context, deliveryMan!.id);
              },
              backgroundColor: Theme.of(context).colorScheme.error.withOpacity(.05),
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete_forever_rounded,
              label: getTranslated('delete', context),
            ),

            SlidableAction(
              onPressed: (value){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> AddNewDeliveryManScreen(deliveryMan: deliveryMan)));
              },
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.05),
              foregroundColor: Theme.of(context).primaryColor,
              icon: Icons.edit,
              label: getTranslated('edit', context),
            ),
          ],
        ),

        child: GestureDetector(
          onTap: () {
            if(!isDetails){
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => DeliveryManDetailsScreen(deliveryMan: deliveryMan)));
            }
          },

          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(isDetails? 0 : Dimensions.paddingSizeSmall),
                boxShadow: [BoxShadow(color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).primaryColor.withOpacity(0):
                Theme.of(context).primaryColor.withOpacity(.125), blurRadius: 1,spreadRadius: 1,offset: const Offset(0,0))]
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: isDetails? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault):
                      const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Container(decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(.10),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),),
                        width: Dimensions.stockOutImageSize,
                        height: Dimensions.stockOutImageSize,


                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          child: CustomImageWidget(  height: Dimensions.imageSize,width: Dimensions.imageSize,
                              image: '${deliveryMan!.imageFullUrl?.path}'),

                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(children: [

                        const SizedBox(height: Dimensions.paddingSizeSmall,),

                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text('${deliveryMan!.fName!} ${deliveryMan!.lName!}', style: robotoMedium.copyWith(
                                      color: ColorResources.titleColor(context),fontSize: Dimensions.fontSizeDefault),
                                      maxLines: 1, overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(width: 100)
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                              child: Row(children: [
                                const Icon(Icons.star_rate_rounded, color: Colors.orange),
                                Text(deliveryMan!.rating!.isNotEmpty? double.parse(deliveryMan!.rating![0].average!).toStringAsFixed(1) : '0', style: robotoMedium,),
                              ],),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                                ),
                                child: Text('${NumberFormat.compact().format(deliveryMan!.orders!.isNotEmpty? deliveryMan!.orders![0].count : 0)} ${getTranslated('orders', context)}',
                                  style: robotoMedium.copyWith(color: Colors.white),),
                              ),
                            )

                          ],),
                        ),
                      ],),
                    ),
                  ],
                ),
                Align(
                  alignment: Provider.of<LocalizationController>(context, listen: false).isLtr ? Alignment.bottomRight : Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisSize: MainAxisSize.min,children: [
                      deliveryMan!.isOnline == 1?
                      const Icon(Icons.check_circle, size: Dimensions.iconSizeDefault, color: Colors.green):
                      Icon(Icons.cancel, size: Dimensions.iconSizeDefault, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: Dimensions.paddingSizeVeryTiny),
                      deliveryMan!.isOnline == 1?
                      Text(getTranslated('online', context)!,style: robotoMedium.copyWith(color: Colors.green),):
                      Text(getTranslated('offline', context)!,style: robotoMedium.copyWith(color: Theme.of(context).colorScheme.error),)
                    ],),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}
