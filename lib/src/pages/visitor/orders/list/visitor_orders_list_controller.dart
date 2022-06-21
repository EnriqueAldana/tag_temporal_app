import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/user.dart';

import '../../../../models/order.dart';
import '../../../../providers/orders_provider.dart';

class VisitorOrdersListController extends GetxController{
  OrdersProvider ordersProvider = OrdersProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  // Status
  // 1.- EMITIDO , 2.- PAGADO, 3.- POR VISITAR 4.- EN CAMINO, 5.- VISITADO, 6.- COMPLETADO
  List<String> status = <String> ['POR VISITAR','EN CAMINO','VISITADO','COMPLETO'].obs;
  Future<List<Order>> getOrders(String status) async{
    return await ordersProvider.findByVisitorAndStatus(user.id ?? '0', status);
  }

  void goToOrderDetail(Order order){
    Get.toNamed('/visitor/orders/detail', arguments: {
      'order': order.toJson()
    });
  }

}