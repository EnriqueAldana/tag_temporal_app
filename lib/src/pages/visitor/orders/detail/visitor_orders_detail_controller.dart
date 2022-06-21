import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/order.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/orders_provider.dart';

class VisitorOrdersDetailController extends GetxController{

Order order = Order.fromJson(Get.arguments['order']);
OrdersProvider ordersProvider= OrdersProvider();

var total=0.0.obs;
VisitorOrdersDetailController(){
  print('Orden: ${order.toJson()}');
  getTotal();
}

void getTotal(){
  total.value= 0.0;
  order.products!.forEach((product) {
    total.value = total.value + ( product.quantity! * product.price!);
  });

}

void updateOrderToOnMyWay() async {
  // Actualizar orden al estatus 'EN CAMINO'
  order.status='EN CAMINO';
  ResponseApi responseApi= await ordersProvider.updateStatus(order);
  Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
  if(responseApi.success == true){
    Get.offNamedUntil('/visitor/orders/map', (route) => false);
  }
  else{
    Get.snackbar('Error en la petición', responseApi.message ?? '');
  }
  


}
}