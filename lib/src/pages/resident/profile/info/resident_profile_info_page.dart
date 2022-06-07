import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/resident/profile/info/resident_profile_info_controller.dart';
class ResidentProfileInfoPage extends StatelessWidget {

 ResidentProfileInfoController con = Get.put( ResidentProfileInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(   // Posicionar elementos uno arriba del otro
        children: [
          _backgroudCover(context),   // Primero se pone el color amarillo
          _boxForm(context),
          _imageUser( context),
          _buttonSignOut()

        ],
      )),
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        margin: EdgeInsets.only( top: MediaQuery.of(context).size.height * 0.30, left: 50 , right: 50),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                  offset: Offset(0,0.75)
              )
            ]
        ),
        child : SingleChildScrollView(
          child: Column(
              children:[
                _textName(),
                _textEmail(),
                _textPhone(),
                _buttonUpdate(context),
              ]
          ),
        )
    );
  }


  Widget _imageUser(BuildContext context){

    // Aqui se debe usar un gestor de estados para obligar a redibujar el avatar

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 40, bottom: 15),
        alignment: Alignment.topCenter,
        child:  CircleAvatar(
              backgroundImage : con.user.value.imagePath != null
              ? NetworkImage(con.user.value.imagePath!)
              : AssetImage('assets/img/user_profile_textoFoto.png') as ImageProvider,
              radius: 60,
              backgroundColor: Colors.white,
            ),
      ),
    );
  }

 Widget _buttonSignOut() {
   return SafeArea(
       child: Container(
         margin: EdgeInsets.only(right: 20),
         alignment: Alignment.topRight,
         child: IconButton(
           onPressed: () => con.signOut(),
           icon: Icon(
             Icons.power_settings_new,
             color: Colors.white,
             size: 30,
           ),
         ),
       )
   );
 }

 Widget _textName() {
   return Container(
     margin: EdgeInsets.only(top:30),
     child: ListTile(
       leading: Icon(Icons.person),
       title: Text(
         '${con.user.value.name} ${con.user.value.lastname} ${con.user.value.lastname2}'
       ),
       subtitle: Text('Usuario'),
     ),
   );
 }
  Widget _textEmail() {
    return ListTile(
      leading: Icon(Icons.email),
      title: Text(con.user.value.email ?? ''),
      subtitle: Text('Correo'),
    );
  }
 Widget _textPhone() {
   return ListTile(
     leading: Icon(Icons.phone),
     title: Text(con.user.value.phone ?? ''),
     subtitle: Text('Teléfono'),
   );
 }
  Widget _buttonUpdate(BuildContext context){

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: ElevatedButton(
          onPressed: () => con.goToProfileUpdate(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'ACTUALIZAR DATOS',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );

  }
  Widget _backgroudCover(BuildContext context){
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.42,
      color: Colors.amber,

    );
  }
}
