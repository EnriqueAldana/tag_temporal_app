import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../environment/environment.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../models/response_api.dart';
import '../models/user.dart';

class OrdersProvider extends GetConnect {

  String url = '${Environment.API_URL}api/orders';

  User userSession= User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> findByStatus(String status) async {
    Response response = await get(
        '$url/findByStatus/$status',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if( response.statusCode == 401){
      Get.snackbar('Petición denegada', 'No se tiene permiso para traer la lista de ordenes');
      return [];
    }
    List<Order> orders = Order.fromJsonList(response.body);

    return orders;
  }

  Future<ResponseApi> create(Order order) async {
    Response response = await post(
        '$url/create',
        order.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }


}