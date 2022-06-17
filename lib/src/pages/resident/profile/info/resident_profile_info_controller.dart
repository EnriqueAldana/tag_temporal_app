import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/user.dart';

class ResidentProfileInfoController extends GetxController{

 var user= User.fromJson(GetStorage().read('user')).obs;

  void signOut() {
    GetStorage().remove('addres');
    GetStorage().remove('shopping_bag');
    GetStorage().remove('user');   // Elimina la session.
    Get.offNamedUntil('/', (route) => false); // Elimina el historial de pantallas
  }
  void goToRoles(){
    Get.offNamedUntil('/roles', (route) => false);
  }

  void goToProfileUpdate(){
    Get.toNamed('/resident/profile/update');
  }
}