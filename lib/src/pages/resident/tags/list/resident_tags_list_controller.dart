import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ResidentTagsListController extends GetxController {


  void signOut() {
    GetStorage().remove('user');   // Elimina la session.
    Get.offNamedUntil('/', (route) => false); // Elimina el historial de pantallas
  }

}
