import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/address.dart';

import '../../../../models/product.dart';

class ResidentOrdersCreateController extends GetxController{

  List<Product> selectedProducts = <Product>[].obs;
  var total = 0.0.obs;
  var idVisitor= ''.obs;
  ResidentOrdersCreateController(){
    if(GetStorage().read('shopping_bag') != null){
      if(GetStorage().read('shopping_bag') is List<Product>){
        var result = GetStorage().read('shopping_bag');
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
      else{
        // Obtenemos la lista de productos de la sesion.
        var result = Product.fromJsonList(GetStorage().read('shopping_bag'));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
      getTotal();

    }
  }

  void getTotal(){
    total.value= 0.0;
    selectedProducts.forEach((product) {
      total.value = total.value + ( product.quantity! * product.price!);
    });

  }
  void deleteItem(Product product){
    selectedProducts.remove(product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
  }
  void addItem(Product product){
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.remove(product);
    product.quantity = product.quantity! +1;
    selectedProducts.insert(index, product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
  }
  void removeItem(Product product){
    if ( product.quantity! > 1){
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      selectedProducts.remove(product);
      product.quantity = product.quantity! - 1;
      selectedProducts.insert(index, product);
      GetStorage().write('shopping_bag', selectedProducts);
      getTotal();
    }

  }

  void goToAddresList(){
    // Si tenemos bolsa de orden
    if(GetStorage().read('shopping_bag') != null && GetStorage().read('address') !=null){
      List<Product> products= [];
      if(GetStorage().read('shopping_bag') is List<Product>){
        products = GetStorage().read('shopping_bag');
      }
      else{
        // Obtenemos la lista de productos de la sesion.
        products = Product.fromJsonList(GetStorage().read('shopping_bag'));
      }
     if(products.isNotEmpty){
       Get.toNamed('/resident/address/list');
     }
     else{
       Get.snackbar('Faltan tags por solicitar', 'Su orden está vacía');
       Fluttertoast.showToast(msg: 'Su orden esta vacía, incluya al menos un tag.', toastLength: Toast.LENGTH_LONG);
     }

    }
    else{
      Get.snackbar('Faltan tags por solicitar', 'Su orden está vacía');
      Fluttertoast.showToast(msg: 'Su orden esta vacía, incluya al menos un tag.', toastLength: Toast.LENGTH_LONG);

    }

  }
}