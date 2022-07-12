import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tag_temporal_app/src/models/address.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/pages/resident/address/list/resident_address_list_controller.dart';
import 'package:tag_temporal_app/src/pages/resident/address/map/resident_address_map_page.dart';
import 'package:tag_temporal_app/src/providers/address_provider.dart';

import '../../../../models/user.dart';
class ResidentAddressCreateController extends GetxService {

TextEditingController address_streetController = TextEditingController();
TextEditingController external_numberController = TextEditingController();
TextEditingController internal_numberController = TextEditingController();
TextEditingController neighborhoodController = TextEditingController();
TextEditingController stateController = TextEditingController();
TextEditingController countryController = TextEditingController();
TextEditingController postal_codeController = TextEditingController();
TextEditingController refPointController = TextEditingController();

double latRefPoint = 0;
double lngRefPoint = 0;

User user= User.fromJson(GetStorage().read('user') ?? {});

AddressProvider addressProvider= AddressProvider();

ResidentAddressListController residentAddressListController = Get.find();
void openGoogleMaps(BuildContext context) async {
  Map<String,dynamic>  refPointMap = await showMaterialModalBottomSheet(

      context: context,
      builder: (context) => ResidentAddressMapPage(),
    isDismissible: false,
    enableDrag: false
  );
  print('REF POINT MAP ${refPointMap}');
  latRefPoint= refPointMap['lat'];
  lngRefPoint= refPointMap['lng'];
  refPointController.text= refPointMap['address'];
  address_streetController.text=refPointMap['direction'];
  external_numberController.text=refPointMap['street'];
  neighborhoodController.text=refPointMap['city'];
  stateController.text=refPointMap['department'];
  countryController.text=refPointMap['country'];
}


 void createAddress() async {
  //String addres_street= refPointController.text + address_streetController.text;
   String addres_street= address_streetController.text;
   String external_number = external_numberController.text;
  String internal_number = internal_numberController.text;
  String neighborhood= neighborhoodController.text;
  String state= stateController.text;
  String postal_code= postal_codeController.text;
  String country = countryController.text;
  if(isValidForm(addres_street, external_number, internal_number,neighborhood,postal_code, state, country)){
    Address address = Address(
        addressStreet:addres_street,
        externalNumber:external_number,
        internalNumber:internal_number,
        neighborhood:neighborhood,
        state:state,
        country: country,
        postalCode:postal_code,
        lat:latRefPoint,
        lng:lngRefPoint,
        idUser: user.id
    );
    //print('Direccion x guardar: ${address.toJson()}');
    ResponseApi responseApi= await addressProvider.create(address);
    // Hacer que la nueva direccion vaya a la sesion
    if (responseApi.success == true){
      address.id = responseApi.data;
      GetStorage().write('address', address.toJson()); // Se sube a la sesion la nueva lista de direcciones
      residentAddressListController.update(); // Le pedimos que actualice los widgets
      resetForm();  // reiniciamos a vacio los campos de direccion
      Get.back();  // Regresa a la pantalla anterior, donde se listan las direcciones

    }
    Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);

  }
 }


 bool isValidForm(String addres_street,String external_number,String internal_number,String neighborhood,String postal_code,String state,String country){

  if (addres_street.isEmpty){
    Get.snackbar('Formulario no válido', 'Ingresa la calle');
    return false;
  }
  if (external_number.isEmpty){
    Get.snackbar('Formulario no válido', 'Ingresa el numero exterior ');
    return false;
  }

  if (neighborhood.isEmpty){
    Get.snackbar('Formulario no válido', 'Ingresa la ciudad.');
    return false;
  }

  if (state.isEmpty){
    Get.snackbar('Formulario no válido', 'Ingresa el estado ');
    return false;
  }
  if (country.isEmpty){
    Get.snackbar('Formulario no válido', 'Ingresa el pais');
    return false;
  }
  if (postal_code.isEmpty){
    Get.snackbar('Formulario no válido', 'Ingresa el código postal de la direccion');
    return false;
  }
  if(latRefPoint == 0){
    Get.snackbar('Formulario no válido', 'Selecciona el punto de referencia');
    return false;
  }
  if(lngRefPoint == 0){
    Get.snackbar('Formulario no válido', 'Selecciona el punto de referencia');
    return false;
  }
  return true;
 }

 void resetForm(){
    address_streetController.text="";
    external_numberController.text="";
    internal_numberController.text="";
    neighborhoodController.text="";
    stateController.text="";
    postal_codeController.text="";
    countryController.text="";
    refPointController.text="";
 }
}