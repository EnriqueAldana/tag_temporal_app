import 'dart:async';

import 'package:flutter/widgets.dart';
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

class ResidentOrdersMapController extends GetxController {

  Socket socket = io('${Environment.API_URL}orders/visitor', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });
  OrderProduct orderProduct= OrderProduct.fromJson(Get.arguments['order-product-resident'] ?? {});
  OrderHasProductProvider orderHasProductProvider= OrderHasProductProvider();
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
  double? lat_lastPositionVisitor;
  double? lng_lastPositionVisitor;

  ResidentOrdersMapController(){
    lastPositionVisitor();
    checkGPS(); // Verificar si el GPS está activo
    connectAndListen();
  }

  void lastPositionVisitor() async{
    ResponseApi responseApi= ResponseApi();
    responseApi= await orderHasProductProvider.getOrderProduct(orderProduct.idOrder , orderProduct.product!.id , orderProduct.product!.started_date.toString());
    if(responseApi.success == true){
      lat_lastPositionVisitor= responseApi.data['lat'];
      lng_lastPositionVisitor= responseApi.data['lng'];

    }
  }

  void connectAndListen(){
    socket.connect();
    socket.onConnect((data){
      print('Este dispositivo se conectó a Scoket IO');
    });
    listenPosition();
    listenToVisited();
  }

  void listenPosition(){
    socket.on('position/${orderProduct.idOrder}', (data){
      print('Datos de la posicion: ${data}');
      if(data['id_order']== orderProduct.idOrder
      && data['id_product'] == orderProduct.product!.id
      && data['starter_date'] == orderProduct.product!.started_date
      ){
        addMarker('Visitante',
            data['lat'],
            data['lng'],
            'Tu visitate',
            '',
            visitorMarker!);
      }
      });

  }

  void listenToVisited(){
    socket.on('visited/${orderProduct.idOrder}', (data){
     // print('Datos de la orden Producto actualizada: ${data}');
      if(data['id_order']== orderProduct.idOrder
          && data['id_product'] == orderProduct.product!.id
          && data['starter_date'] == orderProduct.product!.started_date
      ){
        // Enviar al residente al home
        Fluttertoast.showToast(msg: 'El estado del tag se ha actualizado a VISITADO...',
        toastLength: Toast.LENGTH_LONG);
      Get.offNamedUntil('/resident/home', (route) => false);
      }
    });
  }
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(Environment.HOME_LATITUDE,Environment.HOME_LONGITUD),
    zoom: 14
  );


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
      print('Actualiza posicion desde el residente');
      animateCameraPosition(orderProduct.lat ?? Environment.HOME_LATITUDE,orderProduct.lng ?? Environment.HOME_LONGITUD);
      addMarker('Visitante',
          lat_lastPositionVisitor ?? 20.675687,
          lng_lastPositionVisitor ?? -103.339599,
          'Tu visitate',
          '',
          visitorMarker!);

      addMarker('Residente',
          orderProduct.address?.lat ?? 20.675687,
          orderProduct.address?.lng?? -103.339599,
          'Lugar de visita',
          '',
          residentMarker!);
      LatLng from = LatLng(lat_lastPositionVisitor ?? 20.675687, lng_lastPositionVisitor ?? -103.339599);
      LatLng to = LatLng(orderProduct.address!.lat ?? 20.675687, orderProduct.address!.lng ?? -103.339599);

      setPolylines(from,to);


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
    String number = orderProduct.visitor!.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
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

  // Sobre escribir el metodo al cerrar la pantalla
// para dejar de escuchar la posicion de Google maps

  @override
  void onClose() {
    super.onClose();
    socket.disconnect();
    positionSubscribe?.cancel();
  }
}