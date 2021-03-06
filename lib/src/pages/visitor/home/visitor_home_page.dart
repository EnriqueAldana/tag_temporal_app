import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/administrator/tags/list/administrator_tags_list_page.dart';
import 'package:tag_temporal_app/src/pages/resident/profile/info/resident_profile_info_page.dart';
import 'package:tag_temporal_app/src/pages/resident/tags/list/resident_tags_list_controller.dart';
import 'package:tag_temporal_app/src/pages/visitor/home/visitor_home_controller.dart';
import 'package:tag_temporal_app/src/pages/visitor/orders/list/visitor_orders_list_page.dart';
import 'package:tag_temporal_app/src/pages/visitor/tags/list/visitor_tags_list_page.dart';
import 'package:tag_temporal_app/src/utils/custom_animated_bottom_bar.dart';

class VisitorHomePage extends StatelessWidget {

 VisitorHomeController con = Get.put(VisitorHomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(() =>
      IndexedStack(
        index: con.indexTab.value,
        children: [
          VisitorOrdersListPage(),
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
            title: Text('Mis tags'),
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
