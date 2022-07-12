import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/order_product.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/providers/products_provider.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

import '../../../../models/order.dart';
import '../../../../providers/orders_provider.dart';

class ResidentOrdersListController extends GetxController{
  ProductsProvider productsProvider = ProductsProvider();
  User user= User.fromJson(GetStorage().read(Constants.USER_KEY) ?? {});

  // Status
  // 1.- EMITIDO , 2.- PAGADO, 3.- ENCAMINO, 4.- VISITADO, 5.- COMPLETADO
  List<String> status = <String> ['ASIGNADO','ENCAMINO','VISITADO','COMPLETO','CANCELADO'].obs;
  Future<List<OrderProduct>> getOrdersProducts(String status) async{
    List<OrderProduct> productList = await productsProvider.findByResidentAndStatus(user.id ?? '0', status);
    productList.forEach((p) {
      print(p.toJson());
    });
    return productList;
  }

  void goToOrderDetail(OrderProduct orderProduct){
    Get.toNamed('/resident/orders/detail', arguments: {
      'orderProduct': orderProduct.toJson()
    });
  }

}