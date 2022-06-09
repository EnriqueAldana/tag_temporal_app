import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdministratorHomeController extends GetxController {

  var indexTab = 0.obs;

  void changeTab(int index) {
    indexTab.value = index;
  }
  void signOut() {
    GetStorage().remove('user');   // Elimina la session.
    Get.offNamedUntil('/', (route) => false); // Elimina el historial de pantallas
  }

}
