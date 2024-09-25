import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/order_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/delivery_man_collected_cash_card_widget.dart';



class CollectedCashFromDeliveryManScreen extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  const CollectedCashFromDeliveryManScreen({Key? key, this.deliveryMan}) : super(key: key);

  @override
  State<CollectedCashFromDeliveryManScreen> createState() => _CollectedCashFromDeliveryManScreenState();
}

class _CollectedCashFromDeliveryManScreenState extends State<CollectedCashFromDeliveryManScreen> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManController>(
        builder: (context, collectedCashController, child) {

          return collectedCashController.collectedCashModel != null ?
          ( collectedCashController.collectedCashModel!.collectedCash != null && collectedCashController.collectedCashModel!.collectedCash!.isNotEmpty) ?
          RefreshIndicator(
            backgroundColor: Theme.of(context).primaryColor,
            onRefresh: () async {
              await collectedCashController.getDeliveryCollectedCashList(context, widget.deliveryMan!.id, 1);
            },
            child: SingleChildScrollView(
              controller: scrollController,
              child: PaginatedListViewWidget(
                reverse: false,
                scrollController: scrollController,
                totalSize: collectedCashController.collectedCashModel?.totalSize,
                offset: collectedCashController.collectedCashModel != null ? int.parse(collectedCashController.collectedCashModel!.offset.toString()) : null,
                onPaginate: (int? offset) async {
                  if (kDebugMode) {
                    print('==========offset========>$offset');
                  }
                  await collectedCashController.getDeliveryCollectedCashList(context, widget.deliveryMan!.id, offset!);
                },

                itemView: ListView.builder(
                  itemCount: collectedCashController.collectedCashModel!.collectedCash?.length,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return DeliveryManCollectedCashCardWidget(collectedCash: collectedCashController.collectedCashModel!.collectedCash![index], index: index);
                  },
                ),
              ),
            ),

          ) : const NoDataScreen(title: 'no_order_found',) : const OrderShimmerWidget(isEnabled: true);
        }
    );
  }
}

