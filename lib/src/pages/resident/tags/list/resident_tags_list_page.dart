import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/resident/tags/list/resident_tags_list_controller.dart';
class ResidentTagsListPage extends StatelessWidget {

 ResidentTagsListController con = Get.put(ResidentTagsListController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Resident  Page',
                style: TextStyle(
                    color: Colors.black
                )),
          ElevatedButton(
            onPressed: () => con.signOut(),
            child: Text(
                'Cerrar sesion',
                style: TextStyle(
                    color: Colors.black
                )
            ),
          )
          ],
        ),
      ),
    );
  }
}
