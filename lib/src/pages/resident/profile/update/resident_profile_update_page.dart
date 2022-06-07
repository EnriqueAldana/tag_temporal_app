
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/resident/profile/update/resident_profile_update_controller.dart';
class ResidentProfileUpdatePage extends StatelessWidget {

ResidentProfileUpdateController con = Get.put(ResidentProfileUpdateController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(   // Posicionar elementos uno arriba del otro
        children: [
          _backgroudCover(context),   // Primero se pone el color amarillo
          _boxForm(context),
          _imageUser( context),
          _buttonBack()


        ],
      ),
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height * 0.55,
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
                _textYourInfo(),
                _textFieldEmail(),
                _textFieldName(),
                _textFieldLastName(),
                _textFieldLastName2(),
                _textFieldPhone(),
                _buttonUpdate(context)
              ]
          ),
        )
    );
  }

  Widget _buttonBack() {
    return SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
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
        child: GestureDetector(
          onTap: () => con.showAlertDialog(context),
          child: GetBuilder<ResidentProfileUpdateController>(
            builder: (value) => CircleAvatar(
              backgroundImage: con.imageFile != null
                  ? FileImage(con.imageFile!)
              : con.user.imagePath != null
                ? NetworkImage(con.user.imagePath!)
                  : AssetImage('assets/img/user_profile_textoFoto.png') as ImageProvider,
              radius: 60,
              backgroundColor: Colors.white,
            ),
          ),
        ),

      ),
    );
  }
  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.emailController,
        keyboardType:  TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo electrónico',
            prefixIcon: Icon(Icons.email)
        ),
      ),
    );
  }
  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.nameController,
        keyboardType:  TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre',
            prefixIcon: Icon(Icons.person)
        ),
      ),
    );
  }
  Widget _textFieldLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.lastnameController,
        keyboardType:  TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Apellido paterno',
            prefixIcon: Icon(Icons.person_outline)
        ),
      ),
    );
  }
  Widget _textFieldLastName2(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.lastname2Controller,
        keyboardType:  TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Apellido materno',
            prefixIcon: Icon(Icons.person_outline)
        ),
      ),
    );
  }
  Widget _textFieldPhone(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.phoneController,
        keyboardType:  TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Num. Celular',
            prefixIcon: Icon(Icons.phone)
        ),
      ),
    );
  }


  Widget _textYourInfo(){
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Text(
          'Ingresa la información siguiente:',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );
  }
  Widget _buttonUpdate(BuildContext context){

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
          onPressed: ()=> con.updateInfo(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'ACTUALIZAR',
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
