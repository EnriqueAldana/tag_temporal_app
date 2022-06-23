import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/order_product.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/providers/products_provider.dart';

import '../../../../models/order.dart';
import '../../../../providers/orders_provider.dart';

class VisitorOrdersListController extends GetxController{
  ProductsProvider productsProvider = ProductsProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  // Status
  // 1.- EMITIDO , 2.- PAGADO, 3.- POR VISITAR 4.- EN CAMINO, 5.- VISITADO, 6.- COMPLETADO
  List<String> status = <String> ['ASIGNADO','ENCAMINO','VISITADO','COMPLETO'].obs;
  Future<List<OrderProduct>> getOrders(String status) async{
    //print('Trayendo productos x Visitante ${user.id} y Estatus ${status}');
    List<OrderProduct> productList = await productsProvider.findByVisitorAndStatus(user.id ?? '0', status);
    return productList;
  }

  void goToOrderDetail(OrderProduct orderProduct){
    Get.toNamed('/visitor/orders/detail', arguments: {
      'orderProduct': orderProduct.toJson()
    });
  }

}