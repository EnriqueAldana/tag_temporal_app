
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/pages/home/home_page.dart';
import 'package:tag_temporal_app/src/pages/login/login_page.dart';
import 'package:tag_temporal_app/src/pages/register/register_page.dart';

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
  }
  @override
  Widget build(BuildContext context){

    return GetMaterialApp(
      title:'tag Temporal',
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.id != null ? '/home':'/',  // Valida sesion
      getPages: [
        GetPage(name:'/', page: ()=> LoginPage()),
        GetPage(name:'/register', page: ()=> RegisterPage()),
        GetPage(name:'/home', page: ()=> HomePage()),
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