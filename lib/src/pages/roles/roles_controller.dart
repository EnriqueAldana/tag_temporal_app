import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/models/rol.dart';

class RolesController extends GetxController {

  User user = User.fromJson(GetStorage().read('user') ?? {});

  void goToPageRol(Rol rol) {
    Get.offNamedUntil(rol.route ?? '', (route) => false);

  }

}