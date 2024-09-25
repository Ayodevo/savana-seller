import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/domain/model/top_delivery_man.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/delivery_man_order_history_widget.dart';


class DeliveryManOrderListScreen extends StatelessWidget {
  final DeliveryMan? deliveryMan;
  const DeliveryManOrderListScreen({Key? key, this.deliveryMan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryManController>(
      builder: (context, order, child) {
        List<Order> orderList = [];
        orderList = order.deliverymanOrderList;
        return  order.deliverymanOrderList.isNotEmpty ?
        RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await order.getDeliveryManOrderList(context,1,deliveryMan!.id);
          },
          child: ListView.builder(
            itemCount: orderList.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return DeliveryManOrderHistoryWidget(orderModel: orderList[index]);
            }
          ),
        ) : const NoDataScreen(title: 'no_order_found');
      }
    );
  }
}
