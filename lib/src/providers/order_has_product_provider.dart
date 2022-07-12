import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/order_product.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import '../models/user.dart';

class OrderHasProductProvider extends GetConnect {
   String url = '${Environment.API_URL}api/order_has_product';

  User userSession= User.fromJson(GetStorage().read(Constants.USER_KEY) ?? {});

   //http://192.168.1.66:3000/api/order_has_product/getOrderProduct/30/2/1656958930581
   Future<ResponseApi> getOrderProduct(String? idOrder, String? idProduct, String? startDate ) async {
     Response response = await get(
         '$url/getOrderProduct/$idOrder/$idProduct/$startDate',
         headers: {
           'Content-Type': 'application/json',
           'Authorization': userSession.sessionToken ?? ''
         }
     ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

     if( response.statusCode == 401){
       Get.snackbar('Petición denegada', 'No se tiene permiso para traer la lista de ordenes de producto');
     }
     ResponseApi responseApi = ResponseApi.fromJson(response.body);
     print('Respuesta BD. updateStatus ${responseApi}');
     return responseApi;
   }
  Future<ResponseApi> updateStatus(OrderProduct orderProduct) async {
    Response response = await put(
        '$url/updateStatus',
        orderProduct.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }
   Future<ResponseApi> updateLatLng(OrderProduct orderProduct) async {
     Response response = await put(
         '$url/updateLatLng',
         orderProduct.toJson(),
         headers: {
           'Content-Type': 'application/json',
           'Authorization': userSession.sessionToken ?? ''
         }
     ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
     ResponseApi responseApi = ResponseApi.fromJson(response.body);
     return responseApi;
   }

}