import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/pages/resident/products/detail/resident_products_detail_controller.dart';
class ResidentProductsDetailPage extends StatelessWidget {

  Product? product;

  late ResidentProductsDetailController con ;

  var counter = 1.obs;
  var  price= 0.0.obs ;

  ResidentProductsDetailPage({@required this.product}) {
    con = Get.put(ResidentProductsDetailController());
  }

  @override
  Widget build(BuildContext context) {
    con.checkIfProductsWasAdded(product!, price, counter);
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
          height: 200,
          child: _buttonsAddToBag(context)
      ),
      body:  Column(
          children: [
            _imageSlideshow(context),
            _textNameProduct(),
            _textDescriptionProduct(),
            _textPriceProduct(),
          ],
      ),
    ));
  }


  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Text(
          product?.name ?? '',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black

          )
      ),
    );
  }

  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Text(
          product?.description ?? '',
          style: TextStyle(
            fontSize: 16,


          )
      ),
    );
  }

  Widget _textPriceProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 15, left: 30, right: 30),
      child: Text(
          '\$ ${product?.price.toString() ?? ''}',
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold
          )
      ),
    );
  }

  Widget _textFieldStartedDate(BuildContext context){
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        onTap: () => con.getDataPicker(context),
        controller: con.startedDateController,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        keyboardType:  TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Fecha de visita.',
            prefixIcon: Icon(Icons.calendar_today)
        ),
      ),
    );
  }
  Widget _textFieldStartedTime(BuildContext context){
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        onTap: () => con.getTimePicker(context),
        controller: con.startedTimeController,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        keyboardType:  TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Hora de visita',
            prefixIcon: Icon(Icons.lock_clock)
        ),
      ),
    );
  }
  Widget _visitDate(BuildContext context){
    return Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 5),
        child: Column(
          children: [
            Text('Fijar la fecha para visita',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
            ),
            _textFieldStartedDate(context),
            _textFieldStartedTime(context),

          ],
        )
    );
  }
  Widget _buttonsAddToBag(BuildContext context) {
    return Column(
      children: [
        Divider(height: 3, color: Colors.grey),
        _visitDate(context),
        Divider(height: 3, color: Colors.grey),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: ()=> con.addToBag(product!, price,counter),
                child: Text(
                  'Agregar \$${price.value }',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    )
                ),
              )
            ],
          )
        )

      ],

    );
  }

  Widget _imageSlideshow(BuildContext context) {
    return ImageSlideshow(
        width: double.infinity,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.4,
        initialPage: 0,
        indicatorBackgroundColor: Colors.grey,
        children: [
          FadeInImage(
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
              image: product!.image1 != null
                  ? NetworkImage(product!.image1!)
                  : AssetImage('assets/img/no-image') as ImageProvider
          ),
          FadeInImage(
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
              image: product!.image2 != null
                  ? NetworkImage(product!.image2!)
                  : AssetImage('assets/img/no-image') as ImageProvider
          ),
          FadeInImage(
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
              image: product!.image3 != null
                  ? NetworkImage(product!.image3!)
                  : AssetImage('assets/img/no-image') as ImageProvider
          )
        ]);
  }


}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}