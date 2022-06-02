import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  void register() async {
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
      User user = User(
        email: email,
        name: name,
        lastname: lastname,
        lastname2: lastname2,
        phone: phone,
        password: password,
      );

      Response response= await usersProvider.create(user);
      print('RESPONSE: ${response.body}');
      if(response.statusCode == 200){
        Get.snackbar('Registro exitoso', 'Su registro ha sido ingresado al sistema. Ahora puede ingresar.');
      }else{
        Get.snackbar('Error en el registro', 'Ha ocurrido un error: ${response.body}');
      }
      
    }
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