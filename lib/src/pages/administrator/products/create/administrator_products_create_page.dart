import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/category.dart';

import 'administrator_productss_create_controller.dart';

class AdministratorProductsCreatePage extends StatelessWidget {

  AdministratorProductsCreateController con = Get.put(AdministratorProductsCreateController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(   // Posicionar elementos uno arriba del otro
        children: [
          _backgroudCover(context),   // Primero se pone el color amarillo
          _boxForm(context),
          _textNewProduct()
        ],
      )),
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
                _dropDownCategories(con.categories),
                _textImages(),
                Container(

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

  Widget _dropDownCategories(List<Category> categories){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 55),
        margin: EdgeInsets.only(top:15),
        child: DropdownButton(
          underline: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.amber,
            ),
          ),
          elevation: 3,
          isExpanded: true,
          hint: Text(
            'Seleccione una categoría',
            style: TextStyle(
              fontSize: 17
            ),
          ),
          items: _dropDownItems(categories),
          value: con.idCategory.value == '' ? null : con.idCategory.value,
          onChanged: (option){
            print('Opcion seleccionada de categoria ${option}');
            con.idCategory.value =option.toString();
          },

        )
    );
  }


  List<DropdownMenuItem<String?>> _dropDownItems(List<Category> categories){
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
          child: Text(category.name ?? ''),
          value: category.id,
      ));
    });

    return list;
  }


Widget _cardImage(BuildContext context ,File? imageFile, int numberFile){

    return  GestureDetector(
          onTap: () => con.showAlertDialog(context, numberFile),
          child:  Card(
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 70,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: imageFile != null
                      ? Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    )
                        : Image(
                      image: AssetImage('assets/img/cover_image.png'),
                )
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
              color: Colors.black,
              fontSize: 17
          ),
        )
    );
  }
  Widget _textImages(){
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Text(
          'Carge las imagenes del producto.',
          style: TextStyle(
              fontSize: 17
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
           con.createProduct(context);
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
