
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/resident/address/create/resident_address_create_controller.dart';

class ResidentAddressCreatePage extends StatelessWidget {

ResidentAddressCreateController con = Get.put(ResidentAddressCreateController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(   // Posicionar elementos uno arriba del otro
        children: [
          _backgroudCover(context),   // Primero se pone el color amarillo
          _boxForm(context),
          _textNewAddress(),
          _icoBack()
        ],
      ),
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        margin: EdgeInsets.only( top: MediaQuery.of(context).size.height * 0.23, left: 50 , right: 50),
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
                _textFieldAddressStreet(),
                _textFieldExternalNumber(),
                _textFieldInternalNumber(),
                _textFieldNeighborhood(),
                _textFieldState(),
                _textFieldCountry(),
                _textFieldPostalCode(),
                _textFieldRefPoint(context),
                _buttonCreate(context)
              ]
          ),
        )
    );
  }

  Widget _icoBack(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 15),
        child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, size: 30,)
        ),
      ),
    );
  }


  Widget _textNewAddress(){

    return SafeArea(
      child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 5),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Icon(Icons.location_on, size: 100),
              Text('NUEVA DIRECCION',
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

  Widget _textFieldAddressStreet(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.address_streetController,
        keyboardType:  TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Calle',
            prefixIcon: Icon(Icons.streetview)
        ),
      ),
    );
  }
Widget _textFieldExternalNumber(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: con.external_numberController,
      keyboardType:  TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Num Ext',
          prefixIcon: Icon(Icons.numbers)
      ),
    ),
  );
}

Widget _textFieldInternalNumber(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: con.internal_numberController,
      keyboardType:  TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Num Int',
          prefixIcon: Icon(Icons.numbers)
      ),
    ),
  );
}
Widget _textFieldNeighborhood(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: con.neighborhoodController,
      keyboardType:  TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Colonia y Mpio',
          prefixIcon: Icon(Icons.location_city)
      ),
    ),
  );
}

Widget _textFieldState(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: con.stateController,
      keyboardType:  TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Estado',
          prefixIcon: Icon(Icons.location_on)
      ),
    ),
  );
}

Widget _textFieldCountry(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: con.countryController,
      keyboardType:  TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Pais',
          prefixIcon: Icon(Icons.flight_land)
      ),
    ),
  );
}
Widget _textFieldPostalCode(){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      controller: con.postal_codeController,
      keyboardType:  TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Código postal',
          prefixIcon: Icon(Icons.folder_zip)
      ),
    ),
  );
}
Widget _textFieldRefPoint(BuildContext context){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    child: TextField(
      onTap: () => con.openGoogleMaps(context),
      controller: con.refPointController,
      autofocus: false,
      focusNode: AlwaysDisabledFocusNode(),
      keyboardType:  TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Punto de referencia GPS',
          prefixIcon: Icon(Icons.map)
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
            //con.createCategory();
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CREAR DIRECCION',
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}