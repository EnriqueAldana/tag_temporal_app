import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_temporal_app/src/models/order.dart';
import 'package:tag_temporal_app/src/pages/resident/orders/list/resident_orders_list_controller.dart';
import 'package:tag_temporal_app/src/widgets/no_data_widget.dart';

import '../../../../utils/relative_time_util.dart';


class ResidentOrdersListPage extends StatelessWidget {

  ResidentOrdersListController con = Get.put(ResidentOrdersListController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
        length: con.status.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                tabs: List<Widget>.generate(con.status.length, (index) {
                  return Tab(
                    child: Text(con.status[index]),
                  );
                }),
              ),
            ),
          ),
          body: TabBarView(
            children: con.status.map((String status) {
              return FutureBuilder(
                  future: con.getOrders(status) ,
                  builder: (context, AsyncSnapshot<List<Order>> snapshot){
                    if (snapshot.hasData){
                      if(snapshot.data!.length >0){
                        return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_ , index){
                              return _cardOrder(snapshot.data![index]);
                            }
                        );
                      }
                      else{
                        return Center(child: NoDataWidget(text:'No hay tags ordenados con éste estado'));
                      }

                    }
                    else {
                      return Center(child: NoDataWidget(text:'No hay tags ordenados con éste estado'));
                    }
                  }
              );
            }).toList(),
          ),
        )
    ));
  }

  Widget _cardOrder(Order order){
    return GestureDetector(
      onTap: () => con.goToOrderDetail(order),
      child: Container(
        height: 150,
          margin: EdgeInsets.only(left: 20,right: 20,top: 10),
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            child: Stack(
              children: [
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)
                    )
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top:5),
                    child: Text(
                      'tagTemporal #${order.id}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15

                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:15, left: 20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 5),
                          alignment: Alignment.centerLeft,
                          child: Text('Solicitado: ${ RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}')
                      ),
                      Container(
                          width: double.infinity,
                        margin: EdgeInsets.only(top: 5),
                          alignment: Alignment.centerLeft,
                          child: Text('Residente: ${order.resident?.name ?? ''} ${order.resident?.lastname ?? ''} ${order.resident?.lastname2?? ''}'),
                      ),
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 5),
                          alignment: Alignment.centerLeft,
                          child:  Text('Dirección: ${order.address?.addressStreet ?? ''} ${order.address?.externalNumber ?? ''} ${order.address?.internalNumber ?? ''} ${order.address?.neighborhood ?? ''}')
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
