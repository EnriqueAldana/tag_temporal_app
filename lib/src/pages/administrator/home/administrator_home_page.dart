import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/administrator/categories/create/administrator_categories_create_page.dart';
import 'package:tag_temporal_app/src/pages/administrator/products/create/administrator_products_create_page.dart';
import 'package:tag_temporal_app/src/pages/administrator/tags/list/administrator_tags_list_page.dart';
import 'package:tag_temporal_app/src/pages/resident/profile/info/resident_profile_info_page.dart';
import 'package:tag_temporal_app/src/pages/resident/tags/list/resident_tags_list_controller.dart';
import 'package:tag_temporal_app/src/pages/visitor/tags/list/visitor_tags_list_page.dart';
import 'package:tag_temporal_app/src/utils/custom_animated_bottom_bar.dart';

import 'administrator_home_controller.dart';

class AdministratorHomePage extends StatelessWidget {

  AdministratorHomeController con = Get.put(AdministratorHomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(() =>
      IndexedStack(
        index: con.indexTab.value,
        children: [
          AdministratorTagsListPage(),
          AdministratorCategoriesCreatePage(),
          AdministratorProductsCreatePage(),
         ResidentProfileInfoPage(),

        ],
      ))
    );
  }

  Widget _bottomBar() {
    return Obx(() =>
      CustomAnimatedBottomBar(
      containerHeight:  70,
        backgroundColor: Colors.amber,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: con.indexTab.value,
      onItemSelected: (index ) => con.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Tags'),
            activeColor: Colors.white,
            inactiveColor: Colors.black
            ),
        BottomNavyBarItem(
            icon: Icon(Icons.category),
            title: Text('Categorias'),
            activeColor: Colors.white,
            inactiveColor: Colors.black
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.production_quantity_limits),
            title: Text('Productos'),
            activeColor: Colors.white,
            inactiveColor: Colors.black
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
            activeColor: Colors.white,
            inactiveColor: Colors.black
        )
      ],

    ));
 }
}
