import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/providers/users_provider.dart';

class RegisterController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController lastname2Controller = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  void register( BuildContext context) async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String lastname2 = lastname2Controller.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    print('Email ${email}');
    print('Password ${password}');

    if (isValidForm(email, name, lastname,lastname2, phone, password, confirmPassword)) {

      ProgressDialog progressDialog= ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Registrando usuario...');

      User user = User(
        email: email,
        name: name,
        lastname: lastname,
        lastname2: lastname2,
        phone: phone,
        password: password,
      );

      Stream stream = await usersProvider.createWithImage(user, imageFile!);
      stream.listen((res) {
         progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        if(responseApi.success == true){
          GetStorage().write('user', responseApi.data); // Datos del usuario en la sesion.
          // Mandar a pagina de visitante
          goToVisitorPage();

        }
        else {
          Get.snackbar('Registro fallido', responseApi.message ?? '');
        }
      });
      
    }
  }

  void goToVisitorPage(){
    Get.offNamedUntil('/visitor/tags/list', (route) => false);
  }
  bool isValidForm(
      String email,
      String name,
      String lastname,
      String lastname2,
      String phone,
      String password,
      String confirmPassword
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

    if (password.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar el password');
      return false;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar la confirmacion del password');
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar('Formulario no valido', 'los password no coinciden');
      return false;
    }

    return true;
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
      title: Text('Selecciona una opción'),
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