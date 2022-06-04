import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/register/register_controller.dart';

class RegisterPage extends StatelessWidget {

RegisterController con = Get.put(RegisterController());
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
    height: MediaQuery.of(context).size.height * 0.70,
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
            _textFieldPassword(),
            _textFieldPasswordConfirm(),
            _buttonRegister(context)
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
        child: GetBuilder<RegisterController>(
          builder: (value) => CircleAvatar(
          backgroundImage: con.imageFile != null
          ? FileImage(con.imageFile!)
              : AssetImage('assets/img/user_profile.png') as ImageProvider,
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

Widget _textFieldPassword(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: con.passwordController,
      keyboardType:  TextInputType.text,
      obscureText:  true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        prefixIcon: Icon(Icons.lock)
      ),
    ),
  );
}Widget _textFieldPasswordConfirm(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: con.confirmPasswordController,
      keyboardType:  TextInputType.text,
      obscureText:  true,
      decoration: InputDecoration(
        hintText: 'Confirmar contraseña',
        prefixIcon: Icon(Icons.lock_outline)
      ),
    ),
  );
}

Widget _textYourInfo(){
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 15),
      child: Text(
        'Ingresa la información siguiente:',
        style: TextStyle(
          color: Colors.black
        ),
        )
        );
}
Widget _buttonRegister(BuildContext context){

  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: ElevatedButton(
    onPressed: ()=> con.register(context),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 15)
    ),
    child: Text(
        'Registrarse',
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