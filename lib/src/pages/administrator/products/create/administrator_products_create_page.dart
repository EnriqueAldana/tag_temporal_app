import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/administrator/categories/create/Administrator_categories_create_controller.dart';

import 'administrator_productss_create_controller.dart';

class AdministratorProductsCreatePage extends StatelessWidget {

  AdministratorProductsCreateController con = Get.put(AdministratorProductsCreateController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(   // Posicionar elementos uno arriba del otro
        children: [
          _backgroudCover(context),   // Primero se pone el color amarillo
          _boxForm(context),
          _textNewProduct()


        ],
      ),
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        margin: EdgeInsets.only( top: MediaQuery.of(context).size.height * 0.18, left: 50 , right: 50),
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
                _textFieldPrice(),
                _textImages(),
                Container(
                  margin: EdgeInsets.only(top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  GetBuilder<AdministratorProductsCreateController>(
                  builder: (value) =>_cardImage(context, con.imageFile1,1)
                  ),
                  SizedBox(width: 5),
                  GetBuilder<AdministratorProductsCreateController>(
                  builder: (value) =>_cardImage(context, con.imageFile2,2)
                  ),
                      SizedBox(width: 5),
                  GetBuilder<AdministratorProductsCreateController>(
                    builder: (value) =>_cardImage(context, con.imageFile3,3)
                  )
                    ],
                  ),

                ),
                _buttonCreate(context)
              ]
          ),
        )
    );
  }

Widget _cardImage(BuildContext context ,File? imageFile, int numberFile){

    return GetBuilder<AdministratorProductsCreateController>(
        builder: (value) => GestureDetector(
          onTap: () => con.showAlertDialog(context, numberFile),
          child: imageFile!= null
              ? Card(
                elevation: 3,
                child: Container(
                  height: 70,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    )
                ),
              )
              : Card(
            elevation: 3,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Image(
                image: AssetImage('assets/img/cover_image.png'),
              ),
            ),
          ),
        )
    );

}

  Widget _textNewProduct(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 25),
        alignment: Alignment.topCenter,
        child: Text('NUEVO PRODUCTO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23
            ),
            ),
        )
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

  Widget _textFieldPrice(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.priceController,
        keyboardType:  TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Precio',
            prefixIcon: Icon(Icons.attach_money)
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
  Widget _textImages(){
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Text(
          'Imagenes del producto',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );
  }
  Widget _buttonCreate(BuildContext context){

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: ElevatedButton(
         onPressed: (){
           con.createCategory();
         },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CREAR PRODUCTO',
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
