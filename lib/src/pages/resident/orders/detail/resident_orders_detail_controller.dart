import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/order.dart';

class ResidentOrdersDetailController extends GetxController{

Order order = Order.fromJson(Get.arguments['order']);

var total=0.0.obs;
ResidentOrdersDetailController(){
  print('Orden: ${order.toJson()}');
  getTotal();
}

void getTotal(){
  total.value= 0.0;
  order.products!.forEach((product) {
    total.value = total.value + ( product.quantity! * product.price!);
  });

}
}