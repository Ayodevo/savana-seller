import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class ShowOnMapDialogWidget extends StatelessWidget {
  BillingAddressData? billingAddressData;
  ShowOnMapDialogWidget({Key? key,required this.billingAddressData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Consumer<OrderDetailsController>(
        builder:  (context, resProvider, child) {
          Set<Marker> markers = resProvider.markers;
          return  Dialog(
          child: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(billingAddressData?.latitude ?? ''), double.parse(billingAddressData?.longitude ?? '')),
                  zoom: 15,
                ),
                markers: markers,
                zoomControlsEnabled: false,
                compassEnabled: false,
                indoorViewEnabled: true,
                mapToolbarEnabled: false,
              ),
            )
          ),
        );
      }
    );
  }
}
