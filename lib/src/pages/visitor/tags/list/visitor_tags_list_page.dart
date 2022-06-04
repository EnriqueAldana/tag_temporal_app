import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/visitor/tags/list/visitor_tags_list_controller.dart';
class VisitorTagsListPage extends StatelessWidget {

  VisitorTagsListController con = Get.put(VisitorTagsListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
            'Visitor Page',
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
