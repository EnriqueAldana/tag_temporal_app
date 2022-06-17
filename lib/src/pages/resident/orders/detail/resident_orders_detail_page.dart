import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/detail/resident_orders_detail_controller.dart';
import 'package:tag_temporal_app/src/utils/relative_time_util.dart';
import 'package:tag_temporal_app/src/widgets/no_data_widget.dart';

class ResidentOrdersDetailPage extends StatelessWidget {

  ResidentOrdersDetailController con= Get.put(ResidentOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          children: [
            _dataDate(),
            _dataResident(),
            _dataAddress(),
            _totalToPay(context),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'tagTemporal #${con.order.id}',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body:con.order.products!.isNotEmpty
          ? ListView(
        children: con.order.products!.map((Product product){
          return _cardProduct(product);
        }).toList(),
      )
          : Container(
          alignment: Alignment.center,
          child: NoDataWidget(text:'No hay ningún Tag agregado aún')
      ),
    ));
  }

Widget _dataResident(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
          title: Text('Residente'),
          subtitle: Text('${con.order.resident?.name ?? ''} ${con.order.resident?.lastname ?? ''} - Tel:  ${con.order.resident?.phone ?? ''}'),
          trailing: Icon(Icons.person),
      ),
    );
}
  Widget _dataAddress(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion de visita'),
        subtitle: Text('${con.order.address?.addressStreet ?? ''} ${con.order.address?.externalNumber ?? ''} ${con.order.address?.internalNumber ?? ''} ${con.order.address?.neighborhood ?? ''}'),
        trailing: Icon(Icons.location_on),
      ),
    );
  }
  Widget _dataDate(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha de solicitud'),
        subtitle: Text(' ${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}'),
        trailing: Icon(Icons.timer),
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
              Text(
                  'TOTAL: \$ ${con.total.value}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  )
              ),

            ],
          ),
        )
      ],
    );
  }
}
