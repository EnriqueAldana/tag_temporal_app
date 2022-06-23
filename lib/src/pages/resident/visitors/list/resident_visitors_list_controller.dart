import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/address.dart';
import 'package:tag_temporal_app/src/models/order.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/providers/orders_provider.dart';
import 'package:tag_temporal_app/src/providers/users_provider.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

class ResidentVisitorListController extends GetxController{

  UsersProvider usersProvider= UsersProvider();
  OrdersProvider ordersProvider= OrdersProvider();
  List<User> users = <User>[];

  User user = User.fromJson(GetStorage().read('user'));

  var  radioValue= 0.obs;
  String? userName='';
  Timer? searchOnStoppedTyping;

  ResidentVisitorListController(){
  }

  void onChangeText(String text){
    const duration = Duration (milliseconds: 800);
    if(searchOnStoppedTyping !=null){
      searchOnStoppedTyping?.cancel();
    }
    searchOnStoppedTyping= Timer(duration, () {
      userName= text;
     print('Texto COMPLETO: ${text}');
     update();
    });

  }
  void createOrder() async {
    // Si tenemos bolsa de orden
    if(GetStorage().read(Constants.SHOPPING_BAG_KEY) != null && GetStorage().read(Constants.ADDRESS_KEY) !=null){
      Address a = Address.fromJson(GetStorage().read(Constants.ADDRESS_KEY) ?? {});
      User u = User.fromJson(GetStorage().read(Constants.VISITOR_KEY));
      List<Product> products= [];

      if(GetStorage().read(Constants.SHOPPING_BAG_KEY) is List<Product>){
        products = GetStorage().read(Constants.SHOPPING_BAG_KEY);
      }
      else{
        // Obtenemos la lista de productos de la sesion.
        products = Product.fromJsonList(GetStorage().read(Constants.SHOPPING_BAG_KEY));
      }
      Order order = Order(
          idResident: user.id,
          idVisitor: u.id,
          idAddress: a.id,
          products: products
      );
      ResponseApi responseApi = await ordersProvider.create(order);

      Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);

      if (responseApi.success == true){
        GetStorage().remove(Constants.SHOPPING_BAG_KEY);
        Get.toNamed('/resident/payments/create');
      }

    }
    else{
      Get.snackbar('Faltan tags por solicitar', 'Su orden está vacía');
      Fluttertoast.showToast(msg: 'Su orden esta vacía, incluya al menos un tag.', toastLength: Toast.LENGTH_LONG);

    }

  }
  Future<List<User>> getVisitorMen(String userName) async{
    print('User name x buscar: ${userName}');
    if(userName.isEmpty){
      print('User name Vacio');
      users= await usersProvider.findVisitorMen();
    }
    else{
     print('Buscando userName: ${userName}');
      users= await usersProvider.findVisitorMenByName(userName);
    }

    User u = User.fromJson(GetStorage().read(Constants.VISITOR_KEY) ?? {});
    int index = users.indexWhere((us) => us.id == u.id);
    if(index != -1){ // La direccion almacenada en la sesion coincide con alguna que viene de la base de datos
      radioValue.value= index;
    }

    return users;
  }
  void handleRadioValueChange(int? value){
    radioValue.value=value!;
    print('Valor seleccionado lista de visitantes ${value}');
    GetStorage().write(Constants.VISITOR_KEY, users[value].toJson());
    update();  // Redibuja los widgets
  }
  void goToPayment() {
    Get.toNamed('resident/address/create');
  }
}