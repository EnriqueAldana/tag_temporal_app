import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


import '../../../../models/response_api.dart';
import '../../../../models/user.dart';
import '../../../../providers/users_provider.dart';
import '../info/resident_profile_info_controller.dart';

class ResidentProfileUpdateController extends GetxController{

  User user = User.fromJson(GetStorage().read('user'));

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController lastname2Controller = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;
  UsersProvider usersProvider= UsersProvider();

  ResidentProfileInfoController  residentProfileInfoController = Get.find();

  ResidentProfileUpdateController() {
    emailController.text = user.email ?? '';
    nameController.text = user.name ?? '';
     lastnameController.text = user.lastname ?? '';
     lastname2Controller.text = user.lastname2 ?? '';
     phoneController.text = user.phone ?? '';
     passwordController.text = user.password ?? '';
     confirmPasswordController.text = user.password ?? '';
   /* if(imageFile == null){
      if(user.imagePath != null){
        imageFile= NetworkImage(user.imagePath!) as File?;
      }
    }*/


  }

  bool isValidForm(
      String email,
      String name,
      String lastname,
      String lastname2,
      String phone
      ) {

    if (email.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar el email');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Formulario no valido', 'El email no es valido');
      return false;
    }

    if (name.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu nombre');
      return false;
    }

    if (lastname.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu apellido paterno');
      return false;
    }
    if (lastname2.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu apellido materno');
      return false;
    }
    if (phone.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu numero telefonico');
      return false;
    }


    return true;
  }

  void updateInfo( BuildContext context) async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String lastname2 = lastname2Controller.text.trim();
    String phone = phoneController.text.trim();

    if (isValidForm(email, name, lastname,lastname2, phone)) {

      ProgressDialog progressDialog= ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando usuario...');

      User Myuser = User(
        id: user.id,
        email: email,
        name: name,
        lastname: lastname,
        lastname2: lastname2,
        phone: phone,
        sessionToken: user.sessionToken
      );

        if(imageFile == null){
          ResponseApi responseApi= await usersProvider.update(Myuser);
          Get.snackbar('Proceso terminado de actualizacion sin imagen', responseApi.message ?? '');
          print('Response Api Update info user Sin imagen: ${responseApi.data}');
          progressDialog.close();
          if(responseApi.success == true){
            // Actualizamos los valores actualizados en el user de sesion
            GetStorage().write('user', responseApi.data);
            residentProfileInfoController.user.value = User.fromJson(responseApi.data);
          }
        }
        else{  // El usuario selecciono una imagen

          Stream stream = await usersProvider.updateWithImage(Myuser, imageFile!);
          stream.listen((res) {
            progressDialog.close();
            ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
            Get.snackbar('Proceso terminado de actualizacion con Imagen', responseApi.message ?? '');
            print('Respuesta actualizacion Info User con Imagen ${responseApi.data}');
            if(responseApi.success == true){
              // Actualizamos los valores actualizados en el user de sesion
              GetStorage().write('user', responseApi.data);
              residentProfileInfoController.user.value = User.fromJson(responseApi.data);
            }
            else {
              Get.snackbar('Registro fallido al actualizar usuario con imagen', responseApi.message ?? '');
            }
          });

        }





    /*  Stream stream = await usersProvider.createWithImage(Myuser, imageFile!);
      stream.listen((res) {
        progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        print('Respuesta de mandar imagen a Firebase ${responseApi}');
        if(responseApi.success == true){
          GetStorage().write('user', responseApi.data); // Datos del usuario en la sesion.
          // Mandar a pagina de visitante
          goToVisitorPage();

        }
        else {
          Get.snackbar('Registro fallido al guardar imagen', responseApi.message ?? '');
        }
      });*/
    }
  }

  Future selectImage(ImageSource imagenSource) async{
    XFile? image= await picker.pickImage(source: imagenSource);
    if (image != null) {
      imageFile = File(image.path);
      update();    // Obligamos a redibujar los widyets
    }
  }
  void showAlertDialog(BuildContext context){

    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();  // Cerramos el alert
          selectImage(ImageSource.gallery);
        },
        child: Text('Galeria',
            style: TextStyle(
                color: Colors.black
            ))
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();  // Cerramos el alert
          selectImage(ImageSource.camera);
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

}
