import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/administrator/categories/create/Administrator_categories_create_controller.dart';

class AdministratorCategoriesCreatePage extends StatelessWidget {

  AdministratorCategoriesCreateController con = Get.put(AdministratorCategoriesCreateController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(   // Posicionar elementos uno arriba del otro
        children: [
          _backgroudCover(context),   // Primero se pone el color amarillo
          _boxForm(context),
          _textNewCategory()


        ],
      ),
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height * 0.40,
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
                _textFieldName(),
                _textFieldDescription(),
                _buttonCreate(context)
              ]
          ),
        )
    );
  }



  Widget _textNewCategory(){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 35, bottom: 15),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Icon(Icons.category, size: 150),
            Text('NUEVA CATEGORIA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23
            ),
            ),
          ],
        )

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
            prefixIcon: Icon(Icons.category)
        ),
      ),
    );
  }
  Widget _textFieldDescription(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40 , vertical: 20 ),
      child: TextField(
       controller: con.descriptionController,
        keyboardType:  TextInputType.text,
        maxLines: 4,
        decoration: InputDecoration(
            hintText: 'Descripcion',
            prefixIcon: Container(
              margin: EdgeInsets.only(bottom:50),
                child: Icon(Icons.description))
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
  Widget _buttonCreate(BuildContext context){

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
         onPressed: (){
           con.createCategory();
         },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CREAR CATEGORIA',
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
