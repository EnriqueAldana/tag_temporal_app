import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tag_temporal_app/src/environment/environment.dart';
import 'package:tag_temporal_app/src/models/order_product.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/order_has_product_provider.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

class VisitorOrdersMapController extends GetxController {

  Socket socket = io('${Environment.API_URL}orders/visitor', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  OrderProduct orderProduct= OrderProduct.fromJson(Get.arguments['order-product'] ?? {});
  OrderHasProductProvider orderHasProductProvider= OrderHasProductProvider();

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

  Map<MarkerId, Marker> markers = <MarkerId,Marker>{}.obs;
  BitmapDescriptor? visitorMarker;
  BitmapDescriptor? residentMarker;

  StreamSubscription? positionSubscribe;

  Set<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> points = [];

  double distanceBetween = 0.0;
  bool isClose = false;

  VisitorOrdersMapController(){
    print('Order-Product: ${orderProduct.toJson()}');

    checkGPS(); // Verificar si el GPS está activo
    connectAndListen();  // Conectar al socket del server
  }

    void isCloseToVisitPosition(){
      if(position !=null){
        distanceBetween = Geolocator.distanceBetween(
            position!.latitude,
            position!.longitude,
            orderProduct.address?.lat ?? 20.675687,
            orderProduct.address?.lng?? -103.339599
        );
        print('Distancia entre el visitante y el residente ${distanceBetween}');
        if (distanceBetween<= Environment.METERS_TO_ARRIVE && isClose == false){
          isClose=true;
        }
      }


    }
  void connectAndListen(){
    socket.connect();
    socket.onConnect((data){
      print('Este dispositivo se conectó a Scoket IO');
    });
    listenToCanceled();
  }

    void emitPosition() {
        if(position != null){
          socket.emit('position',{
            'id_order': orderProduct.idOrder,
            'id_product': orderProduct.product!.id,
            'starter_date': orderProduct.product!.started_date,
            'lat': position!.latitude,
            'lng': position!.longitude
          });
        }
    }
  void emitToVisited() {
      socket.emit('visited',{
        'id_order': orderProduct.idOrder,
        'id_product': orderProduct.product!.id,
        'starter_date': orderProduct.product!.started_date
      });
  }
  void listenToCanceled(){
    socket.on('canceled/${orderProduct.idOrder}', (data){
      // print('Datos de la orden Producto actualizada: ${data}');
      if(data['id_order']== orderProduct.idOrder
          && data['id_product'] == orderProduct.product!.id
          && data['starter_date'] == orderProduct.product!.started_date
      ){
        // Enviar al Visitante al home
        Fluttertoast.showToast(msg: 'El estado del tag se ha actualizado a CANCELADO...',
            toastLength: Toast.LENGTH_LONG);
        Get.offNamedUntil('/visitor/home', (route) => false);
      }
    });
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
  void updateOrderProductToVisited() async {
    if(distanceBetween <= Environment.METERS_TO_ARRIVE){

      OrderProduct orderProductToUpdate= orderProduct;
      orderProductToUpdate.status_product=Constants.ORDER_PRODUCT_STATUS_VISITADO;
      ResponseApi responseApi= await orderHasProductProvider.updateStatus(orderProductToUpdate);
      Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if(responseApi.success == true){
        emitToVisited();  // Emitimos un mensaje de que se actualizo la orden de visita.
        Get.offNamedUntil('/visitor/home', (route) => false);
      }
    }
    else{
      Get.snackbar('Operación no permitida', 'Se debe estar más cerca a la posicion del domicilio de visita');
    }


  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
        configuration, path);
    return descriptor;
  }
  void addMarker(
      String marketId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMaker
      ){
      MarkerId id= MarkerId(marketId);
      Marker marker= Marker(
          markerId: id,
        icon: iconMaker,
        position: LatLng(lat,lng),
        infoWindow: InfoWindow(title: title,snippet: content)
      );
    markers[id] = marker;
    update();
  }
  void checkGPS() async {

    visitorMarker= await createMarkerFromAssets('assets/img/taxi_icon.png');
    residentMarker= await createMarkerFromAssets('assets/img/home.png');

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

  LocationSettings locationSettings= LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 1
  );


  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFrom,
        pointTo
    );

    for(PointLatLng point in result.points){
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
      color: Colors.amber,
      points: points,
      width: 5
    );

    polylines.add(polyline);
    // actualizamos al cambiar el observable yu actualice la pantalla
    update();
  }

  void updateLocation() async {
    try{
      await _determinePosition();
      position= await Geolocator.getLastKnownPosition(); // Latitud y longitud actual se toma una sola vez
      saveLocation();
      animateCameraPosition(position?.latitude ?? Environment.HOME_LATITUDE,position?.longitude ?? Environment.HOME_LONGITUD);
      addMarker('Visitante',
          position?.latitude ?? 20.675687,
          position?.longitude ?? -103.339599,
          'Tu posición',
          '',
          visitorMarker!);

      addMarker('Residente',
          orderProduct.address?.lat ?? 20.675687,
          orderProduct.address?.lng?? -103.339599,
          'Lugar de visita',
          '',
          residentMarker!);
      LatLng from = LatLng(position!.latitude, position!.longitude);
      LatLng to = LatLng(orderProduct.address!.lat ?? 20.675687, orderProduct.address!.lng ?? -103.339599);

      setPolylines(from,to);

      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1
      );

      positionSubscribe= Geolocator.getPositionStream(
        locationSettings: locationSettings
      ).listen((Position pos){ // Posicion en tiempo real
          position= pos;
          addMarker('Visitante',
              position?.latitude ?? 20.675687,
              position?.longitude ?? -103.339599,
              'Tu posición',
              '',
              visitorMarker!);
          animateCameraPosition(position?.latitude ?? Environment.HOME_LATITUDE,position?.longitude ?? Environment.HOME_LONGITUD);
          // Actualizar position al socket
          emitPosition();
          isCloseToVisitPosition(); // Calcula la posicion actual del visitante y la de entrega

      });
    } catch (e){
      print('Error geoposicion: ${e}');
    }
}

void centerPosition() {
    if (position != null){
      animateCameraPosition(position!.latitude, position!.longitude);
    }

}
void callNumber() async{
    String number = orderProduct.resident!.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }
void saveLocation() async {
    if(position != null){
      orderProduct.lat= position!.latitude;
      orderProduct.lng= position!.longitude;
      await orderHasProductProvider.updateLatLng(orderProduct);
    }

}
  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(lat,lng),
          zoom: 14,
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

  void onMapCreate(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    mapController.complete(controller);
  }

  // Sobre escribir el metodo al cerrar la pantalla
// para dejar de escuchar la posicion de Google maps

  @override
  void onClose() {
    super.onClose();
    socket.disconnect();
    positionSubscribe?.cancel();
  }
}