import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/map/resident_orders_map_controller.dart';
class ResidentOrdersMapPage extends StatelessWidget {

  ResidentOrdersMapController con = Get.put(ResidentOrdersMapController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResidentOrdersMapController>(
        builder: (value) => Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.60,
              child: _googleMaps()
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonBack(),
                    _icon_centerMyLocation()
                  ],
                ),
                Spacer(),
                _cardOrderProductInfo(context),
              ],
            ),
          ),
          // _buttonAccept(context)
        ],
      ),
    )
    );
  }

  Widget _buttonBack() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 20),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
  Widget _cardOrderProductInfo(BuildContext context){

    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0,3)
          )
        ]
      ),
      child: Column(
        children: [
          _listTileAddress(con.orderProduct.address?.neighborhood ?? '',
          'Colonia o Ciudad',
          Icons.my_location
          ),
          _listTileAddress(
              '${con.orderProduct.address?.addressStreet ?? ''}'
                  ' - ${con.orderProduct.address?.externalNumber ?? ''} '
                  '- ${con.orderProduct.address?.internalNumber ?? ''}'
              ,
              'Calle y Num',
              Icons.location_on
          ),
          Divider(color: Colors.grey,endIndent: 30, indent: 30,),
          _visitorInfo(),

        ],
      ),
    );
  }

  Widget _visitorInfo(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35,vertical: 5),
      child: Row(
        children: [
          _imageVisitor(),
          SizedBox(width: 15,),
          Text(
            '${con.orderProduct.visitor?.name ?? ''} ${con.orderProduct.visitor?.lastname ?? ''} ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            maxLines: 1,
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey[200]
            ),
            child: IconButton(
              onPressed: () => con.callNumber(),
              icon: Icon(Icons.phone, color: Colors.black),
            ),
          )
        ],
      ),

    );
  }
  Widget _imageVisitor(){
    return Container(
      height: 50,
      width: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: con.orderProduct.visitor!.imagePath != null
              ? NetworkImage(con.orderProduct.visitor!.imagePath!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }
  Widget _listTileAddress(String title, String subtitle,IconData iconData){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white
          ),
        ),
        subtitle: Text(
            subtitle,
            style: TextStyle(
                color: Colors.white
            )),
        trailing: Icon(
            iconData,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _icon_centerMyLocation(){
    return GestureDetector(
      onTap:  () => con.centerPosition(),
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardAddress() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            con.addressName.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

      ),
    );
  }

  Widget _googleMaps(){
    return GoogleMap(
        initialCameraPosition: con.initialPosition,
      mapType: MapType.normal,
      onMapCreated: con.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(con.markers.values),
      polylines: con.polylines,

    );
  }
}