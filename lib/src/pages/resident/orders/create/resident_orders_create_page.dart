import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/create/resident_orders_create_controller.dart';
import 'package:tag_temporal_app/src/widgets/no_data_widget.dart';

import '../../../../models/product.dart';
class ResidentOrdersCreatePage extends StatelessWidget {

  ResidentOrdersCreateController con = Get.put(ResidentOrdersCreateController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: 100,
        child: _totalToPay(context),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          'Mi Orden',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: con.selectedProducts.length >0
          ? ListView(
              children: con.selectedProducts.map((Product product){
                return _cardProduct(product);
              }).toList(),
      )
          : Container(
          alignment: Alignment.center,
          child: NoDataWidget(text:'No hay ningún Tag agregado aún')
          ),
    ));
  }
  Widget _totalToPay(BuildContext context){
    return Column(
      children: [
        Divider(height: 3, color: Colors.grey[400],),
        Container(
          margin: EdgeInsets.only(left: 20,top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'TOTAL: \$ ${con.total.value}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  )
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
               // width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                    onPressed: ()=>{},
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15)
                    ),
                    child: Text(
                        'CONFIRMAR ORDEN',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        )
                    )
                ),
              )
            ],
          ),
        )
      ],
    );
  }
  Widget _cardProduct(Product product){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical:10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  product.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10,),
              _buttomsAddOrRemove(product)
            ],
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product),
              _iconDelete(product)
            ],
          )
        ],
      ),
    );
  }
  Widget _iconDelete(Product product){
    return IconButton(
        onPressed: () => con.deleteItem(product),
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ));
  }
  Widget _textPrice(Product product){
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        '\$ ${ product.price! * product.quantity!}',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget _buttomsAddOrRemove(Product product){
    return Row(
      children: [
        GestureDetector(
        onTap: ()=> con.removeItem(product),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              )
            ),

            child: Text('-'),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 7),
          color: Colors.grey[300],
          child: Text( '${product.quantity ?? 0}'),
        ),
        GestureDetector(
          onTap: () => con.addItem(product),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )
            ),

            child: Text('+'),
          ),
        )
      ],
    );

  }
  Widget _imageProduct(Product product){
    return Container(
        height: 70,
        width: 70,
        child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
    child: FadeInImage(
    image: product.image1 != null
    ? NetworkImage(product.image1!)
        : AssetImage('assets/img/no-image.png') as ImageProvider,
    fit: BoxFit.cover,
    fadeInDuration: Duration(milliseconds: 50),
    placeholder: AssetImage('assets/img/no-image.png'),
    ),
    ),
    );
  }
}
