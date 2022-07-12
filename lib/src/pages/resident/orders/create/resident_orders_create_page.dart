import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/user.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/create/resident_orders_create_controller.dart';
import 'package:tag_temporal_app/src/utils/relative_time_util.dart';
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
                margin: EdgeInsets.symmetric(horizontal: 10),
               // width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                    onPressed: ()=> con.goToAddresList(),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15)
                    ),
                    child: Text(
                        'CONFIRMAR ORDEN',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
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
          SizedBox(width: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  product.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 2,),  // NO SE USAN
              _visitDate(product),
              //_buttomsAddOrRemove(product) // NO SE USAN
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
  Widget _visitDate(Product product){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2),
          child: Text(
              'Fecha de visita',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 2),
          child: Text(
            'Desde : ${RelativeTimeUtil.getRelativeTime(product.started_date ?? 0)}',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 2),
          child: Text(
            'Hasta: ${RelativeTimeUtil.getRelativeTime(product.ended_date ?? 0)}',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
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

  Widget _dropDownVisitor(List<User> users){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 55),
        margin: EdgeInsets.only(top:15),
        child: DropdownButton <String>(
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
            'Seleccionar visitante',
            style: TextStyle(
                fontSize: 17
            ),
          ),
          items: _dropDownItems(users),
          value: con.idVisitor.value == '' ? null : con.idVisitor.value,
          onChanged: (option){
            print('Opcion seleccionada de Visitante ${option}');
            con.idVisitor.value =option.toString();
          },
        )
    );
  }
  List<DropdownMenuItem<String>> _dropDownItems(List<User> users){
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Text(user.name ?? ''),
        value: user.id,
      ));
    });

    return list;
  }
}
