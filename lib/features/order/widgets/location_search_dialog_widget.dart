import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/prediction_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/order/controllers/location_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class LocationSearchDialogWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialogWidget({Key? key, required this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<LocationController>(
      builder: (context, locationController, _) {
        return Container(
          margin: const EdgeInsets.only(top: 55,left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
          alignment: Alignment.topCenter,
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(width: MediaQuery.of(context).size.width,height: 50, child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: locationController.locationTextEditingController,
                textInputAction: TextInputAction.search,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: getTranslated('search_location', context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                  ),
                  hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
                  ),
                  filled: true, fillColor: Theme.of(context).cardColor,
                ),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await Provider.of<LocationController>(context, listen: false).searchLocation(context, pattern);
              },
              itemBuilder: (context, PredictionModel suggestion) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(children: [
                    const Icon(Icons.location_on),
                    Expanded(
                      child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                      )),
                    ),
                  ]),
                );
              },
              onSuggestionSelected: (PredictionModel suggestion) {
                Provider.of<LocationController>(context, listen: false).setLocation(suggestion.placeId, suggestion.description, mapController);
                Navigator.pop(context);
              },
            )),
          ),
        );
      }
    );
  }
}