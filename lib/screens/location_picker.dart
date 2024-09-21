import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/location_pick_controller.dart';



class LocationPicker extends StatelessWidget {
  LocationPicker({super.key});

  final LocationPickController _locationPickController = Get.find(tag:"location");
  final AccountController _accountController = Get.find(tag:"account");


  Future<LatLong> getCurrentLocation() async{
    
    try {
      if(_accountController.information.value.location.isEmpty){
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium,timeLimit: const Duration(seconds: 5));
          return LatLong(position.latitude, position.longitude);
      }else{
        return _accountController.information.value.position;
      }
    } catch (e) {
    }
    return const LatLong(52.376372, 4.908066);

  }

  @override
  Widget build(BuildContext context) {
     return  Material(
       child: FutureBuilder<LatLong>(
         future:getCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot<LatLong> snapshot) {
          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
            if(snapshot.data==null){
            }else{
            }
            return  FlutterLocationPicker(
              onError: (e){
              },
              
            mapAnimationDuration: const Duration(milliseconds: 300),
            selectLocationButtonHeight: 50,
            locationButtonBackgroundColor: Colors.green.withOpacity(.5),
            zoomButtonsBackgroundColor: Colors.green.withOpacity(.5),
            selectLocationButtonLeadingIcon: const Icon(Icons.check,color: Colors.white,size: 25,),
            markerIcon: const Icon(Icons.location_on,color: Colors.redAccent,size: 50,),
            selectLocationButtonText: "Select Location",
            selectedLocationButtonTextstyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),
            selectLocationButtonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.green.withOpacity(.7)),
            ), 
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            initPosition: snapshot.data!,
            onPicked: (pickedData) {
              _locationPickController.updateUi(slocation: pickedData.address, sposition: pickedData.latLong);
              
            });
          }
          return const Center(child: CircularProgressIndicator(color: Colors.green,));
        },
        
       )
     );
     
     /*PlacePicker(
          apiKey: "AIzaSyAnDy5hfpzcS8UP_4ZrwuRNtDaUuVIAn58",
          onPlacePicked: (result) { 
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(36.69972940,3.05761990),
          useCurrentLocation: false,
          resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
        
      );*/
      
  }
}