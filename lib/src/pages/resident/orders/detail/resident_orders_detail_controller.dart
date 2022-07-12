import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tag_temporal_app/src/environment/environment.dart';
import 'package:tag_temporal_app/src/models/order.dart';
import 'package:tag_temporal_app/src/models/order_product.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/order_has_product_provider.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

class ResidentOrdersDetailController extends GetxController{

  Socket socket = io('${Environment.API_URL}orders/visitor', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  OrderProduct orderProduct = OrderProduct.fromJson(Get.arguments['orderProduct']);
OrderHasProductProvider orderHasProductProvider= OrderHasProductProvider();


var total=0.0.obs;
ResidentOrdersDetailController(){
  print('OrdenProduct: ${orderProduct.toJson()}');
  getTotal();
}

void getTotal(){
  total.value= 0.0;
  total.value = total.value + ( orderProduct.product!.quantity! * orderProduct.product!.price!);
}

  void goToOrderProductMap(){
    Get.toNamed('/resident/orders/map', arguments: {
      'order-product-resident': orderProduct.toJson()
    });
  }

void emitToCanceled() {
  socket.emit('canceled',{
    'id_order': orderProduct.idOrder,
    'id_product': orderProduct.product!.id,
    'starter_date': orderProduct.product!.started_date
  });
}
void updateOrderToOnCancel() async {
  // Actualizar el estatus del producto a CANCELADO

  OrderProduct orderProductToUpdate= orderProduct;
  orderProductToUpdate.status_product=Constants.ORDER_PRODUCT_STATUS_CANCELADO;
  ResponseApi responseApi= await orderHasProductProvider.updateStatus(orderProductToUpdate);
  Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
  if(responseApi.success == true){
    // Aqui emitir mensaje para que el Visitante se entere
    emitToCanceled();
    Get.offNamedUntil('/resident/home', (route) => false);
  }
  else{
    Get.snackbar('Error en la petición', responseApi.message ?? '');
  }
}

}