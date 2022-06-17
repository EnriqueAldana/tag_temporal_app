import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../providers/orders_provider.dart';

class ResidentOrdersListController extends GetxController{
  OrdersProvider ordersProvider = OrdersProvider();
  // Status
  // 1.- EMITIDO , 2.- PAGADO, 3.- ENCAMINO, 4.- VISITADO, 5.- COMPLETADO
  List<String> status = <String> ['EMITIDO','PAGADO','ENCAMINO','VISITADO','COMPLETO'].obs;
  Future<List<Order>> getOrders(String status) async{
    return await ordersProvider.findByStatus(status);
  }

  void goToOrderDetail(Order order){
    Get.toNamed('/resident/orders/detail', arguments: {
      'order': order.toJson()
    });
  }

}