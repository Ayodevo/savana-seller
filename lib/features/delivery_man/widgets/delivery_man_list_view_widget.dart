import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/delivery_man_card_widget.dart';
import 'package:sixvalley_vendor_app/features/pos/widgets/pos_product_shimmer_widget.dart';



class DeliveryManListViewWidget extends StatelessWidget {
  const DeliveryManListViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManController>(
      builder: (context, prodProvider, child) {
        List<DeliveryMan>? listOfDeliveryMan = [];
        listOfDeliveryMan = prodProvider.listOfDeliveryMan;


        return Column(mainAxisSize: MainAxisSize.min, children: [
          listOfDeliveryMan != null?  listOfDeliveryMan.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listOfDeliveryMan.length,
              itemBuilder: (context, index) {
                return DeliveryManCardWidget(deliveryMan: listOfDeliveryMan![index]);
              },
            ),
          ): Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/5),
            child: const NoDataScreen(),
          ) : const PosProductShimmerWidget(),

          prodProvider.isLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink(),

        ]);
      },
    );
  }
}
