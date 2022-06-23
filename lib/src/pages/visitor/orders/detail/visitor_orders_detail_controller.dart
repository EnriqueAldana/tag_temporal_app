import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/order.dart';
import 'package:tag_temporal_app/src/models/order_product.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/orders_provider.dart';

class VisitorOrdersDetailController extends GetxController{

OrderProduct orderProduct = OrderProduct.fromJson(Get.arguments['orderProduct']);
OrdersProvider ordersProvider= OrdersProvider();

var total=0.0.obs;
VisitorOrdersDetailController(){
  print('OrdenProduct: ${orderProduct.toJson()}');
  getTotal();
}

void getTotal(){
  total.value= 0.0;
    total.value = total.value + ( orderProduct.product!.quantity! * orderProduct.product!.price!);


}

void updateOrderToOnMyWay() async {
  // Actualizar orden al estatus 'ENCAMINO'
  orderProduct.status='ENCAMINO';
  // Actualizar el estatus del producto

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