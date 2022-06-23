import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/providers/address_provider.dart';
import 'package:tag_temporal_app/src/providers/orders_provider.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

import '../../../../models/address.dart';
import '../../../../models/order.dart';

class ResidentAddressListController extends GetxController {
  List<Address> address= [];
  AddressProvider addressProvider= AddressProvider();
  OrdersProvider ordersProvider= OrdersProvider();
  User user = User.fromJson(GetStorage().read('user'));

  var  radioValue= 0.obs;

  ResidentAddressListController(){
    print('La direccion de sesion ${GetStorage().read(Constants.ADDRESS_KEY)}');
  }
  Future<List<Address>> getAddress() async{
    address= await addressProvider.findByUser(user.id ?? '');

    Address a = Address.fromJson(GetStorage().read(Constants.ADDRESS_KEY) ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);
    if(index != -1){ // La direccion almacenada en la sesion coincide con alguna que viene de la base de datos
      radioValue.value= index;
    }

    return address;
  }


  void handleRadioValueChange(int? value){
    radioValue.value=value!;
    print('Valor seleccionado lista direcciones ${value}');
    GetStorage().write(Constants.ADDRESS_KEY, address[value].toJson());
    update();  // Redibuja los widgets
  }
  void goToAddressCreate() {
    Get.toNamed('resident/address/create');
  }
  void goToVisitorPage(){
    Get.toNamed('/resident/visitor/list');
  }
}