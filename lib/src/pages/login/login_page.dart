
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/login/login_controller.dart';

class LoginPage
 extends StatelessWidget {
   LoginController con = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        child: _textDontHaveAccount(),
      ),

      body: Stack(   // Posicionar elementos uno arriba del otro
        children: [
          _backgroudCover(context),   // Primero se pone el color amarillo 
          _boxForm(context),
          Column(children: [   // Segundo arriba del fondo se coloca la imagen y el texto
             _imageCover(),
             _textAppName()
          ],)
         

        ],
      ),
    );
  }

  // Metodo privado

Widget _boxForm(BuildContext context){
  return Container(
    height: MediaQuery.of(context).size.height * 0.45,
    margin: EdgeInsets.only( top: MediaQuery.of(context).size.height * 0.42, left: 50 , right: 50),
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
            _textFieldPassword(),
            _buttonLogin()
        ]
      ),
    )
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
}

Widget _textYourInfo(){
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 45),
      child: Text(
        'Ingresa la información siguiente:',
        style: TextStyle(
          color: Colors.black
        ),
        )
        );
}
Widget _buttonLogin(){

  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: ElevatedButton(
    onPressed: () => con.login(),  
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 15)
    ),
    child: Text(
        'Entrar',
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
      height: MediaQuery.of(context).size.height * 0.48,
      color: Colors.amber,
      
    );
  }
  Widget _textDontHaveAccount(){

    return  Row( // Ubicar elelemntos uno al lado del otro
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text(
        '¿ No tienes cuenta ?',
        style: TextStyle(
          color: Colors.black,
          fontSize: 17
        )
      ),
      SizedBox(width: 7,),
      GestureDetector(
        onTap: () => con.goToRegisterPage(),
        child: Text(
          'Registrate aqui.',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 17
          )
        ),
      )
    ],);

  }
  Widget _textAppName(){
    return Text('Sistema automático de control de acceso.',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black
      )
    );
  }
  Widget _imageCover(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 1, bottom: 1),
        alignment: Alignment.center ,
        child: Image.asset(
        'assets/img/tagTemporal_Logo_Ambar.PNG',
        width: 220,
        height: 200,

      ),
    ),
    );
    
  }
}