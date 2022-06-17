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

class ResidentVisitorListController extends GetxController{

  UsersProvider usersProvider= UsersProvider();
  OrdersProvider ordersProvider= OrdersProvider();
  List<User> users = <User>[];

  User user = User.fromJson(GetStorage().read('user'));

  var  radioValue= 0.obs;

  ResidentVisitorListController(){
  }

  void createOrder() async {
    // Si tenemos bolsa de orden
    if(GetStorage().read('shopping_bag') != null && GetStorage().read('address') !=null){
      Address a = Address.fromJson(GetStorage().read('address') ?? {});
      User u = User.fromJson(GetStorage().read('visitor'));
      List<Product> products= [];

      if(GetStorage().read('shopping_bag') is List<Product>){
        products = GetStorage().read('shopping_bag');
      }
      else{
        // Obtenemos la lista de productos de la sesion.
        products = Product.fromJsonList(GetStorage().read('shopping_bag'));
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
        GetStorage().remove('shopping_bag');
        Get.toNamed('/resident/payments/create');
      }

    }
    else{
      Get.snackbar('Faltan tags por solicitar', 'Su orden está vacía');
      Fluttertoast.showToast(msg: 'Su orden esta vacía, incluya al menos un tag.', toastLength: Toast.LENGTH_LONG);

    }

  }
  Future<List<User>> getVisitorMen() async{
    users= await usersProvider.findVisitorMen();
    User u = User.fromJson(GetStorage().read('visitor') ?? {});
    int index = users.indexWhere((us) => us.id == u.id);
    if(index != -1){ // La direccion almacenada en la sesion coincide con alguna que viene de la base de datos
      radioValue.value= index;
    }
    return users;
  }
  void handleRadioValueChange(int? value){
    radioValue.value=value!;
    print('Valor seleccionado lista de visitantes ${value}');
    GetStorage().write('visitor', users[value].toJson());
    update();  // Redibuja los widgets
  }
  void goToPayment() {
    Get.toNamed('resident/address/create');
  }
}