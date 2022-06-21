import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/product.dart';

class ResidentProductsDetailController extends GetxController {

  List<Product> selectedProducts = [];

  TextEditingController startedDateController = TextEditingController();
  TextEditingController startedTimeController = TextEditingController();

  DateTime? selectedDate;
  DateTime? ended_date;
  TimeOfDay? selectedTime;

  ResidentProductsDetailController(){
    selectedDate= DateTime.now();
    selectedTime= TimeOfDay.now();
  }

  getDataPicker(BuildContext context) async{

    selectedDate= await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        builder: (context, child){
              return Theme(data: ThemeData.dark(), child: child! );
        },
    );
    updateVisitDateWithTime();

  }

  getTimePicker(BuildContext context) async{

    selectedTime= await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      builder: (context, Widget? child){
        return Theme(data: ThemeData.dark(), child: child! );
      },);

    updateVisitDateWithTime();
  }

  void updateVisitDateWithTime(){
    if(selectedDate != null){
      startedDateController.text=selectedDate.toString();
    }
    if(selectedTime != null){
      startedTimeController.text=selectedTime!.hour.toString() + ':' + selectedTime!.minute.toString();
      Duration horasYMinutos= Duration(hours: selectedTime!.hour, minutes: selectedTime!.minute);
      // Fijar horas y minutos de la fecha a cero
      selectedDate= new DateTime(selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day);
      selectedDate= selectedDate!.add(horasYMinutos);
      startedDateController.text= selectedDate.toString();
    }
    int timestamp = selectedDate!.millisecondsSinceEpoch;
    print(' timestamp de la fecha seleccionada  ${timestamp}');
    final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp);
    print('Fecha seleccionada ${date1}');
  }
void checkIfProductsWasAdded(Product product, var price, var counter){

  price.value = product.price ?? 0.0;
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

      // Aqui validar que el producto no tenga el id y la fecha inicial igual
      int index = selectedProducts.indexWhere((p) => (p.id == product.id) && (p.started_date == product.started_date));
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
        product.started_date=selectedDate!.millisecondsSinceEpoch;
        // Aqui agregar la fecha final de visita de acuerdo al tiempo de entrega.
        int hours =0;
        if(product.delivery_time_hours!= null){
           hours =  product.delivery_time_hours!;
        }
        Duration deliveryTime = Duration(hours: hours  );
        ended_date=selectedDate!.add(deliveryTime);
        product.ended_date= ended_date!.millisecondsSinceEpoch;
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

  // No son usados
  void addItem(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = product.price! * counter.value;
  }

  // No son usados
  void removeItem(Product product, var price, var counter) {
    if(counter.value > 0){
      counter.value = counter.value - 1;
      price.value = product.price! * counter.value;
    }

  }
}
