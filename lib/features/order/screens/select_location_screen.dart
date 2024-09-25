import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/order/controllers/location_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/features/order/widgets/location_search_dialog_widget.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const SelectLocationScreen({Key? key, required this.googleMapController}) : super(key: key);

  @override
  SelectLocationScreenState createState() => SelectLocationScreenState();
}

class SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;
  final TextEditingController _locationController = TextEditingController();
  CameraPosition? _cameraPosition;

  @override
  void initState() {

    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void _openSearchDialog(BuildContext context, GoogleMapController? mapController) async {
    showDialog(context: context, builder: (context) => LocationSearchDialogWidget(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    _locationController.text = Provider.of<LocationController>(context).address ?? '';

    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('update_address', context)),
      body: Consumer<LocationController>(
        builder: (context, locationProvider, child) {
          return Stack(
            clipBehavior: Clip.none, children: [
            GoogleMap(mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(locationProvider.position.latitude, locationProvider.position.longitude),
                zoom: 16),
              zoomControlsEnabled: false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: true,
              onCameraIdle: () {
                locationProvider.updatePosition(_cameraPosition, true, null, context);
              },
              onCameraMove: ((position) => _cameraPosition = position),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),

            InkWell(onTap: () => _openSearchDialog(context, _controller),
              child: Container(width: MediaQuery.of(context).size.width, height: 55,
                padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 18.0),
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                child: Row(children: [
                  Expanded(child: Text(locationProvider.locationTextEditingController.text.trim(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                   Image.asset(Images.iconsSearch),
                ]),
              ),
            ),

            Positioned(bottom: 0, right: 0, left: 0,
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                SizedBox(width: double.infinity,
                  child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: CustomButtonWidget(btnTxt: getTranslated('select_location', context),
                      onTap: () {
                        if(widget.googleMapController != null) {
                          widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                            locationProvider.pickPosition.latitude, locationProvider.pickPosition.longitude,
                          ), zoom: 16)));
                          locationProvider.setAddAddressData();
                        }
                        Navigator.of(context).pop();},
                    ),
                  ),
                ),
              ],
              ),
            ),
            Center(child: Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 50,)),
            locationProvider.loading ?
            Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) : const SizedBox(),

          ],
          );
        }
      ),
    );
  }
}
