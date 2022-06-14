import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/product.dart';

class ResidentProductsDetailController extends GetxController {

  List<Product> selectedProducts = [];


void checkIfProductsWasAdded(Product product, var price, var counter){

  price.value = product!.price! ?? 0.0;
  if(GetStorage().read('shopping_bag') != null){
    if(GetStorage().read('shopping_bag') is List<Product>){
      selectedProducts = GetStorage().read('shopping_bag');
    }
    else{
      // Obtenemos la lista de productos de la sesion.
      selectedProducts= Product.fromJsonList(GetStorage().read('shopping_bag'));
    }

    int index = selectedProducts.indexWhere((p) => p.id == product.id);

    if(index != -1){  // Producto ha sido agregado
      counter.value= selectedProducts[index].quantity ?? 0;
      price.value= product.price! * counter.value;

      // Imprimimos los productos agregados a la cesta
      selectedProducts.forEach((p) {
        print('Tag: ${p.toJson()}');
      });
    }
  }
}

  void addToBag(Product product, var price, var counter) {
    if (counter.value > 0){
      // Validar si el producto ya fue agregado con get storage a la sesion del dispositivo
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      if(index == -1) { // No ha sido agregado
        // Significa que el producto no ha sido agregado
        if(product.quantity == null){
          if (counter.value > 0){
            product.quantity= counter.value;
          }
          else{
            product.quantity=1;
          }
        }
        selectedProducts.add(product);
      }
      else{  // Ya ha sido agregado en storage  y solo basta actualizar la cantidad

        selectedProducts[index].quantity = counter.value;
      }
      GetStorage().write('shopping_bag', selectedProducts);
      Fluttertoast.showToast(msg: 'Tag agregado.');
    }
    else{
      Fluttertoast.showToast(msg: 'Deberá seleccionar una cantidad mayor a cero para agregar..');
    }

  }

  void addItem(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = product.price! * counter.value;
  }

  void removeItem(Product product, var price, var counter) {
    if(counter.value > 0){
      counter.value = counter.value - 1;
      price.value = product.price! * counter.value;
    }

  }
}
