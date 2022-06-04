import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/roles/roles_controller.dart';
import 'package:tag_temporal_app/src/models/rol.dart';
class RolesPage extends StatelessWidget {

  RolesController con = Get.put(RolesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seleccione el rol',
          style: TextStyle(
              fontSize: 20,
              color: Colors.black

          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric( vertical: MediaQuery.of(context).size.height * 0.2),
        child: ListView(
          children: con.user.roles != null ? con.user.roles!.map((Rol rol) {
            return _cardRol(rol);
          }).toList() : [],
        ),
      ),
    );
  }

  Widget _cardRol(Rol rol){

      return GestureDetector(
        onTap: () => con.goToPageRol(rol),
        child: Column(
          children: [
            Container(  // Imagen
              margin: EdgeInsets.only(top:20 ,bottom: 10),
              height: 100,
              child: FadeInImage(
                image: NetworkImage(rol.image!),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            Text(
              rol.name ??  '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black

              ),
            ),
          ]
        ),
      );

  }
}
