import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';

class ResidentProductsDetailController extends GetxController {

  Product?  product;
  List<Product> selectedProducts = [];
  TextEditingController startedDateController = TextEditingController();
  TextEditingController startedTimeController = TextEditingController();

  DateTime? selectedDate;
  DateTime? ended_date;
  TimeOfDay? selectedTime;
  var price = 0.0.obs;
  ResidentProductsDetailController(Product product){
    this.product= product;
    selectedDate= DateTime.now();
    selectedTime= TimeOfDay.now();
    print('Inicializamos fecha de visita en constructor');
    print(' selectedDate  ${selectedDate}');
    print(' selectedTime  ${selectedTime}');
    startedDateController.text=selectedDate.toString();
    startedTimeController.text=selectedTime.toString();
    // Inicializamos lista de productos seleccionados
    print('Se inicializa lista de productos seleccionados ');
    selectedProducts = [];
    // Cargamos la lista de productos en la bolsa
    print(' Cargamos lista de productos de la bolsa de compra desde agregar producto');
    getSelectedproductsFromSession();

    price.value= product.price ?? 0.0;
  }

  void getSelectedproductsFromSession(){
    if(GetStorage().read('shopping_bag') != null){
      if(GetStorage().read('shopping_bag') is List<Product>){
        var result = GetStorage().read('shopping_bag');
        selectedProducts.clear();
        print('Productos seleccionados removidos');
        selectedProducts.addAll(result);
        print('Productos seleccionados cargados desde la sesion : ${selectedProducts.length}');
      }
      else{
        // Obtenemos la lista de productos de la sesion.
        var result = Product.fromJsonList(GetStorage().read('shopping_bag'));
        selectedProducts.clear();
        print('Productos seleccionados removidos');
        selectedProducts.addAll(result);
        print('Productos seleccionados cargados desde la sesion  mediante Json List: ${selectedProducts.length}');
      }
    }
    else{
      print("No hay bolsa de productos en sesion");
    }
  }
  getDataPicker(BuildContext context) async{
    DateTime? currentDate= await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        builder: (context, child){
              return Theme(data: ThemeData.dark(), child: child! );
        },
    );
    print(' currentDate  ${currentDate}');
    print(' selectedTime  ${selectedTime}');
    if( currentDate!= null){
      selectedDate= currentDate;
      if(selectedTime!=null){
        Duration hours= Duration(hours:selectedTime!.hour,minutes:selectedTime!.minute);
        print(' selectedTime  ${hours}');
        selectedDate= selectedDate!.add(hours);
        print(' selectedDate  ${selectedDate}');
      }
      startedDateController.text=selectedDate.toString();

    }

  }

  getTimePicker(BuildContext context) async{

    TimeOfDay? currentTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      builder: (context, Widget? child){
        return Theme(data: ThemeData.dark(), child: child! );
      });
    if(currentTime != null){
      selectedTime=currentTime;
      startedTimeController.text=selectedTime.toString();
      Duration hours= Duration(hours:selectedTime!.hour,minutes:selectedTime!.minute);
      selectedDate= DateTime(selectedDate!.year,selectedDate!.month,selectedDate!.day);
      selectedDate= selectedDate!.add(hours);
      startedDateController.text=selectedDate.toString();
    }

  }



bool checkIfProductsWasAdded(Product product)  {
    // Agregamos al producto la información de fecha y hora de visita
  // Aqui agregar la fecha final de visita de acuerdo al tiempo de entrega.
  int hours =0;
  if(product.validity_time_hours!= null){
    hours =  product.validity_time_hours!;
  }
  Duration deliveryTime = Duration(hours: hours  );
  ended_date=selectedDate!.add(deliveryTime);
  product.ended_date= ended_date!.millisecondsSinceEpoch;
  List<Product> sessionProducts=[];
  if(GetStorage().read(Constants.SHOPPING_BAG_KEY) != null){
    if(GetStorage().read(Constants.SHOPPING_BAG_KEY) is List<Product>){
      sessionProducts = GetStorage().read(Constants.SHOPPING_BAG_KEY);
    }
    else{
      // Obtenemos la lista de productos de la sesion.
      sessionProducts= Product.fromJsonList(GetStorage().read(Constants.SHOPPING_BAG_KEY));
    }
    print('Productos en la sesion:');
    sessionProducts.forEach((p) {
      print('Tag: ${p.toJsonDate()}');
    });
    print('Producto x buscar: id: ${product.id} startedDate: ${product.started_date} ');
    int index = sessionProducts.indexWhere((p) => (p.id == product.id ) & (p.started_date== product.started_date ));
    if(index != -1){  // Producto se encuentra en la lista de la sesion y por tanto ha sido agregado
      print('Se encontró y NO se agregará');
      return false;
    }
    else{
      print('No se encontró y se agregará');
      sessionProducts.add(product);
      // Se escribe la sesion con la lista de productos seleccionados
      GetStorage().write(Constants.SHOPPING_BAG_KEY, sessionProducts);
      return true;
    }

  }else{
    print('Se crea la sesion con el primer producto');
    sessionProducts.add(product);
    // Se escribe la sesion con la lista de productos seleccionados
    GetStorage().write(Constants.SHOPPING_BAG_KEY, sessionProducts);
    return true;
  }

}

  void addToBag(Product product) {
    if ( isValidForm()){
      // Actualizamos la fecha de inicio al producto
      product.quantity=1;
      product.started_date=selectedDate!.millisecondsSinceEpoch;
      // Validar si el producto ya fue agregado con get storage a la sesion del dispositivo
      // Imprimimos los productos agregados a la cesta
      //print('===============Productos seleccionados ==========');
     // selectedProducts.forEach((p) {
     //   print('Tag: ${p.toJsonDate()}');
     // });

      if(checkIfProductsWasAdded(product)){  // No se encontro en sesion y se agregó
        // Significa que el producto no ha sido agregado
        Fluttertoast.showToast(msg: 'Tag agregado.');
        // Mandar a la lista de productos.
        goToProductList();
      }
      else{ // Ya se agregó a la sesion anteriormente
        Fluttertoast.showToast(msg: 'El tag ya ha sido agregado anteriormente..');
      }

    }
    else{
      Fluttertoast.showToast(msg: 'Deberá seleccionar una fecha y hora de visita..');
    }

  }

  void goToProductList(){
    Get.back();  // Cerrarmos la ventana emergente
  }
   bool isValidForm(){

    if(startedDateController.text.isEmpty){
      Get.snackbar('Formulario no válido', 'Ingresa la fecha de visita');
      Fluttertoast.showToast(msg: 'Deberá seleccionar una fecha de visita para agregar..');
      return false;
    }
    if(startedTimeController.text.isEmpty){
      Get.snackbar('Formulario no válido', 'Ingresa hora de visita');
      Fluttertoast.showToast(msg: 'Deberá seleccionar una hora de visita para agregar..');
      return false;
    }
    return true;
  }

}
