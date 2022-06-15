
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/pages/administrator/home/administrator_home_page.dart';
import 'package:tag_temporal_app/src/pages/administrator/tags/list/administrator_tags_list_page.dart';
import 'package:tag_temporal_app/src/pages/home/home_page.dart';
import 'package:tag_temporal_app/src/pages/login/login_page.dart';
import 'package:tag_temporal_app/src/pages/register/register_page.dart';
import 'package:tag_temporal_app/src/pages/resident/address/create/resident_address_create_page.dart';
import 'package:tag_temporal_app/src/pages/resident/address/list/resident_address_list_page.dart';
import 'package:tag_temporal_app/src/pages/resident/home/resident_home_page.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/create/resident_orders_create_page.dart';
import 'package:tag_temporal_app/src/pages/resident/profile/info/resident_profile_info_page.dart';
import 'package:tag_temporal_app/src/pages/resident/profile/update/resident_profile_update_page.dart';
import 'package:tag_temporal_app/src/pages/resident/tags/list/resident_tags_list_page.dart';
import 'package:tag_temporal_app/src/pages/roles/roles_page.dart';
import 'package:tag_temporal_app/src/pages/visitor/home/visitor_home_page.dart';
import 'package:tag_temporal_app/src/pages/visitor/tags/list/visitor_tags_list_page.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});
void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('El token de sesion del usuario logeado es: ${userSession.sessionToken}');
  }
  @override
  Widget build(BuildContext context){

    return GetMaterialApp(
      title:'tag Temporal',
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.id != null ?  userSession.roles!.length > 1 ? '/roles' : '/resident/home' : '/',
      getPages: [
        GetPage(name:'/', page: ()=> LoginPage()),
        GetPage(name:'/register', page: ()=> RegisterPage()),
        GetPage(name:'/home', page: ()=> HomePage()),
        GetPage(name:'/roles', page: ()=> RolesPage()),
        GetPage(name:'/administrator/home', page: ()=> AdministratorHomePage()),
        GetPage(name:'/visitor/home', page: ()=> VisitorHomePage()),
        GetPage(name:'/resident/home', page: ()=> ResidentHomePage()),
        GetPage(name:'/resident/profile/info', page: ()=> ResidentProfileInfoPage()),
        GetPage(name:'/resident/profile/update', page: ()=> ResidentProfileUpdatePage()),
        GetPage(name:'/resident/orders/create', page: ()=> ResidentOrdersCreatePage()),
        GetPage(name:'/resident/address/create', page: ()=> ResidentAddressCreatePage()),
        GetPage(name:'/resident/address/list', page: ()=> ResidentAddressListPage()),
      ],
      theme: ThemeData(
        primaryColor: Colors.amber,
        colorScheme: ColorScheme(
          primary: Colors.amber,
          secondary: Colors.amberAccent,
          onSecondary: Colors.grey,
          brightness: Brightness.light,
          background: Colors.grey,
          onBackground: Colors.grey,
          onPrimary: Colors.grey,
          surface: Colors.grey,
          onSurface: Colors.grey,
          error: Colors.grey,
          onError: Colors.grey

        )
      ),
      navigatorKey: Get.key,
    );
  }
}