import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/pages/visitor/orders/detail/visitor_orders_detail_controller.dart';
import 'package:tag_temporal_app/src/utils/constants.dart';
import 'package:tag_temporal_app/src/utils/relative_time_util.dart';
import 'package:tag_temporal_app/src/widgets/no_data_widget.dart';

class VisitorOrdersDetailPage extends StatelessWidget {

  VisitorOrdersDetailController con= Get.put(VisitorOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            _dataDate(),
            _dataResident(),
            _dataAddress(),
            _dataVisitor(),
            _totalToPay(context),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
            'tagTemporal #${con.orderProduct.idOrder}-${con.orderProduct.product!.id}-${ RelativeTimeUtil.getRelativeTime(con.orderProduct.product!.started_date ?? 0)}',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),

    );
  }

Widget _dataResident(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
          title: Text('Residente'),
          subtitle: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                child: FadeInImage(
                  image: con.orderProduct.resident!.imagePath !=null
                      ? NetworkImage(con.orderProduct.resident!.imagePath)
                      : AssetImage('assets/img/no-image.png') as ImageProvider,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('assets/img/no-image.png'),
                ),
              ),
              SizedBox(width: 15,),
              Text('${con.orderProduct.resident?.name ?? ''} ${con.orderProduct.resident?.lastname ?? ''} - Tel:  ${con.orderProduct.resident?.phone ?? ''}'),
            ],
          ),
          trailing: Icon(Icons.person),
      ),
    );
}
  Widget _dataAddress(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion de visita'),
        subtitle: Text(' ${con.orderProduct.address?.addressStreet ?? ''} ${con.orderProduct.address?.externalNumber ?? ''} ${con.orderProduct.address?.internalNumber ?? ''} ${con.orderProduct.address?.neighborhood ?? ''} ${con.orderProduct.address?.state ?? ''} ${con.orderProduct.address?.country ?? ''} ${con.orderProduct.address?.postalCode ?? ''}'),
        trailing: Icon(Icons.location_on),
      ),
    );
  }
  Widget _dataDate(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha de solicitud'),
        subtitle: Text(' ${RelativeTimeUtil.getRelativeTime(con.orderProduct.timestamp ?? 0)}'),
        trailing: Icon(Icons.timer),
      ),
    );
  }

  Widget _dataVisitor(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Visitante'),
        subtitle: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              child: FadeInImage(
                image: con.orderProduct.visitor!.imagePath !=null
                    ? NetworkImage(con.orderProduct.visitor!.imagePath)
                    : AssetImage('assets/img/no-image.png') as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(width: 15,),
            Text(
                '${con.orderProduct.visitor!.name  ?? ''} ${ con.orderProduct.visitor!.lastname  ?? ''}',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold
                )
            ),
          ],
        ),
        trailing: Icon(Icons.people_rounded),
      ),

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
              SizedBox(height: 3,),
              Text(
                'Cantidad: ${product.quantity}',
                style: TextStyle(
                    fontSize: 12
                ),
              ),
              SizedBox(height: 3,),
              Text(
                'Precio: ${product.price}',
                style: TextStyle(
                    fontSize: 12
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _imageProduct(Product product){
    return Container(
      height: 50,
      width: 50,
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

  Widget _totalToPay(BuildContext context){
    return Column(
      children: [
        Divider(height: 3, color: Colors.grey[400],),
        Container(
          margin: EdgeInsets.only(left: 20,top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              con.orderProduct.status_product == Constants.ORDER_PRODUCT_STATUS_ASIGNADO
                  ? _buttonUpdateOrderProduct()
                  : con.orderProduct.status_product == Constants.ORDER_PRODUCT_STATUS_ENCAMINO
                  ? _buttonGoToOrderProductMap()
                  : Container()

            ],
          ),
        )
      ],
    );
  }

  Widget _buttonUpdateOrderProduct(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      // width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
          onPressed: ()=> con.updateOrderProductToENCAMINO(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15)
          ),
          child: Text(
              'VISITAR',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              )
          )
      ),
    );
  }
  Widget _buttonGoToOrderProductMap(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      // width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
          onPressed: ()=> con.goToOrderProductMap(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
            primary: Colors.lightGreenAccent
          ),
          child: Text(
              'Ir al MAPA',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              )
          )
      ),
    );
  }
}
