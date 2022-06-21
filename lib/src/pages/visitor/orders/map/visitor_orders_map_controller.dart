import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:tag_temporal_app/src/environment/environment.dart';

class VisitorOrdersMapController extends GetxController {

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(Environment.HOME_LATITUDE,Environment.HOME_LONGITUD),
    zoom: 14
  );

  Completer<GoogleMapController> mapController = Completer();
  Position? position;
  LatLng? addressLatLng;
  var addressName= ''.obs;
  String? direction;
  String? street ;
  String? city ;
  String? department;
  String? neighborhood;
  String? country;

  VisitorOrdersMapController(){
    checkGPS(); // Verificar si el GPS está activo
  }


  Future setLocationDraggableInfo() async {
    double lat = initialPosition.target.latitude;
    double lng= initialPosition.target.longitude;
    List<Placemark> address = await placemarkFromCoordinates(lat, lng);
    if(address.isNotEmpty){

      direction = address[0].thoroughfare ?? '';
      street = address[0].subThoroughfare ?? '';
      city = address[0].locality ?? '';
      department= address[0].administrativeArea ?? '';
      neighborhood = address[0].subAdministrativeArea ?? '';
      country = address[0].country ?? '';
      addressName.value = '$direction #$street, $city,$neighborhood, $department, $country';
      addressLatLng = LatLng(lat, lng);
      print('LAT y LNG: ${addressLatLng?.latitude ?? 0} ${addressLatLng?.longitude ?? 0} ');
      print('Direccion: ${direction}');  // Calle y Numero
      print('Calle: ${street}');         // Numero
      print('Departamento: ${department}');  // Estado
      print('Ciudad: ${city}');              // Ciudad
      print('Localidad: ${neighborhood}');
      print('Pais: ${country}');             // Pais

    }
  }
  void selectRefPoint(BuildContext context){
    if( addressLatLng !=null){
      Map<String,dynamic> data= {
        'address': addressName.value,
        'lat': addressLatLng!.latitude,
        'lng': addressLatLng!.longitude,
        'direction': direction,
        'street': street,
        'city': city,
        'department': department,
        'neighborhood': neighborhood,
        'country': country
      };
      // Regresar del pop up de la ventana los datos
      Navigator.pop(context,data);
    }

  }
  void checkGPS() async {
    bool isLocationEnabled= await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled == true){
        updateLocation();
    }
    else {
      bool locationGPS = await location.Location().requestService();
      if(locationGPS == true){
        updateLocation();
      }
    }
  }
  void updateLocation() async {
    try{

      await _determinePosition();
      position= await Geolocator.getLastKnownPosition(); // Latitud y longitud actual
      //animateCameraPosition(position?.latitude ?? Environment.HOME_LATITUDE,position?.longitude ?? Environment.HOME_LONGITUD);
      animateCameraPosition(position?.latitude ?? Environment.HOME_LATITUDE,position?.longitude ?? Environment.HOME_LONGITUD);

    } catch (e){
      print('Error geoposicion: ${e}');
    }
}
  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(lat,lng),
          zoom: 13,
          bearing: 0
      )
    ));
  }
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('El servicio de localizacion esta deshabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Permisos de localizacion denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Los permisos de localizacion son permanentemente negados, no podemos solicitar permisos.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void onMapCreate(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    mapController.complete(controller);
  }
}