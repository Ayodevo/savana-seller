import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/title_row_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/screens/top_delivery_man_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/top_delivery_man_widget.dart';



class TopDeliveryManViewWidget extends StatelessWidget {
  final bool isMain;
  const TopDeliveryManViewWidget({Key? key, this.isMain = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManController>(
      builder: (context, deliveryProvider, child) {
        List<DeliveryMan>? deliveryManList;
        deliveryManList = deliveryProvider.topDeliveryManList;


        return Column(mainAxisSize: MainAxisSize.min, children: [

          isMain?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            child: Row(
              children: [
                SizedBox(width: Dimensions.iconSizeDefault, child: Image.asset(Images.topDeliveryMan)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Expanded(
                  child: TitleRowWidget(title: '${getTranslated('top_delivery_man', context)}',
                    onTap: (deliveryManList != null && deliveryManList.length > 4) ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TopDeliveryMAnScreen())) : null),
                ),
              ],
            ),
          ):const SizedBox(),

          !deliveryProvider.isLoading ? deliveryManList!.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeSmall),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: .75
              ),
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isMain && deliveryManList.length > 4 ? 4: deliveryManList.length,
              itemBuilder: (context, index) {

                return TopDeliveryManWidget(deliveryMan : deliveryManList![index]);
              },
            ),
          ): Padding(padding: EdgeInsets.only(top: isMain ? 0.0 :MediaQuery.of(context).size.height/3),
            child: const NoDataScreen(title: 'no_deliveryman_found'),
          ) :const SizedBox.shrink(),

          deliveryProvider.isLoading ? Center(child: Padding(padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink(),

        ]);
      },
    );
  }
}
