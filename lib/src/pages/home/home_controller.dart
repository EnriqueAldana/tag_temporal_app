import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/user.dart';

class HomeController extends GetxController {

  User user = User.fromJson(GetStorage().read('user') ?? {});

  HomeController(){
    print('Usuario de sesion: ${user.toJson()}');
  }
  void signOut() {
    GetStorage().remove('user');   // Elimina la session.
    Get.offNamedUntil('/', (route) => false); // Elimina el historial de pantallas
  }
}