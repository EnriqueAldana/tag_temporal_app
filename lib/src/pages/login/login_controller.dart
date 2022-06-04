import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/response_api.dart';
import 'package:tag_temporal_app/src/providers/users_provider.dart';

import '../../models/user.dart';

class LoginController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProvider= UsersProvider();
  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  void login()  async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email ${email}');
    print('Password ${password}');

    if (isValidForm(email, password)) {
        ResponseApi responseApi= await usersProvider.login(email, password);
        print('Response Api : ${responseApi.toJson()}');
        if(responseApi.success == true){
          GetStorage().write('user', responseApi.data); // Datos del usuario en la sesion.
          User myUser= User.fromJson(GetStorage().read('user'));

          if(myUser.roles!.length >1){
            goToRolesPage();
          }
          else {  // Si solo tiene un rol es el de defecto = Visitor
            goToVisitorPage();
          }
        }
        else {
          Get.snackbar('Entrada fallida ...', responseApi.message ?? '');
        }
      
    }
  }

  void goToHomePage(){
    Get.offNamedUntil('/home', (route) => false);
  }
  void goToVisitorPage(){
    Get.offNamedUntil('/visitor/tags/list', (route) => false);
  }

  void goToRolesPage(){
    Get.offNamedUntil('/roles', (route) => false);
  }

  void goToResidentPage(){
    Get.offNamedUntil('/resident/tags/list', (route) => false);
  }

  bool isValidForm(String email, String password) {

    if (email.isEmpty) {
      Get.snackbar('Formulario no válido', 'Debes ingresar el correo.');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Formulario no válido', 'El correo no es valido.');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar la contraseña.');
      return false;
    }

    return true;
  }

}