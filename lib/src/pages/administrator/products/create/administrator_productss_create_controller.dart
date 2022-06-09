
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/categories_provider.dart';

import '../../../../models/category.dart';

class AdministratorProductsCreateController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  CategoriesProvider categoriesProvider= CategoriesProvider();
  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  void createCategory () async {
    String name = nameController.text;
    String description = descriptionController.text;
    print('name : ${name}');
    print('name : ${description}');
    if( name.isNotEmpty && description.isNotEmpty){
        Category category = Category(
          name: name,
          description : description
        );
        ResponseApi  responseApi = await categoriesProvider.create(category);
        Get.snackbar('Proceso terminado', responseApi.message ?? '' );
        if (responseApi.success == true){
          clearForm();
        }
    }
    else{
      Get.snackbar('Formulario no válido', 'Ingresa datos en todos los campos');
    }
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
    priceController.text='';
  }

}

