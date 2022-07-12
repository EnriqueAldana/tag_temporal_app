import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/order_product.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/order_has_product_provider.dart';
import 'package:tag_temporal_app/src/providers/orders_provider.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

class VisitorOrdersDetailController extends GetxController{

OrderProduct orderProduct = OrderProduct.fromJson(Get.arguments['orderProduct']);
OrdersProvider ordersProvider= OrdersProvider();
OrderHasProductProvider orderHasProductProvider= OrderHasProductProvider();

var total=0.0.obs;
VisitorOrdersDetailController(){
  getTotal();
}

void getTotal(){
  total.value= 0.0;
    total.value = total.value + ( orderProduct.product!.quantity! * orderProduct.product!.price!);
}

void updateOrderProductToENCAMINO() async {

  // Actualizar el estatus del producto a en camino
  orderProduct.status_product= Constants.ORDER_PRODUCT_STATUS_ENCAMINO;
  ResponseApi responseApi= await orderHasProductProvider.updateStatus(orderProduct);
  Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
  if(responseApi.success == true){
       goToOrderProductMap();
  }
  else{
    Get.snackbar('Error en la petición', responseApi.message ?? '');
  }
}

void goToOrderProductMap(){
  Get.toNamed('/visitor/orders/map', arguments: {
    'order-product': orderProduct.toJson()
  });
}
}