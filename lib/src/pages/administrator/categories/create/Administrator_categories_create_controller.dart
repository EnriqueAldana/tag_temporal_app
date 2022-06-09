
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/categories_provider.dart';

import '../../../../models/category.dart';

class AdministratorCategoriesCreateController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider= CategoriesProvider();

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

  void clearForm(){
    nameController.text = '';
    descriptionController.text = '';
  }

}

