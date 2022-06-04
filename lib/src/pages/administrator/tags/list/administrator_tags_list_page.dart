import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/administrator/tags/list/administrator_tags_list_controller.dart';
class AdministratorTagsListPage extends StatelessWidget {

  AdministratorTagsListController con = Get.put(AdministratorTagsListController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Administration  Page',
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
