
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/categories_provider.dart';

import '../../../../models/category.dart';
import '../../../../providers/products_provider.dart';

class AdministratorProductsCreateController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController validityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  CategoriesProvider categoriesProvider= CategoriesProvider();
  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

var  idCategory=''.obs;

  List<Category> categories= <Category>[].obs;

  ProductsProvider productsProvider = ProductsProvider();
  AdministratorProductsCreateController(){
    getCategories();
  }
  void getCategories() async {
    var result= await categoriesProvider.gerAll();
    categories.clear();
    categories.addAll(result);

  }

  void createProduct (BuildContext context) async {
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;
    String validity= validityController.text;

    print('name : ${name}');
    print('description : ${description}');
    print('PRICE : ${price}');
    print('ID CATEGORY : ${idCategory}');
    ProgressDialog progressDialog= ProgressDialog(context: context);
    if( isValidForm(name,description,validity,price)){
        Product product = Product(
          name: name,
          description : description,
            validity_time_hours: int.parse(validity),
          price: double.parse(price),
          idCategory: idCategory.value
        );
        List<File> images = [];
        images.add(imageFile1!);
        images.add(imageFile2!);
        images.add(imageFile3!);

        progressDialog.show(max: 100, msg: 'Espere un momento...');
        Stream stream = await productsProvider.create(product, images);
        stream.listen((res) { 
          progressDialog.close();
          ResponseApi responseApi= ResponseApi.fromJson(json.decode(res));
          Get.snackbar('Proceso terminado.', responseApi.message ?? '');
          if(responseApi.success == true){
            clearForm();
          }


        });
    }

  }

  bool isValidForm(String name, String description , String validity,String price){

    if (name.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el nombre del producto');
      return false;
    }

    if (description.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa la descripción del producto');
      return false;
    }
    if(validity.isEmpty){
      Get.snackbar('Formulario no valido', 'Ingresa la vigencia del producto');
      return false;
    }

    if (price.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el precio del producto.');
      return false;
    }
    if(idCategory.value == ''){
      Get.snackbar('Formulario no valido', 'Selecciona una categoría para el producto');
      return false;
    }

    if(imageFile1 == null){
      Get.snackbar('Formulario no valido', 'Dá click y selecciona una primera imagen para el procuto');
      return false;
    }
    if(imageFile2 == null){
      Get.snackbar('Formulario no valido', 'Dá click y selecciona una segunda imagen para el procuto');
      return false;
    }
    if(imageFile3 == null){
      Get.snackbar('Formulario no valido', 'Dá click y selecciona una tercera imagen para el procuto');
      return false;
    }
    return true;

  }
  Future selectImage(ImageSource imagenSource, int numberFile) async{
    XFile? image= await picker.pickImage(source: imagenSource);
    if (image != null) {
      if(numberFile == 1){
        imageFile1 = File(image.path);
      }
      if(numberFile == 2){
        imageFile2 = File(image.path);
      }
      if(numberFile == 3){
        imageFile3 = File(image.path);
      }

      update();    // Obligamos a redibujar los widyets
    }
  }
  void showAlertDialog(BuildContext context, int numberFile ){

    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();  // Cerramos el alert
          selectImage(ImageSource.gallery,numberFile);
        },
        child: Text('Galeria',
            style: TextStyle(
                color: Colors.black
            ))
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();  // Cerramos el alert
          selectImage(ImageSource.camera,numberFile);
        },
        child: Text('Camara',
            style: TextStyle(
                color: Colors.black
            )
        ));

    AlertDialog alertDialog = AlertDialog(
        title: Text('Seleccione una opción'),
        actions: [
          galleryButton,
          cameraButton
        ]
    );

    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }
  void clearForm(){
    nameController.text = '';
    descriptionController.text = '';
    validityController.text='';
    priceController.text='';
    priceController.text='';
    imageFile1= null;
    imageFile2= null;
    imageFile3= null;
    idCategory.value='';
    update();
  }

}

