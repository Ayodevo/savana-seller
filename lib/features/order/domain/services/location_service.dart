
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixvalley_vendor_app/features/order/domain/repositories/location_repository_interface.dart';
import 'package:sixvalley_vendor_app/features/order/domain/services/location_service_interface.dart';

class LocationService implements LocationServiceInterface{
  final LocationRepositoryInterface locationRepositoryInterface;
  LocationService({required this.locationRepositoryInterface});


  @override
  Future getAddressFromGeocode(LatLng latLng) {
    return locationRepositoryInterface.getAddressFromGeocode(latLng);
  }

  @override
  Future getPlaceDetails(String? placeID) {
    return locationRepositoryInterface.getPlaceDetails(placeID);
  }

  @override
  Future searchLocation(String text) {
    return locationRepositoryInterface.searchLocation(text);
  }

}