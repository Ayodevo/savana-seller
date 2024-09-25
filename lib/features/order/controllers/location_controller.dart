import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/place_details_model.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/prediction_model.dart';
import 'package:sixvalley_vendor_app/features/order/domain/services/location_service_interface.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class LocationController with ChangeNotifier {
  final LocationServiceInterface locationServiceInterface;
  LocationController({required this.locationServiceInterface});

  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  bool _loading = false;
  bool get loading => _loading;
  final TextEditingController _locationTextEditingController = TextEditingController();

  Position get position => _position;
  Position get pickPosition => _pickPosition;
  String? _address;
  String? _pickAddress;

  String? get address => _address;
  String? get pickAddress => _pickAddress;
  final List<Marker> _markers = <Marker>[];
  TextEditingController get locationTextEditingController => _locationTextEditingController;

  List<Marker> get markers => _markers;
  bool _changeAddress = true;
  GoogleMapController? _mapController;
  bool _updateAddAddressData = true;

  GoogleMapController? get mapController => _mapController;



  void updatePosition(CameraPosition? position, bool fromAddress, String? address, BuildContext context) async {
    if(_updateAddAddressData) {
      _loading = true;
      notifyListeners();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1, altitudeAccuracy: 1, headingAccuracy: 1
          );
        } else {
          _pickPosition = Position(
            latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1, altitudeAccuracy: 1, headingAccuracy: 1
          );
        }
        if (_changeAddress) {
            String? previousAddress = await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude), context);
            fromAddress ? _address = previousAddress : _pickAddress = previousAddress;

          if(address != null) {
            _locationTextEditingController.text = address;
          }else if(fromAddress) {
            _locationTextEditingController.text = previousAddress;
          }
        } else {
          _changeAddress = true;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      _loading = false;
      notifyListeners();
    }else {
      _updateAddAddressData = true;
    }
  }

  bool isLoading = false;

  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setLocationIntoSelectLocationScreen( String locationAddress){
    locationTextEditingController.text = locationAddress;
  }

  String? chosenAddress = '';
  Future<Position> setLocation(String? placeID, String? address, GoogleMapController? mapController) async {
    _loading = true;
    notifyListeners();

    LatLng latLng = const LatLng(0, 0);
    ApiResponse response = await locationServiceInterface.getPlaceDetails(placeID);
    if(response.response?.statusCode == 200) {
      PlaceDetailsModel placeDetails = PlaceDetailsModel.fromJson(response.response?.data);
      if(placeDetails.status == 'OK') {
        latLng = LatLng(placeDetails.result!.geometry!.location!.lat!, placeDetails.result!.geometry!.location!.lng!);
      }
    }

    _pickPosition = Position(
      latitude: latLng.latitude, longitude: latLng.longitude,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1
    );

    chosenAddress = address;
    locationTextEditingController.text = address??'';
    _changeAddress = false;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
    }
    _loading = false;
    notifyListeners();
    return _pickPosition;
  }


  void setAddAddressData() {
    _position = _pickPosition;
    _address = _pickAddress!;
    _locationTextEditingController.text = _address ?? '';
    _updateAddAddressData = false;
  }


  Future<String> getAddressFromGeocode(LatLng latLng, BuildContext context) async {
    ApiResponse response = await locationServiceInterface.getAddressFromGeocode(latLng);
    String address = '';
    if(response.response!.statusCode == 200 && response.response!.data['status'] == 'OK') {
      address = response.response!.data['results'][0]['formatted_address'].toString();
    }else {
      //ApiChecker.checkApi( response);
    }
    return address;
  }


  List<PredictionModel> predictionList = [];
  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      ApiResponse response = await locationServiceInterface.searchLocation(text);
      if (response.response?.statusCode == 200 && response.response?.data['status'] == 'OK') {
        predictionList = [];
        response.response?.data['predictions'].forEach((prediction) => predictionList.add(PredictionModel.fromJson(prediction)));
      } else {
        showCustomSnackBarWidget(response.response?.data['error_message'] ?? response.response?.statusMessage, Get.context);
      }
    }
    return predictionList;
  }


  void updateInitialPosition(LatLng latLng){
    _position = Position(
      latitude: latLng.latitude, longitude: latLng.longitude, timestamp: DateTime.now(),
      heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1, altitudeAccuracy: 1, headingAccuracy: 1
    );
  }


}
