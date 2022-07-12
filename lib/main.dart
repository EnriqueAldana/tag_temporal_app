
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/pages/administrator/home/administrator_home_page.dart';
import 'package:tag_temporal_app/src/pages/home/home_page.dart';
import 'package:tag_temporal_app/src/pages/login/login_page.dart';
import 'package:tag_temporal_app/src/pages/register/register_page.dart';
import 'package:tag_temporal_app/src/pages/resident/address/create/resident_address_create_page.dart';
import 'package:tag_temporal_app/src/pages/resident/address/list/resident_address_list_page.dart';
import 'package:tag_temporal_app/src/pages/resident/home/resident_home_page.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/create/resident_orders_create_page.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/detail/resident_orders_detail_page.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/list/resident_orders_list_page.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/map/resident_orders_map_page.dart';
import 'package:tag_temporal_app/src/pages/resident/payments/create/resident_payments_create_page.dart';
import 'package:tag_temporal_app/src/pages/resident/payments/installments/resident_payments_installments_page.dart';
import 'package:tag_temporal_app/src/pages/resident/payments/status/resident_payments_status_page.dart';
import 'package:tag_temporal_app/src/pages/resident/profile/info/resident_profile_info_page.dart';
import 'package:tag_temporal_app/src/pages/resident/profile/update/resident_profile_update_page.dart';
import 'package:tag_temporal_app/src/pages/resident/visitors/list/resident_visitors_list_page.dart';
import 'package:tag_temporal_app/src/pages/roles/roles_page.dart';
import 'package:tag_temporal_app/src/pages/visitor/home/visitor_home_page.dart';
import 'package:tag_temporal_app/src/pages/visitor/orders/detail/visitor_orders_detail_page.dart';
import 'package:tag_temporal_app/src/pages/visitor/orders/list/visitor_orders_list_page.dart';
import 'package:tag_temporal_app/src/pages/visitor/orders/map/visitor_orders_map_page.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});
void main() async {
  await GetStorage.init();
  // Stripe.publishableKey = 'pk_test_51LK7jTGOZgTCxUsdxF6Y9ruTZy5uynEly650rhB5MTkjcCVYnqohbS7tyyzkTL46RzT3t25py3HTXLkr8HFix8c800RnKD5V6b';
 // await Stripe.instance.applySettings();
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
      //initialRoute: '/resident/payments/create',
      initialRoute: userSession.id != null ?  userSession.roles!.length > 1 ? '/roles' : '/resident/home' : '/',
      getPages: [
        GetPage(name:'/', page: ()=> LoginPage()),
        GetPage(name:'/register', page: ()=> RegisterPage()),
        GetPage(name:'/home', page: ()=> HomePage()),
        GetPage(name:'/roles', page: ()=> RolesPage()),
        GetPage(name:'/administrator/home', page: ()=> AdministratorHomePage()),
        GetPage(name:'/visitor/home', page: ()=> VisitorHomePage()),
        GetPage(name:'/visitor/orders/list', page: ()=> VisitorOrdersListPage()),
        GetPage(name:'/visitor/orders/detail', page: ()=> VisitorOrdersDetailPage()),
        GetPage(name:'/visitor/orders/map', page: ()=> VisitorOrdersMapPage()),
        GetPage(name:'/resident/home', page: ()=> ResidentHomePage()),
        GetPage(name:'/resident/profile/info', page: ()=> ResidentProfileInfoPage()),
        GetPage(name:'/resident/profile/update', page: ()=> ResidentProfileUpdatePage()),
        GetPage(name:'/resident/orders/create', page: ()=> ResidentOrdersCreatePage()),
        GetPage(name:'/resident/orders/detail', page: ()=> ResidentOrdersDetailPage()),
        GetPage(name:'/resident/orders/list', page: ()=> ResidentOrdersListPage()),
        GetPage(name:'/resident/orders/map', page: ()=> ResidentOrdersMapPage()),
        GetPage(name:'/resident/address/create', page: ()=> ResidentAddressCreatePage()),
        GetPage(name:'/resident/address/list', page: ()=> ResidentAddressListPage()),
        GetPage(name:'/resident/visitor/list', page: ()=> ResidentVisitorListPage()),
        GetPage(name:'/resident/payments/create', page: ()=> ResidentPaymentsCreatePage()),
        GetPage(name:'/resident/payments/installments', page: ()=> ResidentPaymentsInstallmentsPage()),
        GetPage(name:'/resident/payments/status', page: ()=> ResidentPaymentsStatusPage()),


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