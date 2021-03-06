import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/address.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

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
    //if(GetStorage().read(Constants.SHOPPING_BAG_KEY) != null && GetStorage().read('address') !=null){
    if(GetStorage().read(Constants.SHOPPING_BAG_KEY) != null){
      List<Product> products= [];
      if(GetStorage().read(Constants.SHOPPING_BAG_KEY) is List<Product>){
        products = GetStorage().read(Constants.SHOPPING_BAG_KEY);
      }
      else{
        // Obtenemos la lista de productos de la sesion.
        products = Product.fromJsonList(GetStorage().read(Constants.SHOPPING_BAG_KEY));
      }
     if(products.isNotEmpty){
       Get.toNamed('/resident/address/list');
     }
     else{
       Get.snackbar('Faltan tags por solicitar', 'Su orden est?? vac??a');
       Fluttertoast.showToast(msg: 'Su orden esta vac??a, incluya al menos un tag.', toastLength: Toast.LENGTH_LONG);
     }

    }
    else{
      Get.snackbar('Faltan tags por solicitar', 'Su orden est?? vac??a');
      Fluttertoast.showToast(msg: 'Su orden esta vac??a, incluya al menos un tag.', toastLength: Toast.LENGTH_LONG);

    }

  }
}